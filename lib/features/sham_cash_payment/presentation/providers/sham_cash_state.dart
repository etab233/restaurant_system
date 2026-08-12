import 'package:file_picker/file_picker.dart';

class ShamCashState {
  final String status;
  final String message;
  final int? restaurantId;
  final String? subTotal;
  final String? total;
  final String? deliveryFee;
  final bool isPaying;
  final String? type;
  final bool isFetchingFee;
  final String? shamCashAccountBarcode;
  final String? shamCashAccountId;
  final PlatformFile? paymentFile;

  ShamCashState({
    required this.status,
    required this.message,
    this.deliveryFee,
    this.isPaying = false,
    this.subTotal,
    this.total,
    this.restaurantId,
    this.shamCashAccountBarcode,
    this.shamCashAccountId,
    this.type,
    this.isFetchingFee = false,
    this.paymentFile,
  });

  ShamCashState copyWith({
    String? status,
    String? message,
    String? deliveryFee,
    bool? isPaying,
    bool? isFetchingFee,
    PlatformFile? paymentFile,
    String? type,
    String? shamCashAccountBarcode,
    String? shamCashAccountId,
    int? restaurantId,
    String? subTotal,
    String? total,
  }) {
    return ShamCashState(
      status: status ?? this.status,
      message: message ?? this.message,
      restaurantId: restaurantId ?? this.restaurantId,
      deliveryFee: deliveryFee ?? this.deliveryFee,
      total: total ?? this.total,
      subTotal: subTotal ?? this.subTotal,
      isPaying: isPaying ?? this.isPaying,
      shamCashAccountBarcode: shamCashAccountBarcode ?? this.shamCashAccountBarcode,
      shamCashAccountId: shamCashAccountId ?? this.shamCashAccountId,
      isFetchingFee: isFetchingFee ?? this.isFetchingFee,
      paymentFile: paymentFile,
      type: type ?? this.type,
    );
  }
}