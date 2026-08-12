import 'package:flutter/material.dart';
import 'package:restaurants_system/features/checkout/presentation/widgets/step_item.dart';

class CheckoutStepper extends StatelessWidget {
  final int currentStep;
  const CheckoutStepper({super.key, required this.currentStep});

  static const double _circleSize = 45;
  static const double _dividerThickness = 2;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start, // ← بدل center
        children: [
          StepItem(
            title: "طريقة الاستلام",
            icon: Icons.delivery_dining,
            isActive: currentStep >= 0,
          ),

          Expanded(child: _buildDivider(isActive: currentStep >= 1)),

          StepItem(
            title: "طريقة الدفع",
            icon: Icons.payment_outlined,
            isActive: currentStep >= 1,
          ),

          Expanded(child: _buildDivider(isActive: currentStep >= 2)),

          StepItem(
            icon: Icons.check_circle_outline,
            title: "تأكيد الطلب",
            isActive: currentStep >= 2,
          ),
        ],
      ),
    );
  }

  Widget _buildDivider({required bool isActive}) {
    return Padding(
      // نص ارتفاع الدائرة مطروح منه نص سماكة الخط = محاذاة دقيقة مع مركزها
      padding: const EdgeInsets.only(
        top: (_circleSize / 2) - (_dividerThickness / 2),
      ),
      child: Divider(
        thickness: _dividerThickness,
        color: isActive ? const Color(0xFFFF6B35) : Colors.grey.shade300,
      ),
    );
  }
}