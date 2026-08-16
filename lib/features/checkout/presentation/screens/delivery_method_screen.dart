// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurants_system/features/cart/presentation/providers/cart_provider.dart';
import 'package:restaurants_system/features/cart/presentation/widgets/checkout_stepper.dart';
import 'package:restaurants_system/features/checkout/presentation/providers/checkout_provider.dart';
import 'package:restaurants_system/features/checkout/presentation/widgets/select_card.dart';
import 'package:restaurants_system/features/checkout/presentation/screens/payment_method_screen.dart';

class DeliveryMethodScreen extends ConsumerStatefulWidget {
  final String tenantId;
  const DeliveryMethodScreen({super.key, required this.tenantId});

  @override
  ConsumerState<DeliveryMethodScreen> createState() =>
      _DeliveryMethodScreenState();
}

class _DeliveryMethodScreenState extends ConsumerState<DeliveryMethodScreen> {
  @override
  Widget build(BuildContext context) {
    final checkout = ref.watch(checkoutProvider);
    final cartState = ref.watch(cartNotifierProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFFF5F5F5),
        foregroundColor: Colors.black87,
        centerTitle: true,
        title: const Text(
          "طريقة الاستلام",
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
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF6B35),
              elevation: 2,
              shadowColor: const Color(0xFFFF6B35).withOpacity(0.4),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            onPressed: () async {
              if (checkout.deliveryType == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    margin: EdgeInsets.all(10),
                    behavior: SnackBarBehavior.floating,
                    content: Text('يرجى اختيار طريقة استلام الطلب'),
                  ),
                );
                return;
              }

              ref.read(checkoutProvider.notifier).setTenantId(widget.tenantId);

              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const PaymentMethodScreen()),
              );
            },
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Next",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                SizedBox(width: 8),
                Icon(Icons.arrow_forward_ios, size: 18, color: Colors.white),
              ],
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const CheckoutStepper(currentStep: 0),
                    const SizedBox(height: 20),
                    const Text(
                      "كيف تود استلام طلبك؟",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Directionality(
                      textDirection: TextDirection.rtl,
                      child: Column(
                        children: [
                          SelectCard(
                            title: "توصيل للمنزل",
                            subtitle: "يصلك طلبك إلى باب منزلك",
                            image: "assets/images/delivery.webp",
                            isSelected: checkout.deliveryType == "delivery",
                            isAvailable:
                                cartState.cartContent?.hasDelivery ?? false,
                            onTap: cartState.cartContent?.hasDelivery ?? false
                                ? () {
                                    ref
                                        .read(checkoutProvider.notifier)
                                        .setDeliveryType("delivery");
                                  }
                                : null,
                          ),
                          const SizedBox(height: 14),
                          SelectCard(
                            title: "استلام من المطعم",
                            subtitle: "استلم طلبك بنفسك من المطعم",
                            image: "assets/images/restaurant.webp",
                            isSelected: checkout.deliveryType == 'pickup',
                            isAvailable: true,
                            onTap: () {
                              ref
                                  .read(checkoutProvider.notifier)
                                  .setDeliveryType("pickup");
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
