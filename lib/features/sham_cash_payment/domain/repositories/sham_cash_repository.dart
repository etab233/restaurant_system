import 'package:file_picker/file_picker.dart';

abstract class ShamCashRepository {
  Future<DeliveryFeeResult> getDeliveryFee({
    required String referenceNumber,
    required String token,
  });

  Future<PaymentResult> pay({
    required String token,
    required String referenceNumber,
    required String tenantId,
    String? paymentCode,
    PlatformFile? invoice,
  });
}

class DeliveryFeeResult {
  final bool isSuccess;
  final String message;
  final String? deliveryFee;
  final int? restaurantId;
  final String? subTotal;
  final String? total;
  final String? type;
  final String? shamCashAccountBarcode;
  final String? shamCashAccountId;

  DeliveryFeeResult.success({
    required this.message,
    this.deliveryFee,
    this.restaurantId,
    this.subTotal,
    this.total,
    this.type,
    this.shamCashAccountBarcode,
    this.shamCashAccountId,
  }) : isSuccess = true;

  DeliveryFeeResult.failure(this.message)
      : isSuccess = false,
        deliveryFee = null,
        restaurantId = null,
        subTotal = null,
        total = null,
        type = null,
        shamCashAccountBarcode = null,
        shamCashAccountId = null;
}

class PaymentResult {
  final bool isSuccess;
  final String status;
  final String message;

  PaymentResult.success({required this.status, required this.message}) : isSuccess = true;
  PaymentResult.failure(this.message) : isSuccess = false, status = 'error';
}