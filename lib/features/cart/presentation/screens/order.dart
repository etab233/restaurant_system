// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:restaurants_system/core/navigation/main_tabs.dart';
import 'package:restaurants_system/features/cart/presentation/providers/cart_provider.dart';
import 'package:restaurants_system/features/navigation/presentation/providers/bottom_navigation_bar_provider.dart';
import 'package:restaurants_system/features/order_tracking/presentation/providers/order/order_provider.dart';

class Order extends ConsumerStatefulWidget {
  final String? tenantId;
  const Order({super.key, required this.tenantId});
  @override
  ConsumerState<Order> createState() => OrderState();
}

class OrderState extends ConsumerState<Order> {
  String? location;
  late TextEditingController locationController;
  String orderWay = "";
  String payWay = "";
  final _formKey = GlobalKey<FormState>();

  // تابع لاختصار نص العنوان إن وجد
  String? shortAddress(String? address) {
    if (address == null) return null;
    final parts = address.split(',');

    if (parts.length >= 3) {
      return '${parts[0].trim()}، ${parts[1].trim()}، ${parts[parts.length - 2].trim()}';
    }

    return address;
  }

  @override
  void initState() {
    super.initState();

    locationController = TextEditingController(text: shortAddress(location));
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(cartNotifierProvider);
    final orderState = ref.watch(orderNotifierProvider);
    bool isShamAvailable = state.cartContent?.payByShamCach ?? false;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text("Place Order"),
        centerTitle: true,
        shape: Border(
          bottom: BorderSide(color: Colors.grey.shade300, width: 1),
        ),
        backgroundColor: const Color(0xFFF5F5F5),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.chevron_left_outlined, size: 30),
        ),
        actions: [
          const Padding(
            padding: EdgeInsets.only(right: 10),
            child: Icon(
              Icons.article_outlined,
              size: 30,
              color: Color(0xFFFF6B35),
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
          child: SizedBox(
            height: 54,
            child: ElevatedButton(
              onPressed: orderState.isMakingOrder
                  ? null
                  : () async {
                      if (!_formKey.currentState!.validate()) {
                        return;
                      }
                      if (orderWay == "") {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            margin: EdgeInsets.all(10),
                            behavior: SnackBarBehavior.floating,
                            content: Text('يرجى اختيار طريقة استلام الطلب'),
                          ),
                        );
                        return;
                      }

                      if (payWay == "") {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            behavior: SnackBarBehavior.floating,
                            margin: EdgeInsets.all(10),
                            content: Text('يرجى اختيار طريقة الدفع'),
                          ),
                        );
                        return;
                      }

                      await ref
                          .read(orderNotifierProvider.notifier)
                          .makeOrder(
                            tenantId: widget.tenantId!,
                            type: orderWay,
                            paymentMethode: payWay,
                            address: locationController.text,
                          );

                      if (!mounted) return;
                      final newState = ref.read(orderNotifierProvider);

                      if (newState.message != null) {
                        if (newState.status == 'success') {
                          await Future.delayed(const Duration(seconds: 1));

                          if (!mounted) return;

                          ref
                              .read(bottomNavbarProvider.notifier)
                              .setTab(MainTab.home);
                          Navigator.of(
                            context,
                          ).popUntil((route) => route.isFirst);
                        } else {
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
                        }
                      }
                    },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: const Color(0xFFFF6B35),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
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
                          "Confirm order",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        SizedBox(width: 8),
                        Icon(Icons.shopping_cart_checkout, size: 25),
                      ],
                    ),
            ),
          ),
        ),
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    // حقل الموقع
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(
                                Icons.location_on_outlined,
                                size: 22,
                                color: Color(0xFFFF6B35),
                              ),
                              SizedBox(width: 6),
                              Text(
                                "عنوان التوصيل",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 12),

                          TextFormField(
                            controller: locationController,
                            textDirection: TextDirection.rtl,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "أدخل العنوان";
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              hintText: "أدخل عنوان التوصيل",
                              hintTextDirection: TextDirection.rtl,

                              prefixIcon: const Icon(
                                Icons.home_outlined,
                                size: 28,
                                color: Color(0xFFFF6B35),
                              ),

                              filled: true,
                              fillColor: Colors.white,

                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 16,
                              ),

                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide: BorderSide.none,
                              ),

                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide: BorderSide(
                                  color: Colors.grey.shade300,
                                ),
                              ),

                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide: const BorderSide(
                                  color: Color(0xFFFF6B35),
                                  width: 1.5,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // طريقة استلام الطلب
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          const Row(
                            children: [
                              Icon(
                                Icons.local_shipping_outlined,
                                size: 22,
                                color: Color(0xFFFF6B35),
                              ),
                              SizedBox(width: 6),
                              Text(
                                "طريقة استلام الطلب:",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 12),

                          Container(
                            height: 180,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      orderWay = "pickup";
                                    });
                                  },
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    decoration: BoxDecoration(
                                      color: (orderWay == "pickup")
                                          ? const Color(0xFFFFF4EF)
                                          : Colors.white,
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(
                                        color: (orderWay == "pickup")
                                            ? const Color(0xFFFF6B35)
                                            : Colors.grey.shade300,
                                        width: (orderWay == "pickup") ? 1.8 : 1,
                                      ),
                                    ),
                                    padding: const EdgeInsets.all(10),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 50,
                                          height: 50,
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFFF6B35),
                                            borderRadius: BorderRadius.circular(
                                              14,
                                            ),
                                          ),
                                          child: const Icon(
                                            Icons.storefront_outlined,
                                            color: Colors.white,
                                            size: 28,
                                          ),
                                        ),

                                        const SizedBox(width: 14),

                                        const Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "استلام من المطعم",
                                                style: TextStyle(
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),

                                              SizedBox(height: 4),

                                              Text(
                                                "سيتم استلام الطلب من الفرع",
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),

                                        if (orderWay == "pickup")
                                          Container(
                                            width: 32,
                                            height: 32,
                                            decoration: const BoxDecoration(
                                              color: Color(0xFFFF6B35),
                                              shape: BoxShape.circle,
                                            ),
                                            child: const Icon(
                                              Icons.check,
                                              color: Colors.white,
                                              size: 20,
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                InkWell(
                                  onTap: state.cartContent?.hasDelivery ?? false
                                      ? () {
                                          setState(() {
                                            orderWay = "delivery";
                                          });
                                        }
                                      : null,
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    decoration: BoxDecoration(
                                      color:
                                          state.cartContent?.hasDelivery ??
                                              false
                                          ? Colors.grey.shade100
                                          : (orderWay == "delivery")
                                          ? const Color(0xFFFFF4EF)
                                          : Colors.white,
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(
                                        color:
                                            state.cartContent?.hasDelivery ??
                                                false
                                            ? Colors.grey.shade300
                                            : (orderWay == "delivery")
                                            ? const Color(0xFFFF6B35)
                                            : Colors.grey.shade300,
                                        width:
                                            (state.cartContent?.hasDelivery ??
                                                true && orderWay == "delivery")
                                            ? 1.8
                                            : 1,
                                      ),
                                    ),
                                    padding: const EdgeInsets.all(10),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 50,
                                          height: 50,
                                          decoration: BoxDecoration(
                                            color:
                                                state
                                                        .cartContent
                                                        ?.hasDelivery ??
                                                    false
                                                ? const Color(0xFFFF6B35)
                                                : Colors.grey,
                                            borderRadius: BorderRadius.circular(
                                              14,
                                            ),
                                          ),
                                          child: const Icon(
                                            Icons.local_shipping_outlined,
                                            color: Colors.white,
                                            size: 28,
                                          ),
                                        ),

                                        const SizedBox(width: 14),

                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "التوصيل للمنزل",
                                                style: TextStyle(
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.w700,
                                                  color:
                                                      state
                                                              .cartContent
                                                              ?.hasDelivery ??
                                                          false
                                                      ? Colors.black
                                                      : Colors.grey,
                                                ),
                                              ),

                                              const SizedBox(height: 4),

                                              Text(
                                                state
                                                            .cartContent
                                                            ?.hasDelivery ??
                                                        false
                                                    ? "سيتم توصيل الطلب إلى عنوانك"
                                                    : "غير متوفر لهذا المطعم",
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),

                                        if (state.cartContent?.hasDelivery ??
                                            true && orderWay == "delivery")
                                          Container(
                                            width: 32,
                                            height: 32,
                                            decoration: const BoxDecoration(
                                              color: Color(0xFFFF6B35),
                                              shape: BoxShape.circle,
                                            ),
                                            child: const Icon(
                                              Icons.check,
                                              color: Colors.white,
                                              size: 20,
                                            ),
                                          ),

                                        if (!(state.cartContent?.hasDelivery ??
                                            false))
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 10,
                                              vertical: 5,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.grey.shade300,
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            child: const Text(
                                              "غير متاح",
                                              style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),
                    // طريقة الدفع
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          const Row(
                            children: [
                              FaIcon(
                                FontAwesomeIcons.wallet,
                                size: 20,
                                color: Color(0xFFFF6B35),
                              ),
                              SizedBox(width: 6),
                              Text(
                                "طريقة الدفع:",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 12),

                          InkWell(
                            onTap: () {
                              setState(() {
                                payWay = "cash";
                              });
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              decoration: BoxDecoration(
                                color: (payWay == "cash")
                                    ? const Color(0xFFFFF4EF)
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: (payWay == "cash")
                                      ? const Color(0xFFFF6B35)
                                      : Colors.grey.shade300,
                                  width: (payWay == "cash") ? 1.8 : 1,
                                ),
                              ),
                              padding: const EdgeInsets.all(10),
                              child: Row(
                                children: [
                                  Container(
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFFF6B35),
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    child: const Center(
                                      child: FaIcon(
                                        FontAwesomeIcons.moneyBillTransfer,
                                        size: 28,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),

                                  const SizedBox(width: 14),

                                  const Expanded(
                                    child: Text(
                                      "الدفع نقداً",
                                      style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),

                                  if (payWay == "cash")
                                    Container(
                                      width: 32,
                                      height: 32,
                                      decoration: const BoxDecoration(
                                        color: Color(0xFFFF6B35),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.check,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          InkWell(
                            onTap: isShamAvailable
                                ? () {
                                    setState(() {
                                      payWay = "shamCash";
                                    });
                                  }
                                : null,
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              decoration: BoxDecoration(
                                color: !isShamAvailable
                                    ? Colors.grey.shade100
                                    : (payWay == "shamCash")
                                    ? const Color(0xFFFFF4EF)
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: !isShamAvailable
                                      ? Colors.grey.shade300
                                      : (payWay == "shamCash")
                                      ? const Color(0xFFFF6B35)
                                      : Colors.grey.shade300,
                                  width:
                                      (isShamAvailable && payWay == "shamCash")
                                      ? 1.8
                                      : 1,
                                ),
                              ),
                              padding: const EdgeInsets.all(10),
                              child: Row(
                                children: [
                                  Container(
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: !isShamAvailable
                                          ? Colors.grey
                                          : const Color(0xFFFF6B35),
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    child: Image.network(
                                      "https://upload.wikimedia.org/wikipedia/commons/6/6f/Image_of_the_Sham_Cash_app_in_Syria_2026.jpg",
                                      width: 45,
                                      height: 45,
                                    ),
                                  ),

                                  const SizedBox(width: 14),

                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "الدفع شام كاش",
                                          style: TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.w700,
                                            color: isShamAvailable
                                                ? Colors.black
                                                : Colors.grey,
                                          ),
                                        ),
                                        if (!isShamAvailable)
                                          const Text(
                                            "غير متاح بدون عنوان أو طلب",
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey,
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),

                                  if (isShamAvailable && payWay == "shamCash")
                                    Container(
                                      width: 32,
                                      height: 32,
                                      decoration: const BoxDecoration(
                                        color: Color(0xFFFF6B35),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.check,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                    ),

                                  if (!isShamAvailable)
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 5,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade300,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: const Text(
                                        "غير متاح",
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
