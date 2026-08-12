import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import '../datasources/sham_cash_remote_data_source.dart';
import '../../domain/repositories/sham_cash_repository.dart';

class ShamCashRepositoryImpl implements ShamCashRepository {
  final ShamCashRemoteDataSource _remote;

  ShamCashRepositoryImpl(this._remote);

  @override
  Future<DeliveryFeeResult> getDeliveryFee({
    required String referenceNumber,
    required String token,
  }) async {
    try {
      final response = await _remote.getDeliveryFee(
        referenceNumber: referenceNumber,
        token: token,
      );
      final data = json.decode(response.body);

      if (response.statusCode == 200) {
        final orderInfo = data['data']["order_info"];
        return DeliveryFeeResult.success(
          message: data['message'] ?? '',
          deliveryFee: orderInfo['delivery_fee'],
          restaurantId: orderInfo['restaurant_id'],
          subTotal: orderInfo['subtotal'],
          total: orderInfo['total'],
          type: orderInfo['type'],
          shamCashAccountBarcode: orderInfo['sham_cash_account_barcode'],
          shamCashAccountId: orderInfo['sham_cach_account_id'],
        );
      }
      return DeliveryFeeResult.failure(data['message'] ?? 'error');
    } catch (e) {
      return DeliveryFeeResult.failure('An error was occured $e');
    }
  }

  @override
  Future<PaymentResult> pay({
    required String token,
    required String referenceNumber,
    required String tenantId,
    String? paymentCode,
    PlatformFile? invoice,
  }) async {
    try {
      final response = await _remote.pay(
        token: token,
        referenceNumber: referenceNumber,
        tenantId: tenantId,
        paymentCode: paymentCode,
        invoice: invoice,
      );
      final data = json.decode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return PaymentResult.success(status: data['status'], message: data['message']);
      }
      return PaymentResult.failure(data['error'] ?? 'Payment failed');
    } catch (e) {
      return PaymentResult.failure('An error was occured $e');
    }
  }
}