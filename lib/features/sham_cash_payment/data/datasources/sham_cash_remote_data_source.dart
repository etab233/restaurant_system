import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:restaurants_system/constants.dart';

class ShamCashRemoteDataSource {
  Future<http.Response> getDeliveryFee({
    required String referenceNumber,
    required String token,
  }) async {
    final url = Uri.parse("${Constants.baseUrl}/orders/order_cost/$referenceNumber");
    return http.get(
      url,
      headers: {"Authorization": "Bearer $token", "Accept": "application/json"},
    );
  }

  Future<http.Response> pay({
    required String token,
    required String referenceNumber,
    required String tenantId,
    String? paymentCode,
    PlatformFile? invoice,
  }) async {
    final url = Uri.parse("${Constants.baseUrl}/orders/checkout");
    final req = http.MultipartRequest('POST', url);

    req.headers.addAll({
      "Authorization": "Bearer $token",
      "Accept": "application/json",
    });
    req.fields['reference_number'] = referenceNumber;
    req.fields['tenant_id'] = tenantId;
    if (paymentCode != null && paymentCode.isNotEmpty) {
      req.fields["payment_code"] = paymentCode;
    }
    if (invoice != null) {
      req.files.add(
        await http.MultipartFile.fromPath('invoice', invoice.path!, filename: invoice.name),
      );
    }

    final streamedResponse = await req.send();
    return http.Response.fromStream(streamedResponse);
  }
}