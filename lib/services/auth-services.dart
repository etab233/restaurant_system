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
        'email': email.trim(),
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
      'email' : email.trim(),
    })
  );
}

// otp تابع للتحقق من صحة 
Future<http.Response> verify_otp({required String email, required String otp_code})async{
  final url =Uri.parse("${Constants.baseUrl}/verify-otp");
  return await http.post(
    url,
    headers: {
      'Accept': 'application/json',
      'Content-Type' :'application/json'
    },
    body: json.encode({
      'email':email.trim(),
      'otp_code':otp_code.trim()
    })
  );
}

Future<http.Response> reset_password({required String email, required String new_password, required String confirm})async{
  final url = Uri.parse("${Constants.baseUrl}/reset-password");
  return await http.post(
    url,
    headers: {
      'Accept': 'application/json',
      'Content-Type' :'application/json'
    },
    body: json.encode({
      'email':email.trim(),
      'new_password':new_password,
      'new_password_confirmation':confirm,
    })
  );
}
} 