import 'package:restaurants_system/features/auth/domain/entities/auth_session.dart';

abstract class AuthRepository {
  Future<AuthResult<AuthSession>> login({
    required String email,
    required String password,
  });

  // تابع إنشاء حساب
  Future<AuthResult<AuthSession>> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
    required String phone,
  });

  Future<AuthResult<String>> forgotPassword({required String email});

  // otp تابع للتحقق من صحة
  Future<AuthResult<VerifyOtpResult>> verifyOtp({
    required String email,
    required String otpCode,
    required String purpose,
  });

  Future<AuthResult<String>> resetPassword({
    required String password,
    required String confirmPassword,
    required String email,
  });

  Future<AuthResult<void>> logout({required String token});

  Future<AuthSession?> restoreSession();
  Future<String?> getCurrentToken();
  Future<bool> isLoggedIn();
}

class AuthResult<T> {
  final bool isSuccess;
  final T? data;
  final String message;

  AuthResult.success(this.data, {this.message = ''}) : isSuccess = true;
  AuthResult.failure(this.message) : isSuccess = false, data = null;
}
