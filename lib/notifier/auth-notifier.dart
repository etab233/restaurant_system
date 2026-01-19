import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/auth-services.dart';
import 'dart:convert';

class AuthState{
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

  const AuthState({
    this.isLoading = false,
    this.isLoggedIn= false,
    this.isRegistered=false,
    this.isCodeSent=false,
    this.isVerify=false,
    this.isPasswordSet=false,
    this.token,
    this.roles,
    this.userData,
    this.message,
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
    Map<String,dynamic>? userData,
    String? message,
  }){
  return AuthState(
      isLoading: isLoading ?? this.isLoading,
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      isRegistered: isRegistered ?? this.isRegistered,
      isCodeSent: isCodeSent?? this.isCodeSent,
      isVerify: isVerify ?? this.isVerify,
      isPasswordSet: isPasswordSet?? this.isPasswordSet,
      token: token ?? this.token,
      roles: roles ?? this.roles,
      userData: userData ?? this.userData,
      message : message ?? this.message,
    );
  }
}

class AuthNotifier extends Notifier<AuthState>{
  late AuthServices _authService;

   @override
  AuthState build() {
    _authService = AuthServices();
    return const AuthState(); // الحالة الابتدائية
  }

  Future<void> login(String email, String password)async{
    state = state.copyWith(isLoading: true, message: null);
    try{
      // لا يقوم بالطلب بنفسه
      final response = await _authService.login(
        email: email,
        password: password
      );
      if(response.statusCode ==200){
        final data = json.decode(response.body);
        state = state.copyWith(
          isLoading : false,
          isLoggedIn: true,
          userData  : data['user'] ?? data,
          token: data['access_token'],
          roles: data['roles'] != null 
              ? List<String>.from(data['roles']) 
              : null,
           message: data['message'] ?? "login Successfully",
        );
      }
      else{
        final data = json.decode(response.body);
        state = state.copyWith(
          isLoading : false,
          message : data['error'] ?? "failed to login",
        );
      }
    } catch(e){
      state = state.copyWith(
        isLoading : false,
        message: "try again please..",
      );
    }
  }

  Future<void> register(
    String name,
    String email,
    String password,
    String password_confirmation
  )async{
    // التحقق من تطابق كلمات المرور
    if (password != password_confirmation) {
      state = state.copyWith(
        isLoading: false,
        message: "Passwords do not match",
        isRegistered: false,
      );
      return;
    }
    state = state.copyWith(isLoading: true, message: null);
    try{
      final response = await _authService.register(
        name: name,
        email: email, 
        password: password, 
        password_confirmation: password_confirmation
      );
      String? errorMessage;
      if(response.statusCode == 200 || response.statusCode == 201){
        final data = json.decode(response.body);
        state = state.copyWith(
          isLoading : false,
          isRegistered: true,
          userData  : data['user'] ?? data,
          token: data['access_token'],
          roles: data['roles'] != null 
              ? List<String>.from(data['roles']) 
              : null,
          message: data['message'] ?? "Registeration Successfully",
        );
      }
      else{
        final data = json.decode(response.body);
        if(data['errors'] != null){
          final Map<String,dynamic> errors = data['errors'];
          final firstError = errors.values.first;
          if(firstError is List && firstError.isNotEmpty){
            errorMessage = firstError.first;
          }
          else if (firstError is String) {
            errorMessage = firstError;
          }
        }
        state = state.copyWith(
          isLoading : false,
          isRegistered: false,
          message : errorMessage ?? "failed to register",
        );
      }
    }catch(e){
      state = state.copyWith(
        isLoading : false,
        isRegistered: false,
        message: "try again please..",
      );
    }
  }
  
  Future<void> forgot_password(String email)async{
    state = state.copyWith(isLoading: true, message: null);
    try{
      final response = await _authService.forgotPassword(email:email);
      if(response.statusCode == 200){
        final data = json.decode(response.body);
        state = state.copyWith(
          message: data['message'] ?? 'code sent successfully',
          isCodeSent: true,
          userData: {'email': email},
          isLoading: false,
        );
      }
      else{
        String? error_message;
        final data = json.decode(response.body);
        if(data['errors'] != null){
          final Map<String,dynamic> errors = data['errors'];
          final firstError = errors.values.first;
          if(firstError is List && firstError.isNotEmpty){
            error_message = firstError.first;
          }
          else if (firstError is String) {
            error_message = firstError;
          }
          state = state.copyWith(
          isLoading : false,
          isCodeSent: false,
          message : error_message ?? "failed to optain code",
          );
        }
      }
    }catch(e){
      state = state.copyWith(
        isLoading : false,
        isCodeSent: false,
        message: "try again please..",
      );
    }
  }

  Future<void> verify_otp(String email, String otp_code)async{
    state= state.copyWith(isLoading: true, message: null);
    try{
      final response = await _authService.verify_otp(email: email, otp_code: otp_code);
      if(response.statusCode == 200){
        final data = json.decode(response.body);
        state = state.copyWith(
          isLoading: false,
          isVerify: true,
          message: data['message']
        );
      }else{
        final data = json.decode(response.body);
        state = state.copyWith(
          isLoading : false,
          isVerify: false,
          message : data['error'] ?? "failed to optain code",
          );
      }
    }catch(e){
      state = state.copyWith(
        isLoading: false,
        isVerify: false,
        message: 'failed to verify your code! try again please.'
      );
    }
  }

  Future<void> reset_password(String email, String new_password, String confirm)async{
    state = state.copyWith(isLoading: true, message: null);
    try{
      final response =await _authService.reset_password(email: email, new_password: new_password, confirm: confirm);
      if(response.statusCode == 200){
        final data = json.decode(response.body);
        state = state.copyWith(
          isLoading: false,
          isPasswordSet: true,
          message: data['message']
        );
      }else{
        String? error_message;
        final data = json.decode(response.body);
        if(data['errors'] != null){
          final Map<String,dynamic> errors = data['errors'];
          final firstError = errors.values.first;
          if(firstError is List && firstError.isNotEmpty){
            error_message = firstError.first;
          }
          else if (firstError is String) {
            error_message = firstError;
          }
          state = state.copyWith(
          isLoading : false,
          isVerify: false,
          message : error_message ?? "failed to reset password",
          );
        }
      }
    }catch(e){
      state = state.copyWith(
        isLoading: false,
        isPasswordSet: false,
        message: "Failed to reset your password, please try again !"
      );
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
}