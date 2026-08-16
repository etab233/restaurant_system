// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurants_system/core/widgets/app_network_image.dart';
import 'package:restaurants_system/features/cart/presentation/providers/cart_provider.dart';
import 'package:restaurants_system/features/cart/presentation/screens/cart_content.dart';
import 'package:restaurants_system/features/cart/presentation/screens/empty_cart.dart';
import 'package:restaurants_system/features/cart/presentation/screens/locked_screen.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CartRestaurantsScreen extends ConsumerStatefulWidget {
  const CartRestaurantsScreen({super.key});

  @override
  ConsumerState<CartRestaurantsScreen> createState() =>
      CartRestaurantsScreenState();
}

class CartRestaurantsScreenState extends ConsumerState<CartRestaurantsScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(cartNotifierProvider);
    final isLoading = (state.status == "loading");
    final items = isLoading ? List.generate(5, (_) => null) : state.items;

    if (state.status == "unauthenticated") {
      return const LoginRequiredCartView();
    }

    if (!isLoading && state.items.isEmpty) {
      return const EmptyCartView();
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text("My Carts"),
        centerTitle: true,
        shape: Border(
          bottom: BorderSide(color: Colors.grey.shade300, width: 1),
        ),
        backgroundColor: const Color(0xFFF5F5F5),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Skeletonizer(
            enabled: isLoading,
            child: RefreshIndicator(
              onRefresh: () async {
                await ref.read(cartNotifierProvider.notifier).index();
              },
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(15),
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF3ED),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: const BoxDecoration(
                            color: Color(0xFFFFE8D9),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.shopping_bag_outlined,
                            color: Color(0xFFFF6B35),
                            size: 30,
                          ),
                        ),

                        const SizedBox(width: 16),

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "You have ${state.items.length} restaurant carts",
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              const SizedBox(height: 6),

                              Text(
                                "Review your carts and place your order",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        return RestaurantCartCard(
                          name: items[index]?.restaurantName ?? '',
                          logo: items[index]?.logo,
                          itemCount: items[index]?.itemCount ?? 1,
                          subtotal: items[index]?.subtotal ?? '',
                          id: items[index]?.restaurantId ?? 0,
                          previewItems:
                              items[index]?.items
                                  .map((item) => item.itemName)
                                  .toList() ??
                              [],
                          isDeliveryAvailable: true,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => CartContent(
                                  restaurantId: items[index]?.restaurantId ?? 0,
                                  tenantId: items[index]?.tenantId ?? "",
                                  restaurantName:
                                      items[index]?.restaurantName ?? '',
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// _______________________________________________
// restaurant_card in cart widget
// _______________________________________________

class RestaurantCartCard extends ConsumerStatefulWidget {
  final String name;
  final String? logo;
  final int id;
  final int itemCount;
  final String subtotal;
  final bool isDeliveryAvailable;
  final List<String> previewItems;
  final VoidCallback onTap;

  const RestaurantCartCard({
    super.key,
    required this.name,
    required this.logo,
    required this.id,
    required this.itemCount,
    required this.subtotal,
    required this.isDeliveryAvailable,
    required this.previewItems,
    required this.onTap,
  });

  @override
  ConsumerState<RestaurantCartCard> createState() => RestaurantCartCardState();
}

class RestaurantCartCardState extends ConsumerState<RestaurantCartCard> {
  String formatPrice(String value) {
    final price = double.tryParse(value) ?? 0;
    if (price == price.roundToDouble()) {
      return price.toInt().toString();
    }
    return price.toString();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(15),
      onTap: widget.onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        //height: 235,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              blurRadius: 18,
              offset: const Offset(0, 8),
              color: Colors.black.withOpacity(.05),
            ),
          ],
        ),
        child: Stack(
          children: [
            const Positioned(
              top: 100,
              right: 20,
              child: Icon(
                Icons.arrow_forward_ios_rounded,
                size: 20,
                color: Colors.grey,
              ),
            ),

            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      // =========================
                      // TOP ROW
                      // =========================
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,

                        children: [
                          AppNetworkImage(
                            imageUrl: widget.logo,
                            width: 56,
                            height: 56,
                            borderRadius: BorderRadius.circular(
                              28,
                            ), // نص العرض = دائرة كاملة
                            fallback: Container(
                              width: 56,
                              height: 56,
                              color: Colors.grey.shade200,
                              child: const Icon(Icons.restaurant, size: 30),
                            ),
                            placeholder: Container(
                              width: 56,
                              height: 56,
                              color: Colors.grey.shade200,
                              child: const Icon(Icons.restaurant, size: 30),
                            ),
                          ),

                          const SizedBox(width: 20),

                          Expanded(
                            child: Text(
                              widget.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),

                          InkWell(
                            borderRadius: BorderRadius.circular(20),
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(12),
                                          decoration: BoxDecoration(
                                            color: Colors.red.withOpacity(0.12),
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(
                                            Icons.delete_outline_rounded,
                                            color: Colors.red,
                                            size: 40,
                                          ),
                                        ),

                                        const SizedBox(height: 16),

                                        const Text(
                                          "Delete Cart",
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const Text(
                                          "Are you sure you want to delete this cart?",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(fontSize: 16),
                                        ),

                                        const SizedBox(height: 24),

                                        Row(
                                          children: [
                                            Expanded(
                                              child: OutlinedButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: const Text("No"),
                                              ),
                                            ),

                                            const SizedBox(width: 12),

                                            Expanded(
                                              child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors.red,
                                                  foregroundColor: Colors.white,
                                                ),
                                                onPressed: () {
                                                  ref
                                                      .read(
                                                        cartNotifierProvider
                                                            .notifier,
                                                      )
                                                      .deleteCart(
                                                        id: widget.id,
                                                      );

                                                  Navigator.pop(context);
                                                },
                                                child: const Text("Yes"),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            },
                            child: const Icon(
                              Icons.delete_outline_rounded,
                              size: 30,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),

                      // =========================
                      // MIDDLE ROW
                      // =========================
                      Row(
                        children: [
                          const Icon(
                            Icons.shopping_bag_outlined,
                            color: Color(0xFFFF6B35),
                            size: 18,
                          ),
                          const SizedBox(width: 6),
                          Flexible(
                            child: Text(
                              "${widget.itemCount} items:",
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(color: Colors.grey.shade600),
                            ),
                          ),
                          const Spacer(),
                        ],
                      ),

                      const SizedBox(height: 8),

                      // =========================
                      // ITEMS
                      // =========================
                      Column(
                        children: [
                          ...widget.previewItems
                              .take(2)
                              .map(
                                (item) => Padding(
                                  padding: const EdgeInsets.only(left: 20),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 8,
                                        height: 8,
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.green,
                                        ),
                                      ),

                                      const SizedBox(width: 12),

                                      Expanded(
                                        child: Text(
                                          item,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(fontSize: 16),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                          if (widget.itemCount > 3)
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "+${widget.itemCount - 3} more items",
                                style: const TextStyle(
                                  color: Colors.green,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),

                          const SizedBox(height: 10),

                          Divider(color: Colors.grey.shade200),

                          // =========================
                          // FOOTER
                          // =========================
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  "${formatPrice(widget.subtotal)} SYP",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFFFF6B35),
                                  ),
                                ),
                              ),

                              const SizedBox(width: 20),

                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 3,
                                ),
                                decoration: BoxDecoration(
                                  color: widget.isDeliveryAvailable
                                      ? Colors.green.withOpacity(.08)
                                      : Colors.red.withOpacity(.08),
                                  borderRadius: BorderRadius.circular(18),
                                  border: Border.all(
                                    color: widget.isDeliveryAvailable
                                        ? Colors.green.withOpacity(.2)
                                        : Colors.red.withOpacity(.2),
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.delivery_dining,
                                      size: 25,
                                      color: widget.isDeliveryAvailable
                                          ? Colors.green
                                          : Colors.red,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      widget.isDeliveryAvailable
                                          ? "Available"
                                          : "Closed",
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
