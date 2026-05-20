import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurants_system/providers/auth_provider.dart';
import '../services/api/auth_services.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class AuthState {
  final bool isLoading;
  final bool isLoggedIn;
  final bool isRegistered;
  final bool isCodeSent;
  final bool isVerify;
  final bool isPasswordSet;
  final bool isInitialized;
  final Map<String, dynamic>? userData;
  final String? token;
  final String? purpose;
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
    this.isInitialized = false,
    this.token,
    this.purpose,
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
    bool? isInitialized,
    String? token,
    String? purpose,
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
      isInitialized: isInitialized ?? this.isInitialized,
      token: token ?? this.token,
      purpose: purpose ?? this.purpose,
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
    state = state.copyWith(isLoading: true ,message: null);
    try {
      // لا يقوم بالطلب بنفسه
      final response = await _authService.login(
        email: email,
        password: password,
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString("token", data['data']['access_token']);
        await prefs.setString("userData", jsonEncode(data['data']['user']));

        state = state.copyWith(
          isLoading: false,
          isLoggedIn: true,
          userData: data['data']['user'] ?? data,
          roles: data['data']['roles'] != null
              ? List<String>.from(data['data']['roles'])
              : null,
          message: data['message'] ?? "login Successfully",
        );
      } else {
        final data = json.decode(response.body);
        state = state.copyWith(
          isLoading: false,
          isLoggedIn: false,
          message: data['error'] ?? "failed to login",
        );
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, isLoggedIn: false ,message: "failed to login");
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
          userData: data['data']['user'],
          roles: data['data']['roles'] != null
              ? List<String>.from(data['data']['roles'])
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
        message: "failed to register",
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
        final data = json.decode(response.body);
        String? errorMessage;
        if (data['errors'] != null) {
          final errors = data['errors'] as Map<String, dynamic>;
          final firstError = errors.values.first;
          if (firstError is List && firstError.isNotEmpty) {
            errorMessage = firstError.first;
          } else if (firstError is String) {
            errorMessage = firstError;
          }
        }
        state = state.copyWith(
          isLoading: false,
          isCodeSent: false,
          message: errorMessage ?? "failed to obtain code",
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        isCodeSent: false,
        message: "failed to optain code",
      );
    }
  }

  Future<void> verifyOtp(String email, String otpCode, String purpose) async {
    state = state.copyWith(isLoading: true, message: null);
    try {
      final response = await _authService.verifyOtp(
        email: email,
        otpCode: otpCode,
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        bool? isRegister, isPasswordSet;
        if (purpose == "register") {
          isRegister = true;
          isPasswordSet = false;
          purpose = "register";
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString("token", data['data']['token']);

        } else if (purpose == "reset_password") {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString("token", data['data']['token']);
          isPasswordSet = true;
          isRegister = false;
          purpose= "reset_password";
        }
        state = state.copyWith(
          isLoading: false,
          isVerify: true,
          isRegistered: isRegister,
          isPasswordSet: isPasswordSet,
          purpose: purpose,
          message: data['message'],
          userData: data['data']['user'],
        );
      } else {
        final data = json.decode(response.body);
        state = state.copyWith(
          isLoading: false,
          isVerify: false,
          isRegistered: false,
          isCodeSent: false,
          message: data['message'] ?? "failed to optain code",
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

  Future<String> setPassword(
    String password,
    String confirmPassword,
    String email,
  ) async {
    state = state.copyWith(isLoading: true, message: null);
    try {
      final response = await _authService.resetPassword(
        password: password,
        confirmPassword: confirmPassword,
        email: email,
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body);
        state = state.copyWith(isLoading: false, isPasswordSet: true);
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
          state = state.copyWith(isLoading: false, isPasswordSet: false);
        }
        return "Failed to reset password";
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, isPasswordSet: false);
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

  // load data from SharedPreferences when first open the app
  Future<void> restoreSession() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final userData = prefs.getString('userData');

    if (token != null) {
      state = state.copyWith(
        isInitialized: true,
        isLoggedIn: true,
        userData: userData != null ? jsonDecode(userData) : null,
      );
    } else {
      state = state.copyWith(isInitialized: true, isLoggedIn: false);
    }
  }
}
