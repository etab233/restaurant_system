import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive/hive.dart';
import 'package:restaurants_system/providers/cart_provider.dart';
import 'package:restaurants_system/view/cart/sham_cach_payment.dart';

class Order extends ConsumerStatefulWidget {
  const Order({super.key});
  @override
  ConsumerState<Order> createState() => OrderState();
}

class OrderState extends ConsumerState<Order> {
  String? location;
  late TextEditingController locationController;
  int orderWay = 0;
  int payWay = 0;
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
    location = Hive.box("locationBox").get("location_text");
    locationController = TextEditingController(text: shortAddress(location));
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(cartProvider);
    bool isShamAvailable =
        state.cartContent?.shamCachAccountBarcode != null ||
        state.cartContent?.shamCachAccountId != null;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: Text("Place Order"),
        centerTitle: true,
        shape: Border(
          bottom: BorderSide(color: Colors.grey.shade300, width: 1),
        ),
        backgroundColor: const Color(0xFFF5F5F5),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.chevron_left_outlined, size: 30),
        ),
        actions: [
          Padding(
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
              onPressed: () {
                if (!_formKey.currentState!.validate()) {
                  return;
                }
                if (orderWay == 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      margin: EdgeInsets.all(10),
                      behavior: SnackBarBehavior.floating,
                      content: Text('يرجى اختيار طريقة استلام الطلب'),
                    ),
                  );
                  return;
                }

                if (payWay == 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      behavior: SnackBarBehavior.floating,
                      margin: EdgeInsets.all(10),content: Text('يرجى اختيار طريقة الدفع')),
                  );
                  return;
                }
                (payWay == 2)
                    ? {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => ShamCashPayment()),
                        ),
                      }
                    : () {};
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Color(0xFFFF6B35),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    (payWay != 2) ? "Confirm order" : "Continue to pay",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(width: 8),
                  (payWay != 2)
                      ? const Icon(Icons.shopping_cart_checkout, size: 25)
                      : FaIcon(
                          FontAwesomeIcons.moneyCheckDollar,
                          size: 20,
                          color: Colors.white,
                        ),
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
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    // حقل الموقع
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.location_on_outlined,
                                size: 22,
                                color: Color(0xFFFF6B35),
                              ),
                              const SizedBox(width: 6),
                              const Text(
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
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.local_shipping_outlined,
                                size: 22,
                                color: Color(0xFFFF6B35),
                              ),
                              const SizedBox(width: 6),
                              const Text(
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
                                      orderWay = 1;
                                    });
                                  },
                                  child: AnimatedContainer(
                                    duration: Duration(milliseconds: 200),
                                    decoration: BoxDecoration(
                                      color: (orderWay == 1)
                                          ? Color(0xFFFFF4EF)
                                          : Colors.white,
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(
                                        color: (orderWay == 1)
                                            ? Color(0xFFFF6B35)
                                            : Colors.grey.shade300,
                                        width: (orderWay == 1) ? 1.8 : 1,
                                      ),
                                    ),
                                    padding: EdgeInsets.all(10),
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

                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: const [
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

                                        if (orderWay == 1)
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
                                            orderWay = 2;
                                          });
                                        }
                                      : null,
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    decoration: BoxDecoration(
                                      color: state.cartContent!.hasDelivery
                                          ? Colors.grey.shade100
                                          : (orderWay == 2)
                                          ? const Color(0xFFFFF4EF)
                                          : Colors.white,
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(
                                        color: state.cartContent!.hasDelivery
                                            ? Colors.grey.shade300
                                            : (orderWay == 2)
                                            ? const Color(0xFFFF6B35)
                                            : Colors.grey.shade300,
                                        width:
                                            (state.cartContent!.hasDelivery &&
                                                orderWay == 2)
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
                                                state.cartContent!.hasDelivery
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
                                                          .cartContent!
                                                          .hasDelivery
                                                      ? Colors.black
                                                      : Colors.grey,
                                                ),
                                              ),

                                              const SizedBox(height: 4),

                                              Text(
                                                state.cartContent!.hasDelivery
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

                                        if (state.cartContent!.hasDelivery &&
                                            orderWay == 2)
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

                                        if (!state.cartContent!.hasDelivery)
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
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              const FaIcon(
                                FontAwesomeIcons.wallet,
                                size: 20,
                                color: Color(0xFFFF6B35),
                              ),
                              const SizedBox(width: 6),
                              const Text(
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
                                payWay = 1;
                              });
                            },
                            child: AnimatedContainer(
                              duration: Duration(milliseconds: 200),
                              decoration: BoxDecoration(
                                color: (payWay == 1)
                                    ? Color(0xFFFFF4EF)
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: (payWay == 1)
                                      ? Color(0xFFFF6B35)
                                      : Colors.grey.shade300,
                                  width: (payWay == 1) ? 1.8 : 1,
                                ),
                              ),
                              padding: EdgeInsets.all(10),
                              child: Row(
                                children: [
                                  Container(
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFFF6B35),
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    child: Center(
                                      child: FaIcon(
                                        FontAwesomeIcons.moneyBillTransfer,
                                        size: 28,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),

                                  const SizedBox(width: 14),

                                  Expanded(
                                    child: Text(
                                      "الدفع نقداً",
                                      style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),

                                  if (payWay == 1)
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
                                      payWay = 2;
                                    });
                                  }
                                : null,
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              decoration: BoxDecoration(
                                color: !isShamAvailable
                                    ? Colors.grey.shade100
                                    : (payWay == 2)
                                    ? const Color(0xFFFFF4EF)
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: !isShamAvailable
                                      ? Colors.grey.shade300
                                      : (payWay == 2)
                                      ? const Color(0xFFFF6B35)
                                      : Colors.grey.shade300,
                                  width: (isShamAvailable && payWay == 2)
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
                                          "الدفع كام كاش",
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

                                  if (isShamAvailable && payWay == 2)
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
