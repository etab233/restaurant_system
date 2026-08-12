class CheckoutState {
  final String? deliveryType;
  final String? paymentMethod;
  final String? address;
  final double? latitude;
  final double? longitude;
  final String? tenantId;

  CheckoutState({
    this.deliveryType,
    this.paymentMethod,
    this.address,
    this.latitude,
    this.longitude,
    this.tenantId,
  });

  CheckoutState copyWith({
    String? deliveryType,
    String? paymentMethod,
    String? address,
    double? latitude,
    double? longitude,
    String? tenantId,
  }) {
    return CheckoutState(
      deliveryType: deliveryType ?? this.deliveryType,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      address: address ?? this.address,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      tenantId: tenantId ?? this.tenantId,
    );
  }
}