import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurants_system/features/auth/presentation/providers/auth_provider.dart';
import 'package:restaurants_system/features/order_tracking/data/models/order_model.dart';
import 'package:restaurants_system/features/order_tracking/presentation/providers/order/order_provider.dart';
import 'package:restaurants_system/features/sham_cash_payment/presentation/providers/sham_cash_provider.dart';
import 'package:restaurants_system/features/sham_cash_payment/presentation/screens/sham_cash_payment.dart';

class OrderPaymentButton extends ConsumerWidget {
  final OrderModel order;
  const OrderPaymentButton({super.key, required this.order});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final referenceNumber = order.referenceNumber ?? '';

    final isLoading = ref.watch(
      shamCashPaymentLoadingProvider(referenceNumber),
    );

    return SizedBox(
      width: double.infinity,
      height: 40,
      child: ElevatedButton(
        onPressed: isLoading
            ? null
            : () async {
                if (order.paymentMethod != "shamCash") {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: Colors.grey[700],
                      content: const Text("يرجى الدفع عند كاشير المطعم"),
                    ),
                  );
                  return;
                }

                ref
                        .read(
                          shamCashPaymentLoadingProvider(
                            referenceNumber,
                          ).notifier,
                        )
                        .state =
                    true;

                try {
                  final token = await ref
                      .read(authRepositoryProvider)
                      .getCurrentToken();

                  if (token == null || token.isEmpty) {
                    if (!context.mounted) return;

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Please login again.")),
                    );

                    return;
                  }

                  await ref
                      .read(shamCashNotifierProvider.notifier)
                      .getDeliveryFee(
                        referenceNumber: referenceNumber,
                        token: token,
                      );

                  if (!context.mounted) return;

                  final shamState = ref.read(shamCashNotifierProvider);

                  if (shamState.status == 'success') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ShamCashPayment(
                          referenceNumber: referenceNumber,
                          tenantId: order.tenantId ?? '',
                        ),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text(shamState.message)));
                  }
                } finally {
                  ref
                          .read(
                            shamCashPaymentLoadingProvider(
                              referenceNumber,
                            ).notifier,
                          )
                          .state =
                      false;
                }
              },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFFF6B35),
          foregroundColor: Colors.white,
          disabledBackgroundColor: const Color(0xFFFF6B35),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : const Text("Pay Now"),
      ),
    );
  }
}
