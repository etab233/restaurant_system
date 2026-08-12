import 'package:flutter/material.dart';

class SettingsItemData {
  final IconData icon;
  final String label;
  final String? trailingText;
  final VoidCallback? onTap;

  const SettingsItemData({
    required this.icon,
    required this.label,
    this.trailingText,
    this.onTap,
  });
}