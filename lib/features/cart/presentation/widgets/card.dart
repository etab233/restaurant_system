// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class SelectCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String image;
  final bool isSelected;
  final bool isAvailable;
  final VoidCallback? onTap;

  const SelectCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.image,
    required this.isSelected,
    required this.isAvailable,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: !isAvailable
                ? Colors.grey.shade100
                : isSelected
                ? const Color(0xffFFF6F0)
                : Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: !isAvailable
                  ? Colors.grey.shade300
                  : isSelected
                  ? const Color(0xFFFF6B35)
                  : Colors.grey.shade300,
              width: isSelected && isAvailable ? 1.8 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(.12),
                blurRadius: 15,
                offset: const Offset(0, 6),
              ),
            ],
          ),

          child: Row(
            children: [
              /// الصورة
              Expanded(flex: 4, child: Image.asset(image, fit: BoxFit.contain)),

              const SizedBox(width: 20),

              /// النصوص
              Expanded(
                flex: 5,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      title,
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: isAvailable ? Colors.black : Colors.grey,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      subtitle,
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        color: isAvailable
                            ? Colors.grey.shade600
                            : Colors.grey.shade500,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
