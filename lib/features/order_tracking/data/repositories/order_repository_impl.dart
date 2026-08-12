import 'dart:convert';
import 'package:restaurants_system/core/realtime/pusher_manager.dart';

import '../datasources/order_remote_data_source.dart';
import '../datasources/order_realtime_data_source.dart';
import '../models/order_model.dart';
import '../models/order_detail_model.dart';
import '../../domain/repositories/order_repository.dart';

class OrderRepositoryImpl implements OrderRepository {
  final OrderRemoteDataSource _remote;
  final OrderRealtimeDataSource _realtime;

  OrderRepositoryImpl(this._remote, this._realtime);

  @override
  Future<OrderResult<String>> makeOrder({
    required String tenantId,
    required String type,
    required String paymentMethode,
    required String address,
    required String token,
    double? latitude,
    double? longitude,
  }) async {
    try {
      final result = await _remote.makeOrder(
        tenantId: tenantId,
        type: type,
        paymentMethode: paymentMethode,
        address: address,
        token: token,
        latitude: latitude,
        longitude: longitude,
      );
      final data = json.decode(result.body);

      if (result.statusCode == 200 || result.statusCode == 201) {
        return OrderResult.success(
          data['status'],
          message: data['message'] ?? '',
        );
      }
      return OrderResult.failure(data['error'] ?? 'Failed to place order');
    } catch (e) {
      return OrderResult.failure("Error $e");
    }
  }

  @override
  Future<OrderResult<String>> cancelOrder({
    required String token,
    required String referenceNumber,
  }) async {
    try {
      final response = await _remote.cancelOrder(
        token: token,
        referenceNumber: referenceNumber,
      );
      final data = json.decode(response.body);

      if (response.statusCode == 200) {
        return OrderResult.success(
          data['status'],
          message: data['message'] ?? '',
        );
      }
      return OrderResult.failure(data['error'] ?? 'Failed to cancel order');
    } catch (e) {
      return OrderResult.failure("Error $e");
    }
  }

  @override
  Future<OrderResult<OrderDetailsResponse>> getOrderDetails({
    required String referenceNumber,
    required String token,
  }) async {
    try {
      final response = await _remote.getOrderDetails(
        referenceNumber: referenceNumber,
        token: token,
      );
      final data = json.decode(response.body);
      final orderDetails = OrderDetailsResponse.fromJson(data);

      if (response.statusCode == 200) {
        return OrderResult.success(
          orderDetails,
          message: data['message'] ?? '',
        );
      }
      return OrderResult.failure(data['message'] ?? "Something went wrong");
    } catch (e) {
      return OrderResult.failure(e.toString());
    }
  }

  @override
  Future<OrderResult<List<OrderModel>>> getOrders({
    required String token,
    String? status,
    String? type,
  }) async {
    try {
      final result = await _remote.getOrders(
        token: token,
        status: status,
        type: type,
      );
      final data = json.decode(result.body);

      if (result.statusCode == 200) {
        final orders = (data['data'] as List)
            .map((element) => OrderModel.fromJson(element))
            .toList();
        return OrderResult.success(orders, message: data['message'] ?? '');
      }
      return OrderResult.failure(data['error'] ?? "error");
    } catch (e) {
      return OrderResult.failure("Error $e");
    }
  }

  // ── Realtime: تمرير مباشر بدون أي منطق إضافي ──

  @override
  Future<void> initializeRealtime() => _realtime.initialize();

  @override
  Future<void> connectRealtime() => _realtime.connect();

  @override
  Future<void> disconnectRealtime() => _realtime.disconnect();

  @override
  Future<void> subscribeToOrder(int orderId) =>
      _realtime.subscribeToOrder(orderId);

  @override
  Future<void> unsubscribeFromOrder(int orderId) =>
      _realtime.unsubscribeFromOrder(orderId);

  @override
  void onOrderStatusChanged(void Function(Map<String, dynamic>) callback) {
    _realtime.setOnOrderUpdate(callback);
  }

  @override
  bool get isRealtimeConnected => PusherManager.instance.isConnected;
}
