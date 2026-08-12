import 'package:http/http.dart' as http;
import 'package:restaurants_system/constants.dart';
import 'dart:convert';

class OrderRemoteDataSource {
  Future<http.Response> makeOrder({
    required String tenantId,
    required String type,
    required String paymentMethode,
    required String address,
    double? latitude,
    double? longitude,
    required String token,
  }) async {
    final url = Uri.parse("${Constants.baseUrl}/cart/restaurant/confirme");
    return http.post(
      url,
      headers: _headers(token),
      body: json.encode({
        "tenant_id": tenantId,
        "type": type,
        "payment_method": paymentMethode,
        "delivery_address": address,
        "delivery_lat": latitude,
        "delivery_lng": longitude,
      }),
    );
  }

  Future<http.Response> cancelOrder({
    required String token,
    required String referenceNumber,
  }) async {
    final url = Uri.parse(
      "${Constants.baseUrl}/orders/$referenceNumber/cancel",
    );
    return http.post(url, headers: _headers(token));
  }

  Future<http.Response> getOrderDetails({
    required String referenceNumber,
    required String token,
  }) async {
    final url = Uri.parse("${Constants.baseUrl}/order/details/$referenceNumber");
    return http.get(url, headers: _headers(token));
  }

  Future<http.Response> getOrders({
    required String token,
    String? status,
    String? type,
  }) async {
    final url = Uri.parse("${Constants.baseUrl}/orders").replace(
      queryParameters: {
        if (status != null && status != 'all') 'status': status,
        if (type != null && type != 'all') 'type': type,
      },
    );
    return http.get(url, headers: _headers(token));
  }

  Map<String, String> _headers(String token) => {
    'Accept': 'application/json',
    'Content-Type': 'application/json',
    "Authorization": "Bearer $token",
  };
}
