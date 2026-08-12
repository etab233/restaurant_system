import 'package:restaurants_system/core/realtime/pusher_manager.dart';

class OrderRealtimeDataSource {
  final PusherManager _pusher;

  OrderRealtimeDataSource({PusherManager? pusher})
      : _pusher = pusher ?? PusherManager.instance;

  Future<void> initialize() => _pusher.initialize();

  Future<void> connect() => _pusher.connect();

  Future<void> subscribeToOrder(int orderId) => _pusher.subscribeToOrder(orderId);

  Future<void> unsubscribeFromOrder(int orderId) => _pusher.unsubscribeFromOrder(orderId);

  /// تسجيل callback يستدعى عند تغيّر حالة الطلب
  void setOnOrderUpdate(void Function(Map<String, dynamic>) callback) {
    _pusher.onOrderUpdate = callback;
  }

  Future<void> disconnect() => _pusher.disconnect();
}