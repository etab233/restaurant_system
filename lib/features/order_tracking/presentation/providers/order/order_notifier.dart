import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurants_system/features/auth/domain/repositories/auth_repository.dart';
import 'package:restaurants_system/features/auth/presentation/providers/auth_provider.dart';
import 'package:restaurants_system/features/cart/presentation/providers/cart_provider.dart';
import 'package:restaurants_system/features/order_tracking/presentation/providers/order_track/order_track_provider.dart';
import '../../../domain/repositories/order_repository.dart';
import 'order_state.dart';

class OrderNotifier extends Notifier<OrderState> {
  late OrderRepository _repository;
  late AuthRepository _authRepository;

  @override
  OrderState build() {
    _repository = ref.read(orderRepositoryProvider);
    _authRepository = ref.read(authRepositoryProvider);

    return OrderState(isMakingOrder: false);
  }

  Future<void> makeOrder({
    required String tenantId,
    required String type,
    required String paymentMethode,
    String? address,
    double? latitude,
    double? longitude,
  }) async {
    state = state.copyWith(status: 'loading', isMakingOrder: true);

    final token = await _authRepository.getCurrentToken();

    if (token == null) {
      state = state.copyWith(
        message: "Please login first",
        isMakingOrder: false,
        status: "unauthenticated",
      );
      return;
    }

    final result = await _repository.makeOrder(
      tenantId: tenantId,
      type: type,
      paymentMethode: paymentMethode,
      address: address,
      token: token,
      latitude: latitude,
      longitude: longitude,
    );

    if (result.isSuccess) {
      // تحديث السلة بعد نجاح إنشاء الطلب
      await ref.read(cartNotifierProvider.notifier).index();

      state = state.copyWith(
        status: result.data,
        message: result.message,
        isMakingOrder: false,
      );
    } else {
      state = state.copyWith(
        status: 'error',
        message: result.message,
        isMakingOrder: false,
      );
    }
  }

  Future<void> cancelOrder({required String referenceNumber}) async {
    state = state.copyWith(status: 'loading', message: '');

    final token = await _authRepository.getCurrentToken();

    if (token == null) {
      state = state.copyWith(
        message: "Please login first",
        isMakingOrder: false,
        status: "unauthenticated",
      );
      return;
    }

    final result = await _repository.cancelOrder(
      token: token,
      referenceNumber: referenceNumber,
    );

    state = result.isSuccess
        ? state.copyWith(status: result.data, message: result.message)
        : state.copyWith(status: 'error', message: result.message);
  }

  Future<void> getOrderDetails({required String referenceNumber}) async {
    state = state.copyWith(status: "loading", message: "");

    final token = await _authRepository.getCurrentToken();

    if (token == null) {
      state = state.copyWith(
        message: "Please login first",
        isMakingOrder: false,
        status: "unauthenticated",
      );
      return;
    }

    final result = await _repository.getOrderDetails(
      referenceNumber: referenceNumber,
      token: token,
    );

    state = result.isSuccess
        ? state.copyWith(
            status: 'success',
            message: result.message,
            orderDetails: result.data,
          )
        : state.copyWith(status: "error", message: result.message);
  }
}
