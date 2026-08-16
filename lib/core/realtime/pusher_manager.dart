// ignore_for_file: avoid_print
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';
import 'package:restaurants_system/constants.dart';
import 'package:restaurants_system/features/auth/domain/repositories/auth_repository.dart';

class PusherManager {
  PusherManager._();

  static final PusherManager instance = PusherManager._();

  AuthRepository? _authRepository;

  final Set<String> subscribedChannels = {};

  bool _isInitialized = false;

  // بدل ما نعتمد على متغير bool ثابت، منستخدم Completer عشان نضمن
  // إنو ما في اتصالين شغالين بنفس الوقت (race condition)
  Completer<void>? _connectingCompleter;

  // الحالة الحقيقية للاتصال، مبنية على event من الـ SDK نفسها
  // مش على افتراضنا إنو الاتصال نجح
  String _connectionState = "DISCONNECTED";

  final PusherChannelsFlutter _pusher = PusherChannelsFlutter.getInstance();

  Function(Map<String, dynamic>)? onOrderUpdate;

  bool get isConnected => _connectionState == "CONNECTED";

  void setAuthRepository(AuthRepository authRepository) {
    _authRepository = authRepository;
  }

  Future<void> initialize() async {
    if (_isInitialized) return;
    try {
      await _pusher.init(
        apiKey: "5a6878ae6a228b5660f4",
        cluster: "eu",
        onEvent: _onEvent,
        onAuthorizer: _onAuthorizer,
        onConnectionStateChange: _onConnectionStateChange,
        onError: _onError,
      );
      _isInitialized = true;
    } catch (e) {
      print("PUSHER INIT ERROR: $e");
      rethrow;
    }
  }

  void _onConnectionStateChange(String currentState, String previousState) {
    print("PUSHER STATE: $previousState -> $currentState");
    _connectionState = currentState;
  }

  void _onError(String message, int? code, dynamic exception) {
    print("PUSHER ERROR: code=$code message=$message exception=$exception");
  }

  /// يضمن عدم وجود أكثر من عملية اتصال شغالة بنفس الوقت.
  /// إذا في عملية اتصال جارية فعلاً، منستنى نتيجتها بدل ما نبلش وحدة جديدة.
  Future<void> connect() async {
    if (isConnected) {
      print("Pusher already connected");
      return;
    }

    if (_connectingCompleter != null) {
      print("Pusher connect already in progress, awaiting it");
      return _connectingCompleter!.future;
    }

    final completer = Completer<void>();
    _connectingCompleter = completer;

    try {
      print("Pusher connecting...");
      await _pusher.connect();

      // ننتظر فعلياً وصول onConnectionStateChange لـ CONNECTED
      // بدل ما نفترض إنو connect() النجاحها يعني اتصال فعلي
      await _waitUntilConnected();

      print("Pusher connected");
      completer.complete();
    } catch (e) {
      print("Pusher connection ERROR: $e");
      completer.completeError(e);
      rethrow;
    } finally {
      _connectingCompleter = null;
    }
  }

  Future<void> _waitUntilConnected({
    Duration timeout = const Duration(seconds: 10),
  }) async {
    if (isConnected) return;

    final completer = Completer<void>();
    late final Timer timer;

    void check(Timer t) {
      if (isConnected) {
        t.cancel();
        if (!completer.isCompleted) completer.complete();
      }
    }

    timer = Timer.periodic(const Duration(milliseconds: 150), check);

    return completer.future.timeout(
      timeout,
      onTimeout: () {
        timer.cancel();
        throw TimeoutException("Pusher did not reach CONNECTED state in time");
      },
    );
  }

  Future<void> subscribeToOrder(int orderId) async {
    final channelName = "private-orders.$orderId";
    if (subscribedChannels.contains(channelName)) {
      print("Already subscribed to $channelName, skipping");
      return;
    }
    try {
      await _pusher.subscribe(channelName: channelName);
      subscribedChannels.add(channelName);
    } catch (e) {
      print("SUBSCRIBE ERROR ($channelName): $e");
    }
  }

  Future<void> unsubscribeFromOrder(int orderId) async {
    final channelName = "private-orders.$orderId";
    if (!subscribedChannels.contains(channelName)) return;

    try {
      await _pusher.unsubscribe(channelName: channelName);
    } catch (e) {
      print("UNSUBSCRIBE ERROR ($channelName): $e");
    } finally {
      subscribedChannels.remove(channelName);
    }
  }

  Future<void> unsubscribeAll() async {
    for (final channel in [...subscribedChannels]) {
      try {
        await _pusher.unsubscribe(channelName: channel);
      } catch (e) {
        print("UNSUBSCRIBE ALL ERROR ($channel): $e");
      }
    }
    subscribedChannels.clear();
  }

  Future<void> disconnect() async {
    try {
      print(
        "PUSHER DISCONNECT | "
        "state=$_connectionState | "
        "connecting=${_connectingCompleter != null}",
      );

      await unsubscribeAll();
      await _pusher.disconnect();
    } catch (e) {
      print("DISCONNECT ERROR: $e");
    } finally {
      _connectionState = "DISCONNECTED";
      _connectingCompleter = null;
    }
  }

  Future<void> _onEvent(event) async {
    if (event.data == null) return;
    if (event.eventName != "order.status.changed") return;

    try {
      final data = jsonDecode(event.data);
      onOrderUpdate?.call(data);
    } catch (e) {
      print("EVENT PARSE ERROR: $e");
    }
  }

  Future<dynamic> _onAuthorizer(
    String channelName,
    String socketId,
    dynamic options,
  ) async {
    final authRepo = _authRepository;
    if (authRepo == null) {
      throw Exception("PusherManager: AuthRepository not set");
    }

    final token = await authRepo.getCurrentToken();

    print(
      "PUSHER AUTH: channel=$channelName socketId=$socketId "
      "tokenExists=${token != null} tokenLen=${token?.length}",
    );

    if (token == null || token.isEmpty) {
      throw Exception(
        "Pusher auth failed: no auth token available (user not logged in / token not ready)",
      );
    }

    final response = await http.post(
      Uri.parse("${Constants.baseUrl}/broadcasting/auth"),
      headers: {"Authorization": "Bearer $token", "Accept": "application/json"},
      body: {"socket_id": socketId, "channel_name": channelName},
    );

    print(
      "PUSHER AUTH RESPONSE: status=${response.statusCode} body=${response.body}",
    );

    if (response.statusCode != 200) {
      throw Exception(
        "Pusher auth failed with status ${response.statusCode}: ${response.body}",
      );
    }

    final decoded = jsonDecode(response.body);

    if (decoded is! Map || !decoded.containsKey('auth')) {
      throw Exception(
        "Pusher auth response missing 'auth' key: ${response.body}",
      );
    }

    return decoded;
  }
}
