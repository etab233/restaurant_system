// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurants_system/features/order_tracking/data/models/order_detail_model.dart';
import 'package:restaurants_system/features/order_tracking/presentation/providers/order/order_provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

class OrderDetailsScreen extends ConsumerStatefulWidget {
  final String referenceNumber;

  const OrderDetailsScreen({super.key, required this.referenceNumber});

  @override
  ConsumerState<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends ConsumerState<OrderDetailsScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(orderNotifierProvider.notifier)
          .getOrderDetails(referenceNumber: widget.referenceNumber);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(orderNotifierProvider);
    final isLoading = state.status == "loading" || state.orderDetails == null;

    final details =
        state.orderDetails ??
        OrderDetailsResponse(
          status: "",
          message: "",
          data: List.generate(
            3,
            (_) => OrderDetailItem(
              itemName: "اسم المنتج",
              variantName: "الحجم",
              unitPrice: 0,
              quantity: 0,
              lineTotal: 0,
              modifierGroups: [
                ModifierGroup(
                  name: "الإضافات",
                  modifiers: [Modifier(modifierName: "إضافة", price: 0)],
                ),
              ],
            ),
          ),
        );

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),

      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F5F5),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Order Details",
          style: TextStyle(
            color: Color(0xff222222),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Skeletonizer(
          enabled: isLoading,
          child: ListView.separated(
            padding: const EdgeInsets.all(20),

            itemCount: details.data.length + 1,

            separatorBuilder: (_, __) => const SizedBox(height: 18),

            itemBuilder: (context, index) {
              // Total Card
              if (index == details.data.length) {
                final total = details.data.fold<double>(
                  0,
                  (sum, item) => sum + item.lineTotal,
                );

                return TotalCard(total: total);
              }

              final item = details.data[index];

              return ProductCard(item: item);
            },
          ),
        ),
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final OrderDetailItem item;

  const ProductCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(26),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.05),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,

                decoration: BoxDecoration(
                  color: const Color(0xfffff0df),

                  borderRadius: BorderRadius.circular(10),
                ),

                child: const Center(
                  child: Icon(Icons.restaurant_menu, size: 20),
                ),
              ),

              const SizedBox(width: 15),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Text(
                      item.itemName,

                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    if (item.variantName != null)
                      Text(
                        item.variantName!,

                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          Row(
            children: [
              Expanded(
                child: InfoCard(
                  icon: Icons.payments_rounded,
                  title: "السعر",
                  value: "${item.unitPrice} ل.س",
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: InfoCard(
                  icon: Icons.inventory_2_rounded,
                  title: "الكمية",
                  value: "${item.quantity}",
                ),
              ),
            ],
          ),

          if (item.modifierGroups.isNotEmpty) ...[
            const SizedBox(height: 20),

            const Row(
              children: [
                Icon(Icons.tune_rounded, size: 20, color: Color(0xff4A7A2E)),
                SizedBox(width: 8),
                Text(
                  "الإضافات",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 10),

            ...item.modifierGroups.map(
              (group) => ModifierGroupCard(group: group),
            ),
          ],

          const SizedBox(height: 18),

          Align(
            alignment: Alignment.centerRight,

            child: Text(
              "المجموع: ${item.lineTotal} ل.س",

              style: const TextStyle(
                color: Color(0xff4A7A2E),

                fontSize: 18,

                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ModifierGroupCard extends StatelessWidget {
  final ModifierGroup group;

  const ModifierGroupCard({super.key, required this.group});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),

      padding: const EdgeInsets.all(12),

      decoration: BoxDecoration(
        color: const Color(0xffF8F6F0),

        borderRadius: BorderRadius.circular(14),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Text(group.name, style: const TextStyle(fontWeight: FontWeight.bold)),

          const SizedBox(height: 6),

          ...group.modifiers.map(
            (modifier) => Row(
              children: [
                const Text("• "),

                Text(modifier.modifierName),

                const Spacer(),

                Text(
                  "+${modifier.price} ل.س",
                  style: const TextStyle(color: Colors.green),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class TotalCard extends StatelessWidget {
  final double total;

  const TotalCard({super.key, required this.total});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(25),
      ),

      child: Column(
        children: [
          const Text(
            "الإجمالي",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 10),

          Text(
            "$total ل.س",

            style: const TextStyle(
              color: Color(0xff4A7A2E),

              fontSize: 20,

              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class InfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final Color? iconColor;

  const InfoCard({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xffF8F6F0),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: iconColor ?? const Color(0xff4A7A2E)),
              const SizedBox(width: 6),
              Text(
                title,
                style: TextStyle(
                  color: Colors.grey.shade700,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: Color(0xff222222),
            ),
          ),
        ],
      ),
    );
  }
}
