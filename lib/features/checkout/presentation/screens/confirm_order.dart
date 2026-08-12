// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurants_system/core/navigation/main_tabs.dart';
import 'package:restaurants_system/features/cart/presentation/widgets/checkout_stepper.dart';
import 'package:restaurants_system/features/checkout/presentation/providers/checkout_provider.dart';
import 'package:restaurants_system/features/navigation/presentation/providers/bottom_navigation_bar_provider.dart';
import 'package:restaurants_system/features/order_tracking/presentation/providers/order/order_provider.dart';

class ConfirmOrder extends ConsumerStatefulWidget {
  const ConfirmOrder({super.key});

  @override
  ConsumerState<ConfirmOrder> createState() => _ConfirmOrderState();
}

class _ConfirmOrderState extends ConsumerState<ConfirmOrder> {
  @override
  Widget build(BuildContext context) {
    final checkout = ref.read(checkoutProvider);
    final orderState = ref.watch(orderNotifierProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFFF5F5F5),
        foregroundColor: Colors.black87,
        centerTitle: true,
        title: const Text(
          "تأكيد الطلب",
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
        decoration: BoxDecoration(
          color: const Color(0xFFF7F7F8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 12,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SizedBox(
          width: double.infinity,
          height: 54,
          child: ElevatedButton(
            onPressed: orderState.isMakingOrder
                ? null
                : () async {
                    await ref
                        .read(orderNotifierProvider.notifier)
                        .makeOrder(
                          tenantId: checkout.tenantId ?? '',
                          type: checkout.deliveryType!,
                          paymentMethode: checkout.paymentMethod!,
                          address: checkout.address!,
                          latitude: checkout.latitude,
                          longitude: checkout.longitude,
                        );

                    if (!mounted) return;
                    final newState = ref.read(orderNotifierProvider);

                    if (newState.message != null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          padding: const EdgeInsets.all(13),
                          margin: const EdgeInsets.all(9),
                          behavior: SnackBarBehavior.floating,
                          content: Text(
                            newState.message!,
                            style: const TextStyle(fontSize: 20),
                          ),
                          backgroundColor: newState.status == 'success'
                              ? Colors.green
                              : Colors.red,
                          duration: const Duration(seconds: 4),
                        ),
                      );
                      if (newState.status == 'success') {
                        ref.read(checkoutProvider.notifier).reset();
                        if (!mounted) return;

                        ref
                            .read(bottomNavbarProvider.notifier)
                            .setTab(MainTab.order);

                        Navigator.of(
                          context,
                        ).popUntil((route) => route.isFirst);
                      }
                    }
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF6B35),
              elevation: 2,
              shadowColor: const Color(0xFFFF6B35).withOpacity(0.4),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: orderState.isMakingOrder
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Confirm",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.done, size: 18, color: Colors.white),
                    ],
                  ),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const CheckoutStepper(currentStep: 2),
              const SizedBox(height: 20),
              const Text(
                "راجع بيانات طلبك قبل الإرسال",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  height: 1,
                ),
              ),
              const SizedBox(height: 24),
              Column(
                children: [
                  SummaryCard(
                    icon: checkout.deliveryType == "delivery"
                        ? Icons.delivery_dining_rounded
                        : Icons.store,
                    title: "طريقة الاستلام",
                    value: checkout.deliveryType == "delivery"
                        ? "توصيل للمنزل"
                        : "استلام من المطعم",
                  ),
                  const SizedBox(height: 16),
                  SummaryCard(
                    icon: Icons.account_balance_wallet_outlined,
                    title: "طريقة الدفع",
                    value: checkout.paymentMethod == "cash"
                        ? "الدفع نقداً"
                        : "شام كاش",
                  ),
                  if (checkout.deliveryType == "delivery") ...[
                    const SizedBox(height: 16),
                    SummaryCard(
                      icon: Icons.location_on_outlined,
                      title: "عنوان التوصيل",
                      value: checkout.address ?? "",
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SummaryCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const SummaryCard({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.05),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: const Color(0xffFFF3EC),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: const Color(0xFFFF6B35), size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  title,
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  value,
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
