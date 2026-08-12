import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'checkout_state.dart';

class CheckoutNotifier extends Notifier<CheckoutState> {
  @override
  CheckoutState build() {
    return CheckoutState();
  }

  void setDeliveryType(String type) {
    state = state.copyWith(deliveryType: type);
  }

  void setPaymentMethod(String method) {
    state = state.copyWith(paymentMethod: method);
  }

  void setAddress({
    required String address,
    required double latitude,
    required double longitude,
  }) {
    state = state.copyWith(address: address, latitude: latitude, longitude: longitude);
  }

  void setTenantId(String tenantId) {
    state = state.copyWith(tenantId: tenantId);
  }

  void reset() {
    state = CheckoutState();
  }
}