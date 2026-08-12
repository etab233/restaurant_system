import 'package:flutter/material.dart';
import 'package:restaurants_system/features/profile/presentation/utils/settings_item_data.dart';

/// A single tappable settings row: icon, label, optional trailing value, arrow
class SettingsItem extends StatelessWidget {
  const SettingsItem({required this.data, super.key});

  final SettingsItemData data;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: data.onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(data.icon, size: 22, color: Colors.black87),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                data.label,
                style: const TextStyle(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            if (data.trailingText != null) ...[
              Text(
                data.trailingText!,
                style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
              ),
              const SizedBox(width: 6),
            ],
            Icon(Icons.arrow_forward, size: 16, color: Colors.grey.shade500),
          ],
        ),
      ),
    );
  }
}
