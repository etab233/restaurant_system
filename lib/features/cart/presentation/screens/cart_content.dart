// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurants_system/core/enums/meal_details_mode.dart';
import 'package:restaurants_system/features/cart/presentation/providers/cart_provider.dart';
import 'package:restaurants_system/features/checkout/presentation/screens/delivery_method_screen.dart';
import 'package:restaurants_system/features/meal_details/presentation/screens/meal_details_screens.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CartContent extends ConsumerStatefulWidget {
  final int restaurantId;
  final String restaurantName;
  final String tenantId;
  const CartContent({
    super.key,
    required this.restaurantId,
    required this.tenantId,
    required this.restaurantName,
  });

  @override
  ConsumerState<CartContent> createState() => CartContentState();
}

class CartContentState extends ConsumerState<CartContent> {
  List<Map<String, dynamic>> items = [];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(cartNotifierProvider.notifier)
          .getRestaurantCart(restaurantId: widget.restaurantId);
    });
  }

  String formatPrice(String value) {
    final price = double.tryParse(value) ?? 0;
    if (price == price.roundToDouble()) {
      return price.toInt().toString();
    }
    return price.toString();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(cartNotifierProvider);
    final content = state.cartContent;
    final bool isLoading = (state.status == "loading");

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: Text(widget.restaurantName),
        centerTitle: true,
        shape: Border(
          bottom: BorderSide(color: Colors.grey.shade300, width: 1),
        ),
        backgroundColor: const Color(0xFFF5F5F5),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.chevron_left_outlined, size: 30),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
          child: SizedBox(
            height: 54,
            child: ElevatedButton(
              onPressed: () async {
                if (items.isEmpty) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          DeliveryMethodScreen(tenantId: widget.tenantId),
                    ),
                  );
                } else {
                  await ref
                      .read(cartNotifierProvider.notifier)
                      .editeItemQuantity(items: items);

                  if (!mounted) return;
                  final newState = ref.read(cartNotifierProvider);
                  if (newState.message.isNotEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        padding: const EdgeInsets.all(13),
                        margin: const EdgeInsets.all(9),
                        behavior: SnackBarBehavior.floating,
                        content: Text(
                          newState.message,
                          style: const TextStyle(fontSize: 20),
                        ),
                        backgroundColor: newState.status == 'success'
                            ? Colors.green
                            : Colors.red,
                        duration: const Duration(seconds: 4),
                      ),
                    );

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            DeliveryMethodScreen(tenantId: widget.tenantId),
                      ),
                    );
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                //backgroundColor: const Color(0xFF263238),
                //backgroundColor: const Color(0xFF212121),
                //backgroundColor: Colors.grey.shade800,
                //backgroundColor: const Color(0xFF78909C),
                //backgroundColor: const Color(0xFF7C9CBF),
                //backgroundColor: const Color(0xFF8FAF9A),
                backgroundColor: const Color(0xFFFF6B35),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: isLoading
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2.5,
                      ),
                    )
                  : const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Continue",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        SizedBox(width: 8),
                        Icon(Icons.delivery_dining_rounded, size: 30),
                      ],
                    ),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Skeletonizer(
            enabled: isLoading,
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    //color: const Color(0xFF8FAF9A),
                    //color: const Color(0xFF7A8F63),
                    color: const Color(0xFF8A9A5B),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade200,
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
                          const Skeleton.keep(
                            child: Icon(
                              Icons.shopping_cart_checkout,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            "Total Amount",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                            ),
                          ),
                          const Spacer(),
                          const SizedBox(height: 12),

                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(.15),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              "${state.cartContent?.itemCount ?? 0} item${(state.cartContent?.itemCount ?? 0) > 1 ? 's' : ''}",
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 18),

                      Text(
                        "${formatPrice(state.cartContent?.subtotal ?? "0")} SYP",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                Directionality(
                  textDirection: TextDirection.rtl,
                  child: Expanded(
                    child: ListView.builder(
                      itemCount: content?.itemCount,
                      itemBuilder: (context, index) {
                        int quantity = content?.item?[index].quantity ?? 1;
                        return Container(
                          margin: const EdgeInsets.all(8),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(18),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(.04),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          content?.item?[index].itemName ?? '',
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),

                                        if ((content
                                                    ?.item?[index]
                                                    .variantName ??
                                                '')
                                            .isNotEmpty) ...[
                                          const SizedBox(height: 4),
                                          Text(
                                            content?.item?[index].variantName ??
                                                '',
                                            style: TextStyle(
                                              color: Colors.grey.shade600,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ],
                                        if ((content?.item?[index].modifiers ??
                                                '')
                                            .isNotEmpty) ...[
                                          const SizedBox(height: 8),
                                          Wrap(
                                            spacing: 6,
                                            runSpacing: 6,
                                            children: (content!.item![index].modifiers!)
                                                .split('،')
                                                .map(
                                                  (modifier) => Chip(
                                                    materialTapTargetSize:
                                                        MaterialTapTargetSize
                                                            .shrinkWrap,
                                                    visualDensity:
                                                        VisualDensity.compact,
                                                    labelPadding:
                                                        const EdgeInsets.symmetric(
                                                          horizontal: 6,
                                                        ),

                                                    backgroundColor:
                                                        const Color(
                                                          0xFFFF6B35,
                                                        ).withOpacity(0.2),
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            10,
                                                          ),
                                                      side: const BorderSide(
                                                        color:
                                                            Colors.transparent,
                                                      ),
                                                    ),
                                                    avatar: Container(
                                                      width: 6,
                                                      height: 6,
                                                      decoration:
                                                          const BoxDecoration(
                                                            color: Color(
                                                              0xFFFF6B35,
                                                            ),
                                                            shape:
                                                                BoxShape.circle,
                                                          ),
                                                    ),

                                                    label: Text(
                                                      modifier.trim(),
                                                      style: const TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Color(
                                                          0xFFFF6B35,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                )
                                                .toList(),
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),

                                  PopupMenuButton<String>(
                                    icon: const Icon(
                                      Icons.more_vert,
                                      color: Colors.grey,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    onSelected: (value) {
                                      final item = content?.item?[index];

                                      if (item == null) return;

                                      switch (value) {
                                        case "edit":
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) => MealDetails(
                                                mode: MealDetailsMode.edit,
                                                itemId: item.itemId,
                                                restaurantId:
                                                    widget.restaurantId,
                                              ),
                                            ),
                                          );
                                          break;

                                        case "delete":
                                          showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                content: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                            12,
                                                          ),
                                                      decoration: BoxDecoration(
                                                        color: Colors.red
                                                            .withOpacity(0.12),
                                                        shape: BoxShape.circle,
                                                      ),
                                                      child: const Icon(
                                                        Icons
                                                            .delete_outline_rounded,
                                                        color: Colors.red,
                                                        size: 40,
                                                      ),
                                                    ),

                                                    const SizedBox(height: 16),

                                                    const Text(
                                                      "Delete Item",
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),

                                                    const SizedBox(height: 8),

                                                    const Text(
                                                      "Are you sure you want to delete this item?",
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),

                                                    const SizedBox(height: 24),

                                                    Row(
                                                      children: [
                                                        Expanded(
                                                          child: OutlinedButton(
                                                            onPressed: () {
                                                              Navigator.pop(
                                                                context,
                                                              );
                                                            },
                                                            child: const Text(
                                                              "No",
                                                            ),
                                                          ),
                                                        ),

                                                        const SizedBox(
                                                          width: 12,
                                                        ),

                                                        Expanded(
                                                          child: ElevatedButton(
                                                            style: ElevatedButton.styleFrom(
                                                              backgroundColor:
                                                                  Colors.red,
                                                              foregroundColor:
                                                                  Colors.white,
                                                            ),
                                                            onPressed: () {
                                                              ref
                                                                  .read(
                                                                    cartNotifierProvider
                                                                        .notifier,
                                                                  )
                                                                  .deleteItem(
                                                                    itemId: item
                                                                        .itemId,
                                                                  );

                                                              Navigator.pop(
                                                                context,
                                                              );
                                                            },
                                                            child: const Text(
                                                              "Yes",
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                          );

                                          break;
                                      }
                                    },

                                    itemBuilder: (context) => [
                                      const PopupMenuItem(
                                        value: "edit",
                                        child: Row(
                                          children: [
                                            Icon(Icons.edit_outlined),
                                            SizedBox(width: 12),
                                            Text(
                                              "Edit",
                                              style: TextStyle(fontSize: 16),
                                            ),
                                          ],
                                        ),
                                      ),

                                      const PopupMenuItem(
                                        value: "delete",
                                        child: Row(
                                          children: [
                                            Icon(Icons.delete_outline),
                                            SizedBox(width: 12),
                                            Text(
                                              "Delete",
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.red,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),

                              const SizedBox(height: 16),

                              Row(
                                children: [
                                  Text(
                                    "${formatPrice(content?.item?[index].lineTotal ?? '0')} SYP",
                                    textDirection: TextDirection.ltr,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFFFF6B35),
                                    ),
                                  ),

                                  const Spacer(),

                                  Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.grey.shade300,
                                      ),
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    child: Row(
                                      children: [
                                        IconButton(
                                          onPressed: () {
                                            if (quantity > 1) {
                                              ref
                                                  .read(
                                                    cartNotifierProvider
                                                        .notifier,
                                                  )
                                                  .updateQuantity(
                                                    quantity: quantity - 1,
                                                    index: index,
                                                  );
                                              // حفظ القيم الجديدة
                                              final itemId =
                                                  content!.item![index].itemId;
                                              final newQuantity = quantity - 1;
                                              // هل العنصر محفوظ مسبقاً
                                              final existingIndex = items
                                                  .indexWhere(
                                                    (e) =>
                                                        e['item_id'] == itemId,
                                                  );
                                              // إذا موجود نعدل الكمية فقط
                                              if (existingIndex != -1) {
                                                items[existingIndex]['quantity'] =
                                                    newQuantity;
                                              } else {
                                                items.add({
                                                  'item_id': itemId,
                                                  'quantity': newQuantity,
                                                });
                                              }
                                            }
                                          },
                                          icon: const Icon(
                                            Icons.remove,
                                            color: Color(0xFFFF6B35),
                                          ),
                                        ),

                                        Text(
                                          "$quantity",
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),

                                        IconButton(
                                          onPressed: () {
                                            ref
                                                .read(
                                                  cartNotifierProvider.notifier,
                                                )
                                                .updateQuantity(
                                                  quantity: quantity + 1,
                                                  index: index,
                                                );

                                            // حفظ القيم الجديدة
                                            final itemId =
                                                content!.item![index].itemId;
                                            final newQuantity = quantity + 1;
                                            // هل العنصر محفوظ مسبقاً
                                            final existingIndex = items
                                                .indexWhere(
                                                  (e) => e['item_id'] == itemId,
                                                );
                                            // إذا موجود نعدل الكمية فقط
                                            if (existingIndex != -1) {
                                              items[existingIndex]['quantity'] =
                                                  newQuantity;
                                            } else {
                                              items.add({
                                                'item_id': itemId,
                                                'quantity': newQuantity,
                                              });
                                            }
                                          },
                                          icon: const Icon(
                                            Icons.add,
                                            color: Color(0xFFFF6B35),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
