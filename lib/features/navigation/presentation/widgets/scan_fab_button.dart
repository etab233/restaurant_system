// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class ScanFabButton extends StatelessWidget {
  final VoidCallback onTap;
  final Color color;
  final double size;

  const ScanFabButton({
    super.key,
    required this.onTap,
    required this.color,
    this.size = 50,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      customBorder: const CircleBorder(),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.35),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Image.asset("assets/images/powl.png", color: Colors.grey),
        /*Icon(
          Icons.document_scanner_rounded,
          color: Colors.white,
          size: 24,
        ),*/
      ),
    );
  }
}
