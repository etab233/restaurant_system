// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:restaurants_system/features/profile/presentation/utils/settings_item_data.dart';
import 'package:restaurants_system/features/profile/presentation/widgets/settings_item.dart';

/// A rounded card grouping a list of settings rows with dividers
class SettingsGroup extends StatelessWidget {
  const SettingsGroup({required this.items, super.key});

  final List<SettingsItemData> items;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: List.generate(items.length, (index) {
          final item = items[index];
          final isLast = index == items.length - 1;
          return Column(
            children: [
              SettingsItem(data: item),
              if (!isLast)
                Divider(
                  height: 1,
                  indent: 52,
                  color: Colors.grey.shade200,
                ),
            ],
          );
        }),
      ),
    );
  }
}