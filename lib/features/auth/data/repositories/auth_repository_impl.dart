import 'dart:convert';

import 'package:restaurants_system/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:restaurants_system/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:restaurants_system/features/auth/domain/entities/auth_session.dart';
import 'package:restaurants_system/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDatasource _remote;
  final AuthLocalDataSource _local;

  AuthRepositoryImpl(this._remote, this._local);

  @override
  Future<AuthResult<AuthSession>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _remote.login(email: email, password: password);
      final data = json.decode(response.body);

      if (response.statusCode == 200) {
        final token = data['data']['access_token'] as String;
        final userData = (data['data']['user'] ?? data) as Map<String, dynamic>;
        final roles = data['data']['roles'] != null
            ? List<String>.from(data['data']['roles'])
            : null;

        await _local.saveSession(token: token, userData: userData);

        return AuthResult.success(
          AuthSession(token: token, userData: userData, roles: roles),
          message: data['message'] ?? "login Successfully",
        );
      }
      return AuthResult.failure(data['error'] ?? "failed to login");
    } catch (e) {
      return AuthResult.failure("failed to login");
    }
  }

  @override
  Future<AuthResult<AuthSession>> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
    required String phone,
  }) async {
    try {
      final response = await _remote.register(
        name: name,
        email: email,
        password: password,
        passwordConfirmation: passwordConfirmation,
        phone: phone,
      );
      final data = json.decode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final userData = data['data']['user'] as Map<String, dynamic>;
        final roles = data['data']['roles'] != null
            ? List<String>.from(data['data']['roles'])
            : null;
        return AuthResult.success(
          AuthSession(userData: userData, roles: roles),
          message: data['message'] ?? "Registration Successfully",
        );
      }
      return AuthResult.failure(_extractError(data) ?? "failed to register");
    } catch (e) {
      return AuthResult.failure("failed to register");
    }
  }

  @override
  Future<AuthResult<String>> forgotPassword({required String email}) async {
    try {
      final response = await _remote.forgotPassword(email: email);
      final data = json.decode(response.body);

      if (response.statusCode == 200) {
        return AuthResult.success(
          email,
          message: data['message'] ?? 'code sent successfully',
        );
      }
      return AuthResult.failure(_extractError(data) ?? "failed to obtain code");
    } catch (e) {
      return AuthResult.failure("failed to obtain code");
    }
  }

  @override
  Future<AuthResult<VerifyOtpResult>> verifyOtp({
    required String email,
    required String otpCode,
    required String purpose,
  }) async {
    try {
      final response = await _remote.verifyOtp(email: email, otpCode: otpCode);

      final data = json.decode(response.body);

      if (response.statusCode == 200) {
        bool? isRegister;
        bool? isPasswordSet;

        final token = data['data']['token'];
        final userData = data['data']['user'] as Map<String, dynamic>;

        if (purpose == "register") {
          isRegister = true;
          isPasswordSet = false;

          await _local.saveSession(token: token, userData: userData);
        } else if (purpose == "reset_password") {
          isPasswordSet = true;
          isRegister = false;

          await _local.saveToken(token);
        }

        return AuthResult.success(
          VerifyOtpResult(
            isRegister: isRegister,
            isPasswordSet: isPasswordSet,
            purpose: purpose,
            userData: userData,
          ),
          message: data['message'] ?? '',
        );
      }

      return AuthResult.failure(data['message'] ?? "failed to obtain code");
    } catch (e) {
      return AuthResult.failure(
        'failed to verify your code! try again please.',
      );
    }
  }

  @override
  Future<AuthResult<String>> resetPassword({
    required String password,
    required String confirmPassword,
    required String email,
  }) async {
    try {
      final response = await _remote.resetPassword(
        password: password,
        confirmPassword: confirmPassword,
        email: email,
      );
      final data = json.decode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return AuthResult.success(data['message'] as String);
      }
      return AuthResult.failure(
        _extractError(data) ?? "Failed to reset password",
      );
    } catch (e) {
      return AuthResult.failure(
        "Failed to reset your password, please try again !",
      );
    }
  }

  @override
  Future<AuthResult<void>> logout({required String token}) async {
    try {
      final response = await _remote.logout(token: token);

      if (response.statusCode == 200) {
        await _local.clearSession();
        return AuthResult.success(null);
      }
      final data = json.decode(response.body);
      return AuthResult.failure(data["message"] ?? "Failed to logout");
    } catch (e) {
      return AuthResult.failure("Failed to logout");
    }
  }

  @override
  Future<AuthSession?> restoreSession() async {
    final token = await _local.getToken();
    if (token == null) return null;
    return AuthSession(token: token, userData: _local.getUserData());
  }

  @override
  Future<String?> getCurrentToken() => _local.getToken();

  @override
  Future<bool> isLoggedIn() async {
    final token = await _local.getToken();
    return token != null && token.isNotEmpty;
  }

  /// منطق استخراج رسالة الخطأ من errors map
  String? _extractError(Map<String, dynamic> data) {
    if (data['errors'] == null) return null;
    final errors = data['errors'] as Map<String, dynamic>;
    final firstError = errors.values.first;
    if (firstError is List && firstError.isNotEmpty) return firstError.first;
    if (firstError is String) return firstError;
    return null;
  }
}
