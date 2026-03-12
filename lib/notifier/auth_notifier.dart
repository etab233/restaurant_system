import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurants_system/providers/auth_provider.dart';
import '../services/auth-services.dart';
import 'dart:convert';

class AuthState {
  final bool isLoading;
  final bool isLoggedIn;
  final bool isRegistered;
  final bool isCodeSent;
  final bool isVerify;
  final bool isPasswordSet;
  final Map<String, dynamic>? userData;
  final String? token;
  final List<String>? roles;
  final String? message;
  final UserType toggleState;

  const AuthState({
    this.isLoading = false,
    this.isLoggedIn = false,
    this.isRegistered = false,
    this.isCodeSent = false,
    this.isVerify = false,
    this.isPasswordSet = false,
    this.token,
    this.roles,
    this.userData,
    this.message,
    this.toggleState = UserType.customer,
  });

  AuthState copyWith({
    bool? isLoading,
    bool? isLoggedIn,
    bool? isRegistered,
    bool? isCodeSent,
    bool? isVerify,
    bool? isPasswordSet,
    String? token,
    List<String>? roles,
    Map<String, dynamic>? userData,
    String? message,
    UserType? toggleState,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      isRegistered: isRegistered ?? this.isRegistered,
      isCodeSent: isCodeSent ?? this.isCodeSent,
      isVerify: isVerify ?? this.isVerify,
      isPasswordSet: isPasswordSet ?? this.isPasswordSet,
      token: token ?? this.token,
      roles: roles ?? this.roles,
      userData: userData ?? this.userData,
      message: message ?? this.message,
      toggleState: toggleState ?? this.toggleState,
    );
  }
}

class AuthNotifier extends Notifier<AuthState> {
  late AuthServices _authService;

  @override
  AuthState build() {
    _authService = AuthServices();
    return const AuthState(); // الحالة الابتدائية
  }

  Future<void> login(String email, String password) async {
    state = state.copyWith(isLoading: true, message: null);
    try {
      // لا يقوم بالطلب بنفسه
      final response = await _authService.login(
        email: email,
        password: password,
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        state = state.copyWith(
          isLoading: false,
          isLoggedIn: true,
          userData: data['user'] ?? data,
          token: data['access_token'],
          roles: data['roles'] != null
              ? List<String>.from(data['roles'])
              : null,
          message: data['message'] ?? "login Successfully",
        );
      } else {
        final data = json.decode(response.body);
        state = state.copyWith(
          isLoading: false,
          message: data['error'] ?? "failed to login",
        );
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, message: "try again please..");
    }
  }

  Future<void> register(
    String name,
    String email,
    String password,
    String passwordConfirmation,
  ) async {
    // التحقق من تطابق كلمات المرور
    if (password != passwordConfirmation) {
      state = state.copyWith(
        isLoading: false,
        message: "Passwords don't match",
        isRegistered: false,
      );
      return;
    }
    state = state.copyWith(isLoading: true, message: null);
    try {
      final response = await _authService.register(
        name: name,
        email: email,
        password: password,
        passwordConfirmation: passwordConfirmation,
      );
      String? errorMessage;
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body);
        state = state.copyWith(
          isLoading: false,
          isRegistered: true,
          userData: data['user'],
          token: data['access_token'],
          roles: data['roles'] != null
              ? List<String>.from(data['roles'])
              : null,
          message: data['message'] ?? "Registration Successfully",
        );
      } else {
        final data = json.decode(response.body);
        if (data['errors'] != null) {
          final Map<String, dynamic> errors = data['errors'];
          final firstError = errors.values.first;
          if (firstError is List && firstError.isNotEmpty) {
            errorMessage = firstError.first;
          } else if (firstError is String) {
            errorMessage = firstError;
          }
        }
        state = state.copyWith(
          isLoading: false,
          isRegistered: false,
          message: errorMessage ?? "failed to register",
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        isRegistered: false,
        message: "Error: $e",
      );
    }
  }

  Future<void> forgotPassword(String email) async {
    state = state.copyWith(isLoading: true, message: null);
    try {
      final response = await _authService.forgotPassword(email: email);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        state = state.copyWith(
          message: data['message'] ?? 'code sent successfully',
          isCodeSent: true,
          userData: {'email': email},
          isLoading: false,
        );
      } else {
        String? errorMessage;
        final data = json.decode(response.body);
        if (data['errors'] != null) {
          final Map<String, dynamic> errors = data['errors'];
          final firstError = errors.values.first;
          if (firstError is List && firstError.isNotEmpty) {
            errorMessage = firstError.first;
          } else if (firstError is String) {
            errorMessage = firstError;
          }
          state = state.copyWith(
            isLoading: false,
            isCodeSent: false,
            message: errorMessage ?? "failed to optain code",
          );
        }
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        isCodeSent: false,
        message: "Error: $e",
      );
    }
  }

  Future<void> verifyOtp(String email, String otpCode, String purpose) async {
    state = state.copyWith(isLoading: true, message: null);
    try {
      final response = await _authService.verifyOtp(
        email: email,
        otpCode: otpCode,
        purpose: purpose,
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        bool? isRegister, isPasswordSet;
        if (purpose == "register") {
          isRegister = true;
          isPasswordSet = false;
        } else if (purpose == "reset_password") {
          isPasswordSet = true;
          isRegister = false;
        }
        state = state.copyWith(
          isLoading: false,
          isVerify: true,
          isRegistered: isRegister,
          isPasswordSet: isPasswordSet,
          message: data['message'],
          userData: data['data']['user']
        );
      } else {
        final data = json.decode(response.body);
        state = state.copyWith(
          isLoading: false,
          isVerify: false,
          isRegistered: false,
          isCodeSent: false,
          message: data['error'] ?? "failed to optain code",
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        isVerify: false,
        isRegistered: false,
          isCodeSent: false,
        message: 'failed to verify your code! try again please.',
      );
    }
  }

  Future<String> setPassword(String password, String confirmPassword, String email) async {
    state = state.copyWith(isLoading: true, message: null);
    try {
      final response = await _authService.resetPassword(
        password: password,
        confirmPassword: confirmPassword,
        email: email
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body);
        state = state.copyWith(
          isLoading: false,
          isPasswordSet: true,
        );
        return data['message'];
      } else {
        final data = json.decode(response.body);
        if (data['errors'] != null) {
          final Map<String, dynamic> errors = data['errors'];
          final firstError = errors.values.first;
          if (firstError is List && firstError.isNotEmpty) {
            return firstError.first;
          } else if (firstError is String) {
            return firstError;
          }
          state = state.copyWith(
            isLoading: false,
            isPasswordSet: false,
          );
        }
        return  "Failed to reset password";
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        isPasswordSet: false,
      );
      return "Failed to reset your password, please try again !";
    }
  }

  // دالة تسجيل الخروج
  void logout() {
    state = const AuthState(); // إعادة الحالة للابتدائية
  }

  // دالة لتحديث بيانات المستخدم
  void updateUserData(Map<String, dynamic> newData) {
    state = state.copyWith(userData: newData);
  }

  // change user type in register screen
  void changeUserType(UserType type) {
    state = state.copyWith(toggleState: type);
  }
}
