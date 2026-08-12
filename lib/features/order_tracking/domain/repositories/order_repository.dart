import '../../data/models/order_model.dart';
import '../../data/models/order_detail_model.dart';

abstract class OrderRepository {
  // ── إجراءات الطلب ──
  Future<OrderResult<String>> makeOrder({
    required String tenantId,
    required String type,
    required String paymentMethode,
    required String address,
    required String token,
    double? latitude,
    double? longitude,
  });

  Future<OrderResult<String>> cancelOrder({
    required String token,
    required String referenceNumber,
  });

  Future<OrderResult<OrderDetailsResponse>> getOrderDetails({
    required String referenceNumber,
    required String token,
  });

  // ── قائمة الطلبات ──
  Future<OrderResult<List<OrderModel>>> getOrders({
    required String token,
    String? status,
    String? type,
  });

  // ── Realtime ──
  Future<void> initializeRealtime();
  Future<void> connectRealtime();
  Future<void> disconnectRealtime();
  Future<void> subscribeToOrder(int orderId);
  Future<void> unsubscribeFromOrder(int orderId);
  void onOrderStatusChanged(void Function(Map<String, dynamic>) callback);
  bool get isRealtimeConnected;
}

class OrderResult<T> {
  final bool isSuccess;
  final T? data;
  final String message;

  OrderResult.success(this.data, {this.message = ''}) : isSuccess = true;
  OrderResult.failure(this.message) : isSuccess = false, data = null;
}