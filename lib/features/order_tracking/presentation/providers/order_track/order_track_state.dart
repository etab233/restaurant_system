import '../../../data/models/order_model.dart';

class OrderTrackState {
  final List<OrderModel> orders;
  final String orderStatus; // loading / success / error
  final String message;
  final String? statusFilter;
  final String? typeFilter;

  const OrderTrackState({
    this.orders = const [],
    this.orderStatus = '',
    this.message = '',
    this.statusFilter,
    this.typeFilter,
  });

  OrderTrackState copyWith({
    List<OrderModel>? orders,
    String? orderStatus,
    String? message,
    String? statusFilter,
    String? typeFilter,
  }) {
    return OrderTrackState(
      orders: orders ?? this.orders,
      orderStatus: orderStatus ?? this.orderStatus,
      message: message ?? this.message,
      statusFilter: statusFilter ?? this.statusFilter,
      typeFilter: typeFilter ?? this.typeFilter,
    );
  }
}