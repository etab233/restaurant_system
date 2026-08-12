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

  static const _orange = Color(0xFFFF6B35);

  @override
  Widget build(BuildContext context) {
    final selected = isAvailable && isSelected;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: !isAvailable
              ? Colors.grey.shade100
              : selected
                  ? const Color(0xFFFFF4EF)
                  : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: !isAvailable
                ? Colors.grey.shade300
                : selected
                    ? _orange
                    : Colors.grey.shade300,
            width: selected ? 1.8 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: !isAvailable ? Colors.grey.shade200 : Colors.transparent,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Opacity(
                opacity: isAvailable ? 1 : 0.4,
                child: Image.asset(image, width: 48, height: 48),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: isAvailable ? Colors.black : Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    isAvailable ? subtitle : "غير متاح حاليًا",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            if (selected)
              Container(
                width: 32,
                height: 32,
                decoration: const BoxDecoration(
                  color: _orange,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check, color: Colors.white, size: 20),
              )
            else if (!isAvailable)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  "غير متاح",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}