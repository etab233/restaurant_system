import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurants_system/features/auth/domain/repositories/auth_repository.dart';
import 'package:restaurants_system/features/auth/presentation/providers/auth_provider.dart';
import 'package:restaurants_system/features/auth/presentation/providers/auth_state.dart';

class AuthNotifier extends Notifier<AuthState> {
  late AuthRepository _repository;

  @override
  AuthState build() {
    _repository = ref.read(authRepositoryProvider);
    return const AuthState();
  }

  Future<void> login(String email, String password) async {
    state = state.copyWith(isLoading: true, message: null);
    final result = await _repository.login(email: email, password: password);

    state = result.isSuccess
        ? state.copyWith(
            isLoading: false,
            isLoggedIn: true,
            userData: result.data!.userData,
            roles: result.data!.roles,
            message: result.message,
          )
        : state.copyWith(
            isLoading: false,
            isLoggedIn: false,
            message: result.message,
          );
  }

  Future<void> register(
    String name,
    String email,
    String password,
    String passwordConfirmation,
    String phone,
  ) async {
    if (password != passwordConfirmation) {
      state = state.copyWith(
        isLoading: false,
        message: "Passwords don't match",
        isRegistered: false,
      );
      return;
    }

    state = state.copyWith(isLoading: true, message: null);
    final result = await _repository.register(
      name: name,
      email: email,
      password: password,
      passwordConfirmation: passwordConfirmation,
      phone: phone,
    );

    state = result.isSuccess
        ? state.copyWith(
            isLoading: false,
            isRegistered: true,
            userData: result.data!.userData,
            roles: result.data!.roles,
            message: result.message,
          )
        : state.copyWith(
            isLoading: false,
            isRegistered: false,
            message: result.message,
          );
  }

  Future<void> forgotPassword(String email) async {
    state = state.copyWith(isLoading: true, message: null);
    final result = await _repository.forgotPassword(email: email);

    state = result.isSuccess
        ? state.copyWith(
            isLoading: false,
            isCodeSent: true,
            userData: {'email': email},
            message: result.message,
          )
        : state.copyWith(
            isLoading: false,
            isCodeSent: false,
            message: result.message,
          );
  }

  Future<void> verifyOtp(String email, String otpCode, String purpose) async {
    state = state.copyWith(isLoading: true, message: null);
    final result = await _repository.verifyOtp(
      email: email,
      otpCode: otpCode,
      purpose: purpose,
    );

    state = result.isSuccess
        ? state.copyWith(
            isLoading: false,
            isVerify: true,
            isRegistered: result.data!.isRegister,
            isPasswordSet: result.data!.isPasswordSet,
            purpose: result.data!.purpose,
            userData: result.data!.userData,
            message: result.message,
          )
        : state.copyWith(
            isLoading: false,
            isVerify: false,
            isRegistered: false,
            isCodeSent: false,
            message: result.message,
          );
  }

  Future<String> resetPassword(String password, String confirmPassword, String email) async {
    state = state.copyWith(isLoading: true, message: null);
    final result = await _repository.resetPassword(
      password: password,
      confirmPassword: confirmPassword,
      email: email,
    );

    state = state.copyWith(isLoading: false, isPasswordSet: result.isSuccess);
    return result.isSuccess ? result.data! : result.message;
  }

  Future<void> logout({required String token}) async {
    state = state.copyWith(isLoading: true);
    final result = await _repository.logout(token: token);

    state = result.isSuccess
        ? const AuthState(isInitialized: true)
        : state.copyWith(isLoading: false, message: result.message);
  }

  void updateUserData(Map<String, dynamic> newData) {
    state = state.copyWith(userData: newData);
  }

  // load data when first open the app
  Future<void> restoreSession() async {
    final session = await _repository.restoreSession();

    state = session != null
        ? state.copyWith(isInitialized: true, isLoggedIn: true, token: session.token, userData: session.userData)
        : state.copyWith(isInitialized: true, isLoggedIn: false);
  }
}
