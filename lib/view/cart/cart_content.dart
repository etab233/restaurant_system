// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:restaurants_system/providers/cart_provider.dart';
import 'package:restaurants_system/view/cart/order.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CartContent extends ConsumerStatefulWidget {
  final int restaurantId;
  final String restaurantName;
  const CartContent({
    super.key,
    required this.restaurantId,
    required this.restaurantName,
  });

  @override
  ConsumerState<CartContent> createState() => CartContentState();
}

class CartContentState extends ConsumerState<CartContent> {
  String? token;
  List<Map<String, dynamic>> items = [];

  @override
  void initState() {
    super.initState();

    token = Hive.box("user_data").get("token") as String?;

    if (token != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref
            .read(cartProvider.notifier)
            .getRestaurantCart(
              token: token!,
              restaurantId: widget.restaurantId,
            );
      });
    }
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
    final state = ref.watch(cartProvider);
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
          icon: Icon(Icons.chevron_left_outlined, size: 30),
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
                    MaterialPageRoute(builder: (_) => Order()),
                  );
                } else {
                  await ref
                      .read(cartProvider.notifier)
                      .editeItemQuantity(token: token ?? '', items: items);

                  if (!mounted) return;
                  final newState = ref.read(cartProvider);
                  if (newState.message.isNotEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        padding: EdgeInsets.all(13),
                        margin: EdgeInsets.all(9),
                        behavior: SnackBarBehavior.floating,
                        content: Text(
                          newState.message,
                          style: TextStyle(fontSize: 20),
                        ),
                        backgroundColor: newState.status == 'success'
                            ? Colors.green
                            : Colors.red,
                        duration: Duration(seconds: 4),
                      ),
                    );

                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => Order()),
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
                backgroundColor: Color(0xFFFF6B35),
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
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Continue",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.delivery_dining_rounded, size: 30),
                      ],
                    ),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Skeletonizer(
            enabled: isLoading,
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  margin: EdgeInsets.all(8),
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
                          Skeleton.keep(
                            child: Icon(
                              Icons.shopping_cart_checkout,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                          SizedBox(width: 8),
                          Text(
                            "Total Amount",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                            ),
                          ),
                          Spacer(),
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
                Expanded(
                  child: ListView.builder(
                    itemCount: content?.itemCount,
                    itemBuilder: (context, index) {
                      int quantity = content?.item?[index].quantity ?? 1;
                      return Container(
                        margin: EdgeInsets.all(8),
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

                                      if ((content?.item?[index].variantName ??
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

                                                  backgroundColor: const Color(
                                                    0xFFFF6B35,
                                                  ).withOpacity(0.2),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          10,
                                                        ),
                                                    side: const BorderSide(
                                                      color: Colors.transparent,
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
                                                      color: Color(0xFFFF6B35),
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

                                IconButton(
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          content: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Container(
                                                padding: const EdgeInsets.all(
                                                  12,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: Colors.red.withOpacity(
                                                    0.12,
                                                  ),
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
                                                "Delete Item",
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              const Text(
                                                "Are you sure you want to delete this item?",
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
                                                      style:
                                                          ElevatedButton.styleFrom(
                                                            backgroundColor:
                                                                Colors.red,
                                                            foregroundColor:
                                                                Colors.white,
                                                          ),
                                                      onPressed: () {
                                                        final item = content
                                                            ?.item?[index];

                                                        if (item != null) {
                                                          ref
                                                              .read(
                                                                cartProvider
                                                                    .notifier,
                                                              )
                                                              .deleteItem(
                                                                token: token!,
                                                                itemId:
                                                                    item.itemId,
                                                              );
                                                        }
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
                                  icon: const Icon(
                                    Icons.delete_outline_rounded,
                                    color: Colors.red,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 16),

                            Row(
                              children: [
                                Text(
                                  "${formatPrice(content?.item?[index].lineTotal ?? '0')} SYP",
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
                                                .read(cartProvider.notifier)
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
                                              .read(cartProvider.notifier)
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
