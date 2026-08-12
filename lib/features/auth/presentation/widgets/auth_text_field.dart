import 'package:flutter/material.dart';
import 'package:restaurants_system/constants.dart';

class AuthTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final IconData prefixIcon;
  final String? Function(String?) validator;
  final bool obscureText;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;

  const AuthTextField({
    super.key,
    required this.controller,
    required this.labelText,
    required this.prefixIcon,
    required this.validator,
    this.obscureText = false,
    this.suffixIcon,
    this.keyboardType,
  });

  /// دالة مشتركة لعمل نفس الـ decoration
  static InputDecoration buildDecoration({
    required String labelText,
    required BuildContext context,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      labelText: labelText,
      filled: true,
      fillColor: Colors.white,
      labelStyle: const TextStyle(color: Colors.black),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: Colors.grey, width: 2),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(
          color: Color(Constants.orangeColor),
          width: 2.5,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.red, width: 3),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFFFF7A3D), width: 3),
      ),
      errorStyle: const TextStyle(
        fontSize: 14,
        color: Colors.red,
        fontStyle: FontStyle.italic,
      ),
      errorMaxLines: 2,
      suffixIcon: suffixIcon,
    );
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      style: const TextStyle(color: Colors.black, fontSize: 16),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: buildDecoration(
        labelText: labelText,
        context: context,
        suffixIcon: suffixIcon,
      ).copyWith(prefixIcon: Icon(prefixIcon, size: 27, color: Colors.grey)),
      validator: validator,
    );
  }
}
