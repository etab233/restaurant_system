import 'package:flutter/material.dart';

class FloatingBubble extends StatelessWidget {
  final Animation<double> animation;
  final double size;
  final Color color;
  final double top;
  final double? left;
  final double? right;

  const FloatingBubble({
    super.key,
    required this.animation,
    required this.size,
    required this.color,
    required this.top,
    this.left,
    this.right,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (_, __) => Positioned(
        top: top + animation.value,
        left: left,
        right: right,
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(shape: BoxShape.circle, color: color),
        ),
      ),
    );
  }
}
