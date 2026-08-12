import '../../../data/models/order_detail_model.dart';

class OrderState {
  final String? orderId;
  final String? status;
  final String? message;
  final String? total;
  final String? placeAt;
  final bool isMakingOrder;
  final OrderDetailsResponse? orderDetails;

  OrderState({
    this.orderId,
    this.status,
    this.message,
    this.total,
    this.placeAt,
    this.isMakingOrder = false,
    this.orderDetails,
  });

  OrderState copyWith({
    String? orderId,
    String? status,
    String? message,
    String? total,
    String? placeAt,
    bool? isMakingOrder,
    OrderDetailsResponse? orderDetails,
  }) {
    return OrderState(
      orderId: orderId ?? this.orderId,
      status: status ?? this.status,
      message: message ?? this.message,
      total: total ?? this.total,
      placeAt: placeAt ?? this.placeAt,
      isMakingOrder: isMakingOrder ?? this.isMakingOrder,
      orderDetails: orderDetails ?? this.orderDetails,
    );
  }
}