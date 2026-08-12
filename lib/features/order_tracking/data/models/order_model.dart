class OrderModel {
  final int? id;
  final String? tenantId;
  final String? referenceNumber;
  final String? restaurantName;
  final String? type;
  final String? status;
  final String? statusLabel;
  final double? total;
  final String? paymentMethod;
  final DateTime? placedAt;
  final DateTime? confirmedAt;
  final DateTime? readyAt;
  final bool? paid;

  OrderModel({
    this.id,
    this.tenantId,
    this.referenceNumber,
    this.restaurantName,
    this.type,
    this.status,
    this.statusLabel,
    this.total,
    this.paymentMethod,
    this.placedAt,
    this.confirmedAt,
    this.readyAt,
    this.paid,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'],
      tenantId: json['tenant_id'],
      referenceNumber: json['reference_number'],
      restaurantName: json['restaurant_name'],
      type: json['type'],
      status: json['status'],
      statusLabel: json['status_label'],
      total: double.parse(json['total'].toString()),
      paymentMethod: json["payment_method"],
      placedAt: json['placed_at'] != null ? DateTime.parse(json['placed_at']) : null,
      confirmedAt: json['confirmed_at'] != null ? DateTime.parse(json['confirmed_at']) : null,
      readyAt: json['ready_at'] != null ? DateTime.parse(json['ready_at']) : null,
      paid: json['paied'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'reference_number': referenceNumber,
      'restaurant_name': restaurantName,
      'type': type,
      'status': status,
      'status_label': statusLabel,
      'total': total,
      'placed_at': placedAt?.toIso8601String(),
    };
  }

  OrderModel copyWith({
    int? id,
    String? tenantId,
    String? referenceNumber,
    String? restaurantName,
    String? type,
    String? status,
    String? statusLabel,
    double? total,
    String? paymentMethod,
    DateTime? placedAt,
    DateTime? confirmedAt,
    DateTime? readyAt,
    bool? paid,
  }) {
    return OrderModel(
      id: id ?? this.id,
      tenantId: tenantId ?? this.tenantId,
      referenceNumber: referenceNumber ?? this.referenceNumber,
      restaurantName: restaurantName ?? this.restaurantName,
      type: type ?? this.type,
      status: status ?? this.status,
      statusLabel: statusLabel ?? this.statusLabel,
      total: total ?? this.total,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      placedAt: placedAt ?? this.placedAt,
      confirmedAt: confirmedAt ?? this.confirmedAt,
      readyAt: readyAt ?? this.readyAt,
      paid: paid ?? this.paid,
    );
  }
}