// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static const _orange = Color(0xFFFF6B35);
  static const _orangeLight = Color(0xFFFFA07A);

  static ThemeData get light => ThemeData(
        colorScheme: ColorScheme(
          brightness: Brightness.light,
          primary: _orange,
          onPrimary: Colors.white,
          secondary: _orangeLight,
          onSecondary: Colors.black,
          background: const Color(0xFFF8F8F8),
          onBackground: Colors.black,
          surface: Colors.white,
          onSurface: Colors.black87,
          error: Colors.red,
          onError: Colors.white,
          shadow: Colors.black.withOpacity(0.06),
        ),
      );

  static ThemeData get dark => ThemeData(
        colorScheme: ColorScheme(
          brightness: Brightness.dark,
          primary: _orange,
          onPrimary: Colors.white,
          secondary: _orangeLight,
          onSecondary: Colors.black,
          background: const Color(0xFF121212),
          onBackground: Colors.white,
          surface: const Color(0xFF1E1E1E),
          onSurface: Colors.white70,
          error: Colors.red,
          onError: Colors.white,
          shadow: Colors.black.withOpacity(0.4),
        ),
      );
}