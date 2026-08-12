import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurants_system/features/auth/domain/repositories/auth_repository.dart';
import 'package:restaurants_system/features/auth/presentation/providers/auth_provider.dart';
import 'package:restaurants_system/features/order_tracking/presentation/providers/order_track/order_track_provider.dart';
import '../../../domain/repositories/order_repository.dart';
import 'order_track_state.dart';

class OrderTrackNotifier extends Notifier<OrderTrackState> {
  late OrderRepository _repository;
  late AuthRepository _authRepository;

  final Set<int> _subscribedOrders = {};

  @override
  OrderTrackState build() {
    _repository = ref.read(orderRepositoryProvider);
    _authRepository = ref.read(authRepositoryProvider);

    return const OrderTrackState();
  }

  Future<void> getOrders({String? status, String? type}) async {
    state = state.copyWith(orderStatus: "loading");

    final token = await _authRepository.getCurrentToken();

    if (token == null) {
      state = state.copyWith(
        message: "Please login first",
        orderStatus: "unauthenticated",
      );
      return;
    }

    final result = await _repository.getOrders(
      token: token,
      status: status,
      type: type,
    );
    if (result.isSuccess) {
      state = state.copyWith(
        orders: result.data!,
        orderStatus: 'success',
        message: result.message,
        statusFilter: status == 'all' ? null : status,
        typeFilter: type == 'all' ? null : type,
      );

      // منزامن الاشتراكات بس لو الاتصال الحقيقي شغال
      if (_repository.isRealtimeConnected) {
        await _syncSubscriptions();
      }
    } else {
      state = state.copyWith(orderStatus: "error", message: result.message);
    }
  }

  Future<void> refreshOrders({String? status, String? type}) async {
    await getOrders(status: status, type: type);
  }

  // ── START REAL-TIME LISTENING ──

  Future<void> startTracking() async {
    try {
      await _repository.initializeRealtime();
      _repository.onOrderStatusChanged(_handleOrderUpdate);
      await _repository.connectRealtime();

      // بعد ما ضمنا الاتصال فعلياً متصل، منزامن الاشتراكات
      // (بتغطي حالة إنو getOrders نفّذت قبل ما الاتصال يخلص)
      if (state.orders.isNotEmpty) {
        await _syncSubscriptions();
      }
    } catch (e) {
      // منسجل الخطأ بالـ state بدل ما نبلعه بصمت
      state = state.copyWith(message: "تعذر الاتصال بالتحديث اللحظي: $e");
    }
  }

  void _handleOrderUpdate(Map<String, dynamic> data) {
    final orderId = data['order_id'];
    final status = data['status'];

    if (orderId == null || status == null) return;

    final readyAt = data["ready_at"] != null
        ? DateTime.tryParse(data["ready_at"])
        : null;
    final confirmedAt = data["confirmed_at"] != null
        ? DateTime.tryParse(data["confirmed_at"])
        : null;

    updateOrderStatus(
      orderId: orderId is int ? orderId : (int.tryParse('$orderId') ?? -1),
      status: status,
      readyAt: readyAt,
      confirmedAt: confirmedAt,
    );
  }

  void updateOrderStatus({
    required int orderId,
    required String status,
    DateTime? readyAt,
    DateTime? confirmedAt,
  }) {
    final updatedOrders = state.orders.map((order) {
      if (order.id == orderId) {
        return order.copyWith(
          status: status,
          readyAt: readyAt,
          confirmedAt: confirmedAt,
        );
      }
      return order;
    }).toList();

    state = state.copyWith(orders: updatedOrders);
  }

  // نفس منطق الـ diff-based subscription sync - ما اتغير المنطق، بس صار
  // يعتمد على حالة اتصال حقيقية من PusherManager مش flag محلي
  Future<void> _syncSubscriptions() async {
    final currentOrders = state.orders
        .where((e) => e.id != null)
        .map((e) => e.id!)
        .toSet();

    for (final id in currentOrders.difference(_subscribedOrders)) {
      await _repository.subscribeToOrder(id);
    }

    for (final id in _subscribedOrders.difference(currentOrders)) {
      await _repository.unsubscribeFromOrder(id);
    }

    _subscribedOrders
      ..clear()
      ..addAll(currentOrders);
  }

  // ── STOP TRACKING ──
  Future<void> stopTracking() async {
    await _repository.disconnectRealtime();
    _subscribedOrders.clear();
  }
}
