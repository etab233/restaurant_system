class AuthSession {
  final String? token;
  final Map<String, dynamic>? userData;
  final List<String>? roles;

  AuthSession({this.token, this.userData, this.roles});
}

class VerifyOtpResult {
  final bool? isRegister;
  final bool? isPasswordSet;
  final String purpose;
  final Map<String, dynamic>? userData;

  VerifyOtpResult({
    this.isRegister,
    this.isPasswordSet,
    required this.purpose,
    this.userData,
  });
}
