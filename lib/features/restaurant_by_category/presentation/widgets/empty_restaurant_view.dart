// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class EmptyRestaurantsView extends StatelessWidget {
  final VoidCallback? onRetry;

  const EmptyRestaurantsView({super.key, this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFFFF6B35).withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.restaurant_menu, size: 60, color: Color(0xFFFF6B35)),
        ),
        const SizedBox(height: 20),
        const Text(
          "لا يوجد مطاعم حالياً",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Text(
          "لا توجد مطاعم ضمن هذا التصنيف حالياً، حاول مرة أخرى لاحقاً",
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
        ),
        const SizedBox(height: 25),
        if (onRetry != null)
          ElevatedButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh),
            label: const Text("إعادة المحاولة"),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF6B35),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
      ],
    );
  }
}