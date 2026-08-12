import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:restaurants_system/constants.dart';

class AuthRemoteDatasource {
  Map<String, String> _headers() => {
    'Accept': 'application/json',
    'Content-Type': 'application/json',
  };

  // تابع تسجيل الدخول
  Future<http.Response> login({
    required String email,
    required String password,
  }) async {
    final url = Uri.parse("${Constants.baseUrl}/login");
    return await http.post(
      url,
      headers: _headers(),
      body: json.encode({'email': email, 'password': password}),
    );
  }

  // تابع إنشاء حساب
  Future<http.Response> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
    required String phone,
  }) async {
    final url = Uri.parse("${Constants.baseUrl}/register");
    return await http.post(
      url,
      headers: _headers(),
      body: json.encode({
        'name': name,
        'email': email.trim(),
        'password': password,
        'password_confirmation': passwordConfirmation,
        'phone': phone,
      }),
    );
  }

  Future<http.Response> forgotPassword({required String email}) async {
    final url = Uri.parse("${Constants.baseUrl}/request-otp");
    return await http.post(
      url,
      headers: _headers(),
      body: json.encode({'email': email.trim()}),
    );
  }

  // otp تابع للتحقق من صحة
  Future<http.Response> verifyOtp({
    required String email,
    required String otpCode,
  }) async {
    final url = Uri.parse("${Constants.baseUrl}/verify-otp-email");
    return await http.post(
      url,
      headers: _headers(),
      body: json.encode({'email': email.trim(), 'otp_code': otpCode.trim()}),
    );
  }

  Future<http.Response> resetPassword({
    required String password,
    required String confirmPassword,
    required String email,
  }) async {
    final url = Uri.parse("${Constants.baseUrl}/set-password");
    return await http.post(
      url,
      headers: _headers(),
      body: json.encode({
        'new_password': password.trim(),
        'new_password_confirmation': confirmPassword.trim(),
        'email': email.trim(),
      }),
    );
  }

  Future<http.Response> logout({required String token}) async {
    final url = Uri.parse("${Constants.baseUrl}/logout");
    return await http.post(
      url,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
  }
}
