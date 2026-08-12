import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:restaurants_system/constants.dart';

class ProfileRemoteDataSource {
  Map<String, String> _headers(String token) => {
    'Accept': 'application/json',
    'Content-Type': 'application/json',
    "Authorization": "Bearer $token",
  };

  Future<http.Response> getProfile({required String token}) async {
    final url = Uri.parse("${Constants.baseUrl}/me");
    return http.get(url, headers: _headers(token));
  }

  Future<http.Response> updateName({
    required String name,
    required String token,
  }) {
    final url = Uri.parse("${Constants.baseUrl}/changeName");
    return http.post(
      url,
      headers: _headers(token),
      body: json.encode({"name": name}),
    );
  }

  Future<http.Response> updatePassword({
    required String token,
    required String newPassword,
  }) async {
    final url = Uri.parse("${Constants.baseUrl}/changePassword");
    return http.post(
      url,
      headers: _headers(token),
      body: json.encode({"password": newPassword}),
    );
  }

  Future<http.Response> updatePhone({
    required String phone,
    required String token,
  }) async {
    return await http.post(
      Uri.parse('${Constants.baseUrl}/phone'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'phone': phone}),
    );
  }
}
