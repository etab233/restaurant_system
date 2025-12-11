import 'package:http/http.dart' as http;
import 'dart:convert';
import '../constants.dart';

class AuthServices{
  // تابع تسجيل الدخول 
  Future<http.Response> login({required String email, required String password}) async{
  final url = Uri.parse("${Constants.baseUrl}/login");
    return await http.post(
      url,
      headers: {
        'Accept':'application/json',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'email': email,
        'password': password,
      }),
    );
  }

  // تابع إنشاء حساب
  Future<http.Response> register({
    required String name,
    required String email,
    required String password,
    required String password_confirmation,
  })async{
    final url = Uri.parse("${Constants.baseUrl}/register");
    return await http.post(
      url,
      headers: {
        'Accept':'application/json',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'name' : name,
        'email': email,
        'password' : password,
        'password_confirmation' : password_confirmation,
      }),
    );
  }

  Future<http.Response> forgotPassword({required String email}) async{
  final url = Uri.parse("${Constants.baseUrl}/request-otp");
  return await http.post(
    url,
    headers:{
        'Accept':'application/json',
        'Content-Type': 'application/json',
    },
    body: json.encode({
      'email' : email,
    })
  );
}
} 