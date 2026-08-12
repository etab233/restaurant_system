class Validators {
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) return "Email is required !";
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    if (!emailRegex.hasMatch(value)) return "Enter a valid email address";
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) return "password is required !";
    if (value.length < 8) return "8 characters at least !";
    final pattern =
        r'^(?=.*[a-z])(?=.*[0-9])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&]).+$';
    if (!RegExp(pattern).hasMatch(value)) {
      return "Password must contain uppercase, lowercase, number & special character";
    }
    return null;
  }

  static String? validateRequired(String? value, String fieldLabel) {
    if (value == null || value.isEmpty) return "$fieldLabel is required !";
    return null;
  }
}
