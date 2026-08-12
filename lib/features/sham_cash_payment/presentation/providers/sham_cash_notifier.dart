import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurants_system/features/sham_cash_payment/presentation/providers/sham_cash_provider.dart';
import '../../domain/repositories/sham_cash_repository.dart';
import 'sham_cash_state.dart';


class ShamCashNotifier extends Notifier<ShamCashState> {
  late ShamCashRepository _repository;

  @override
  ShamCashState build() {
    _repository = ref.read(shamCashRepositoryProvider);
    return ShamCashState(status: '', message: '');
  }

  Future<void> getDeliveryFee({
    required String referenceNumber,
    required String token,
  }) async {
    state = state.copyWith(status: 'loading', message: '', isFetchingFee: true);
    final result = await _repository.getDeliveryFee(
      referenceNumber: referenceNumber,
      token: token,
    );

    state = result.isSuccess
        ? state.copyWith(
            status: 'success',
            message: result.message,
            deliveryFee: result.deliveryFee,
            restaurantId: result.restaurantId,
            subTotal: result.subTotal,
            total: result.total,
            type: result.type,
            shamCashAccountBarcode: result.shamCashAccountBarcode,
            shamCashAccountId: result.shamCashAccountId,
            isFetchingFee: false,
          )
        : state.copyWith(status: 'error', isFetchingFee: false);
  }

  void setPaymentFile(PlatformFile file) {
    state = state.copyWith(paymentFile: file);
  }

  void removePaymentFile() {
    state = state.copyWith(paymentFile: null);
  }

  Future<void> pay({
    required String token,
    required String referenceNumber,
    required String tenantId,
    String? paymentCode,
    PlatformFile? invoice,
  }) async {
    final hasPaymentCode = paymentCode != null && paymentCode.trim().isNotEmpty;
    if (!hasPaymentCode && invoice == null) {
      state = state.copyWith(
        status: 'error',
        message: 'enter either invoice or reference number',
      );
      return;
    }

    state = state.copyWith(status: 'loading', isPaying: true);
    final result = await _repository.pay(
      token: token,
      referenceNumber: referenceNumber,
      tenantId: tenantId,
      paymentCode: paymentCode,
      invoice: invoice,
    );

    if (!ref.mounted) return;

    state = result.isSuccess
        ? state.copyWith(status: result.status, message: result.message, isPaying: false)
        : state.copyWith(status: 'error', message: result.message, isPaying: false);
  }
}