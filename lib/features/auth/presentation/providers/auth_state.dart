import 'package:restaurants_system/core/enums/user_type.dart';

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