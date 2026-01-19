import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../notifier/auth-notifier.dart';

final authProvider = NotifierProvider<AuthNotifier, AuthState>((){
  return AuthNotifier();
});

final isLoadingProvider = Provider<bool>((ref) {
  return ref.watch(authProvider).isLoading;
});

final isLoggedInProvider = Provider<bool>((ref) {
  return ref.watch(authProvider).isLoggedIn;
});

final isRegisterdInProvider = Provider<bool>((ref) {
  return ref.watch(authProvider).isRegistered;
});

final isCodeSentProvider = Provider<bool>((ref) {
  return ref.watch(authProvider).isCodeSent;
});

final isVerifyProvider = Provider<bool>((ref) {
  return ref.watch(authProvider).isVerify;
});

final isPasswordSetProvider = Provider<bool>((ref) {
  return ref.watch(authProvider).isPasswordSet;
});

final userDataProvider = Provider<Map<String, dynamic>?>((ref) {
  return ref.watch(authProvider).userData;
});

final messageProvider = Provider<String?>((ref) {
  return ref.watch(authProvider).message;
});

final tokenProvider = Provider<String?>((ref) {
  return ref.watch(authProvider).token;
});

final rolesProvider = Provider<List<String>?>((ref) {
  return ref.watch(authProvider).roles;
});