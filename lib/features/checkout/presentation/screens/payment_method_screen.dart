// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:latlong2/latlong.dart';
import 'package:restaurants_system/core/location/presentation/providers/location_picker_notifier.dart';
import 'package:restaurants_system/core/location/presentation/screens/location_picker_screen.dart';
import 'package:restaurants_system/features/cart/presentation/providers/cart_provider.dart';
import 'package:restaurants_system/features/cart/presentation/widgets/checkout_stepper.dart';
import 'package:restaurants_system/features/checkout/presentation/providers/checkout_provider.dart';
import 'package:restaurants_system/features/order_tracking/presentation/providers/order/order_provider.dart';
import 'package:restaurants_system/core/utils/input_decoration.dart';
import 'package:restaurants_system/features/checkout/presentation/screens/confirm_order.dart';

class PaymentMethodScreen extends ConsumerStatefulWidget {
  const PaymentMethodScreen({super.key});

  @override
  ConsumerState<PaymentMethodScreen> createState() =>
      _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends ConsumerState<PaymentMethodScreen> {
  String selectedMethod = 'cash';
  final TextEditingController _addressController = TextEditingController();
  final MapController _mapController = MapController();

  @override
  Widget build(BuildContext context) {
    final checkoutState = ref.watch(checkoutProvider);
    final cartState = ref.watch(cartNotifierProvider);
    final orderState = ref.watch(orderNotifierProvider);
    final locationState = ref.watch(locationPickerNotifierProvider);

    bool isShamAvailable = cartState.cartContent?.payByShamCach ?? false;

    if (_addressController.text != locationState.addressText) {
      _addressController.text = locationState.addressText;
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFFF5F5F5),
        foregroundColor: Colors.black87,
        centerTitle: true,
        title: const Text(
          "طريقة الدفع",
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
            onPressed: () {
              if (checkoutState.paymentMethod == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    behavior: SnackBarBehavior.floating,
                    margin: EdgeInsets.all(10),
                    content: Text('يرجى اختيار طريقة الدفع'),
                  ),
                );
                return;
              }

              final loc = ref
                  .read(locationPickerNotifierProvider)
                  .pickedLocation;
              ref
                  .read(checkoutProvider.notifier)
                  .setAddress(
                    address: _addressController.text,
                    latitude: loc.latitude,
                    longitude: loc.longitude,
                  );

              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ConfirmOrder()),
              );
            },
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
                        "Next",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 18,
                        color: Colors.white,
                      ),
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
                    const CheckoutStepper(currentStep: 1),
                    const SizedBox(height: 20),
                    Directionality(
                      textDirection: TextDirection.rtl,
                      child: Column(
                        children: [
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
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                InkWell(
                                  onTap: () {
                                    ref
                                        .read(checkoutProvider.notifier)
                                        .setPaymentMethod("cash");
                                  },
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    decoration: BoxDecoration(
                                      color:
                                          (checkoutState.paymentMethod ==
                                              'cash')
                                          ? const Color(0xFFFFF4EF)
                                          : Colors.white,
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(
                                        color:
                                            (checkoutState.paymentMethod ==
                                                'cash')
                                            ? const Color(0xFFFF6B35)
                                            : Colors.grey.shade300,
                                        width:
                                            (checkoutState.paymentMethod ==
                                                'cash')
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
                                            borderRadius: BorderRadius.circular(
                                              14,
                                            ),
                                          ),
                                          child: Center(
                                            child: Image.asset(
                                              "assets/images/cash.png",
                                              width: 45,
                                              height: 45,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 14),
                                        const Expanded(
                                          child: Text(
                                            "الدفع نقداً",
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ),
                                        if (checkoutState.paymentMethod ==
                                            'cash')
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
                                          ref
                                              .read(checkoutProvider.notifier)
                                              .setPaymentMethod("shamCash");
                                        }
                                      : null,
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    decoration: BoxDecoration(
                                      color: !isShamAvailable
                                          ? Colors.grey.shade100
                                          : (checkoutState.paymentMethod ==
                                                'shamCash')
                                          ? const Color(0xFFFFF4EF)
                                          : Colors.white,
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(
                                        color: !isShamAvailable
                                            ? Colors.grey.shade300
                                            : (checkoutState.paymentMethod ==
                                                  'shamCash')
                                            ? const Color(0xFFFF6B35)
                                            : Colors.grey.shade300,
                                        width:
                                            (isShamAvailable &&
                                                checkoutState.paymentMethod ==
                                                    'shamCash')
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
                                                : Colors.transparent,
                                            borderRadius: BorderRadius.circular(
                                              14,
                                            ),
                                          ),
                                          child: Image.asset(
                                            "assets/images/shamCash.png",
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
                                                  fontSize: 16,
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
                                        if (isShamAvailable &&
                                            checkoutState.paymentMethod ==
                                                'shamCash')
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
                          const SizedBox(height: 20),
                          if (checkoutState.deliveryType == "delivery")
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
                                      Icon(Icons.location_pin),
                                      SizedBox(width: 6),
                                      Text(
                                        "تحديد العنوان:",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  TextFormField(
                                    controller: _addressController,
                                    validator: (v) => v!.isEmpty
                                        ? "Address is required"
                                        : null,
                                    onFieldSubmitted: (v) async {
                                      await ref
                                          .read(
                                            locationPickerNotifierProvider
                                                .notifier,
                                          )
                                          .searchAddress(v);
                                      final loc = ref
                                          .read(locationPickerNotifierProvider)
                                          .pickedLocation;
                                      _mapController.move(loc, 15);
                                    },
                                    decoration: fieldDecoration(
                                      "Address",
                                      Icons.location_on_rounded,
                                      suffix: GestureDetector(
                                        onTap: () async {
                                          await ref
                                              .read(
                                                locationPickerNotifierProvider
                                                    .notifier,
                                              )
                                              .useCurrentLocation();
                                          final loc = ref
                                              .read(
                                                locationPickerNotifierProvider,
                                              )
                                              .pickedLocation;
                                          _mapController.move(loc, 15);
                                        },
                                        child: Container(
                                          margin: const EdgeInsets.all(8),
                                          width: 32,
                                          height: 32,
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFFF6B35),
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                          ),
                                          child: const Icon(
                                            Icons.my_location_rounded,
                                            color: Colors.white,
                                            size: 16,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  const Text(
                                    "Or pin directly on map:",
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Stack(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(16),
                                        child: SizedBox(
                                          height: 200,
                                          child: FlutterMap(
                                            mapController: _mapController,
                                            options: MapOptions(
                                              initialCenter: const LatLng(
                                                35.5317,
                                                35.7903,
                                              ),
                                              initialZoom: 12,
                                              minZoom: 1,
                                              maxZoom: 18,
                                              onTap: (_, latlng) {
                                                ref
                                                    .read(
                                                      locationPickerNotifierProvider
                                                          .notifier,
                                                    )
                                                    .pickLocationOnMap(latlng);
                                              },
                                            ),
                                            children: [
                                              TileLayer(
                                                urlTemplate:
                                                    "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                                                userAgentPackageName:
                                                    "com.example.restaurants_system",
                                              ),
                                              MarkerLayer(
                                                markers: [
                                                  Marker(
                                                    point: locationState
                                                        .pickedLocation,
                                                    child: const Icon(
                                                      Icons.location_on,
                                                      color: Color(0xFFFF6B35),
                                                      size: 40,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        bottom: 10,
                                        right: 10,
                                        child: GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (_) =>
                                                    const LocationPickerScreen(),
                                              ),
                                            );
                                          },
                                          child: Container(
                                            width: 36,
                                            height: 36,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black
                                                      .withOpacity(0.15),
                                                  blurRadius: 8,
                                                ),
                                              ],
                                            ),
                                            child: const Icon(
                                              Icons.open_in_full_rounded,
                                              size: 18,
                                              color: Colors.black87,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
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
