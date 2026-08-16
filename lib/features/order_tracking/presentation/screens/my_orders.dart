// ignore_for_file: use_build_context_synchronously, prefer_typing_uninitialized_variables, depend_on_referenced_packages, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurants_system/features/auth/presentation/providers/auth_provider.dart';
import 'package:restaurants_system/features/order_tracking/data/models/order_model.dart';
import 'package:restaurants_system/features/order_tracking/presentation/providers/order/order_provider.dart';
import 'package:restaurants_system/features/order_tracking/presentation/providers/order_track/order_track_notifier.dart';
import 'package:restaurants_system/features/order_tracking/presentation/providers/order_track/order_track_provider.dart';
import 'package:restaurants_system/features/order_tracking/presentation/screens/order_details.dart';
import 'package:restaurants_system/features/order_tracking/presentation/widgets/order_payment_button.dart';
import 'package:restaurants_system/features/order_tracking/presentation/screens/order_not_found.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:intl/intl.dart';

class MyOrders extends ConsumerStatefulWidget {
  const MyOrders({super.key});

  @override
  ConsumerState<MyOrders> createState() => MyOrdersState();
}

class MyOrdersState extends ConsumerState<MyOrders> {
  String formatDate(DateTime? date) {
    if (date == null) return "";

    return DateFormat('dd MMM • hh:mm a').format(date);
  }

  Color getStatusColor(String? status) {
    switch (status) {
      case 'pending':
        return Colors.orange;

      case 'confirmed':
        return Colors.blue;

      case 'ready':
        return Colors.purple;

      case 'delivered':
        return Colors.green;

      default:
        return Colors.grey;
    }
  }

  IconData getStatusIcon(String? status) {
    switch (status) {
      case 'pending':
        return Icons.hourglass_top;

      case 'confirmed':
        return Icons.check_circle_outline;

      case 'ready':
        return Icons.restaurant;

      case 'delivered':
        return Icons.task_alt;

      default:
        return Icons.help_outline;
    }
  }

  String timeLabel(String? status) {
    switch (status) {
      case "confirmed":
        return "Confirmed at";
      case "ready":
        return "Ready at";
      case "delivered":
        return "Delivered at";
      default:
        return "Placed at";
    }
  }

  OrderTrackNotifier? myData;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(orderTrackNotifierProvider);
    final authState = ref.watch(authNotifierProvider);

    final isLoading =
        state.orderStatus != "success" && state.orderStatus != "error";
    final items = isLoading ? List.generate(5, (_) => null) : state.orders;

    final hasError = state.orderStatus == "error";
    final isEmpty = !isLoading && state.orders.isEmpty;

    if (hasError || isEmpty || !authState.isLoggedIn) {
      return const Scaffold(body: OrderNotFound());
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Skeletonizer(
        enabled: isLoading,
        effect: ShimmerEffect(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
        ),
        child: RefreshIndicator(
          onRefresh: () async {
            await ref
                .read(orderTrackNotifierProvider.notifier)
                .getOrders(
                  status: state.statusFilter == 'all'
                      ? null
                      : state.statusFilter,
                  type: state.typeFilter == 'all' ? null : state.typeFilter,
                );
          },
          child: CustomScrollView(
            slivers: [
              _buildSliverAppBar(),
              _buildSliverList(count: items.length, orders: items),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      pinned: true,
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      title: const Text(
        "My Orders",
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.filter_alt_outlined),
          onPressed: _showFilterBottomSheet,
        ),
      ],
    );
  }

  void _showFilterBottomSheet() async {
    final state = ref.read(orderTrackNotifierProvider);
    final result = await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      builder: (_) {
        return FilterBottomSheet(
          initialStatus: state.statusFilter ?? 'all',
          initialType: state.typeFilter ?? 'all',
        );
      },
    );
    if (result != null) {
      final status = result['status'];
      final type = result['type'];

      ref
          .read(orderTrackNotifierProvider.notifier)
          .getOrders(status: status, type: type);
    }
  }

  Widget _buildSliverList({
    required int count,
    required List<OrderModel?> orders,
  }) {
    DateTime? displayTime(OrderModel? order) {
      if (order == null) return null;

      switch (order.status) {
        case "confirmed":
          return order.confirmedAt;

        case "ready":
          return order.readyAt;

        default:
          return order.placedAt;
      }
    }

    String displayStatus(String? status) {
      switch (status) {
        case "pending":
          return "Pending";

        case "confirmed":
          return "Confirmed";

        case "preparing":
          return "Preparing";

        case "ready":
          return "Ready";

        case "delivered":
          return "Delivered";

        case "cancelled":
          return "Cancelled";

        default:
          return status ?? "";
      }
    }

    return SliverList.builder(
      itemCount: count,
      itemBuilder: (context, index) {
        final order = orders[index];

        return InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => OrderDetailsScreen(
                  referenceNumber: order?.referenceNumber ?? '',
                ),
              ),
            );
          },
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 12,
                  offset: const Offset(0, 5),
                ),
              ],
            ),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// ================= HEADER =================
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// MAIN ROW (NAME + PRICE + STATUS)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        /// ICON
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: const Color(0xFFFF6B35).withOpacity(0.12),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            order?.type == "delivery"
                                ? Icons.delivery_dining
                                : Icons.shopping_bag_outlined,
                            color: const Color(0xFFFF6B35),
                          ),
                        ),

                        const SizedBox(width: 12),

                        /// NAME
                        Expanded(
                          child: Text(
                            order?.restaurantName ?? "",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),

                        /// STATUS
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: getStatusColor(
                                      order?.status,
                                    ).withOpacity(0.12),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    displayStatus(order?.status),
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: getStatusColor(order?.status),
                                    ),
                                  ),
                                ),

                                ///  CANCEL BUTTON (TOP RIGHT LINE)
                                if (order?.status == "pending") ...[
                                  const SizedBox(width: 5),
                                  Align(
                                    alignment: Alignment.topRight,
                                    child: InkWell(
                                      onTap: () async {
                                        final confirm = await showDialog<bool>(
                                          context: context,
                                          builder: (_) => AlertDialog(
                                            title: const Text("Delete Order"),
                                            content: const Text(
                                              "Do you sure you want to delete this order?",
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () => Navigator.pop(
                                                  context,
                                                  false,
                                                ),
                                                child: const Text("No"),
                                              ),
                                              TextButton(
                                                onPressed: () => Navigator.pop(
                                                  context,
                                                  true,
                                                ),
                                                child: const Text("Yes"),
                                              ),
                                            ],
                                          ),
                                        );

                                        if (confirm != true) return;

                                        await ref
                                            .read(
                                              orderNotifierProvider.notifier,
                                            )
                                            .cancelOrder(
                                              referenceNumber:
                                                  order?.referenceNumber ?? "",
                                            );

                                        if (!mounted) return;

                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          const SnackBar(
                                            content: Text("Order deleted"),
                                            backgroundColor: Colors.red,
                                          ),
                                        );

                                        await ref
                                            .read(
                                              orderTrackNotifierProvider
                                                  .notifier,
                                            )
                                            .getOrders();
                                      },
                                      child: const Icon(
                                        Icons.delete_outline,
                                        color: Colors.red,
                                        size: 26,
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                /// ================= ORDER INFO =================
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// TIME
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.schedule,
                          size: 14,
                          color: Colors.grey.shade500,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          "${timeLabel(order?.status)} • ${formatDate(displayTime(order))}",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    /// ORDER ID
                    Row(
                      children: [
                        Text(
                          "Order #${order?.referenceNumber ?? ""}",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade500,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Spacer(),

                        /// PRICE
                        Text(
                          "${(order?.total ?? 0).toStringAsFixed(0)} SYP",
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1B8F3A),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                /// ================= PAYMENT =================
                if (order?.status == "confirmed" && order?.paid == false) ...[
                  const SizedBox(height: 14),

                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF8F2),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFFFFD6BF)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Payment Required",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),

                        const SizedBox(height: 6),

                        Text(
                          "Complete payment to start preparing your order.",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade700,
                          ),
                        ),

                        const SizedBox(height: 10),

                        if (order != null) OrderPaymentButton(order: order),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}

class FilterBottomSheet extends StatefulWidget {
  final String initialStatus;
  final String initialType;
  const FilterBottomSheet({
    super.key,
    required this.initialStatus,
    required this.initialType,
  });

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  late String selectedStatus, selectedType;

  @override
  void initState() {
    super.initState();
    selectedStatus = widget.initialStatus;
    selectedType = widget.initialType;
  }

  final statuses = [
    'all',
    'pending',
    'confirmed',
    'ready',
    'delivered',
  ];
  final types = ['all', 'pickup', 'delivery'];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // الخط الرمادي (Drag handle)
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 10, bottom: 12),
              width: 50,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),

          // العنوان
          const Center(
            child: Text(
              "Filter Orders",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),

          const SizedBox(height: 20),
          const Text(
            "Status Filter",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: statuses.map((status) {
              return ChoiceChip(
                label: Text(status[0].toUpperCase() + status.substring(1)),
                selected: selectedStatus == status,
                onSelected: (value) {
                  setState(() {
                    selectedStatus = value ? status : 'all';
                  });
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
          const Text(
            "Order type",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: types.map((type) {
              return ChoiceChip(
                label: Text(type[0].toUpperCase() + type.substring(1)),
                selected: selectedType == type,
                onSelected: (value) {
                  setState(() {
                    selectedType = value ? type : 'all';
                  });
                },
              );
            }).toList(),
          ),

          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 55,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context, {
                  'status': selectedStatus == 'all' ? null : selectedStatus,
                  'type': selectedType == 'all' ? null : selectedType,
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4A6CF7),
                foregroundColor: Colors.white,
                elevation: 4,
                shadowColor: Colors.blue.withOpacity(0.3),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Text(
                "Apply Filters",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
