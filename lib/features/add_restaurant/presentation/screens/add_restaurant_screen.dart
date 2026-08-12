// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:restaurants_system/core/location/presentation/providers/location_picker_notifier.dart';
import 'package:restaurants_system/core/location/presentation/screens/location_picker_screen.dart';
import 'package:restaurants_system/features/add_restaurant/presentation/providers/add_restaurant_provider.dart';
import 'package:restaurants_system/core/utils/input_decoration.dart';
import 'package:restaurants_system/features/add_restaurant/presentation/screens/lock_screen.dart';
import 'package:restaurants_system/features/navigation/presentation/screens/main_screen.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

class AddRestaurant extends ConsumerStatefulWidget {
  const AddRestaurant({super.key});
  @override
  ConsumerState<AddRestaurant> createState() => _AddRestaurantState();
}

class _AddRestaurantState extends ConsumerState<AddRestaurant>
    with SingleTickerProviderStateMixin {
  // ── Constants ─────────────────────────────────────
  static const _orange = Color(0xFFFF6B35);
  static const _bg = Color(0xFFF5F4F0);

  // ── Controllers ───────────────────────────────────
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _addressController = TextEditingController();
  final _mapController = MapController();
  PhoneNumber _phoneNumber = PhoneNumber(isoCode: 'SY');
  List<int> selected = [];

  late AnimationController _animCtrl;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnim = CurvedAnimation(parent: _animCtrl, curve: Curves.easeOut);
    _animCtrl.forward();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadCategories();
    });
  }

  Future<void> _loadCategories() async {
    await ref.read(addRestaurantProvider.notifier).fetchCategories();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _phoneNumberController.dispose();
    _addressController.dispose();
    _mapController.dispose();
    _animCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(addRestaurantProvider);
    final locationState = ref.watch(locationPickerNotifierProvider);

    if (state.status == "unauthenticated") {
      return const LockScreen();
    }

    if (_addressController.text != locationState.addressText) {
      _addressController.text = locationState.addressText;
    }

    // رسائل خاصة بحالة الفورم (نجاح/فشل الإرسال)
    ref.listen(addRestaurantProvider, (prev, next) {
      if (prev?.message != next.message && next.message.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.message),
            behavior: SnackBarBehavior.floating,
            backgroundColor: _orange,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.all(16),
          ),
        );
      }
    });

    // رسائل خاصة بالموقع (فشل البحث، خدمة الموقع معطلة، إلخ)
    ref.listen(locationPickerNotifierProvider, (prev, next) {
      if (prev?.message != next.message && next.message.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.message),
            behavior: SnackBarBehavior.floating,
            backgroundColor: _orange,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.all(16),
          ),
        );
      }
    });

    return Scaffold(
      backgroundColor: _bg,
      body: FadeTransition(
        opacity: _fadeAnim,
        child: CustomScrollView(
          slivers: [
            // ── SliverAppBar ─────────────────────────────
            SliverAppBar(
              expandedHeight: 150,
              pinned: true,
              backgroundColor: Colors.white,
              elevation: 0,
              leading: IconButton(
                onPressed: () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) =>const MainScreen()),
                ),
                icon: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: _bg,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    size: 16,
                    color: Colors.black87,
                  ),
                ),
              ),
              title: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Restaurant Request",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: Colors.black87,
                    ),
                  ),
                  Text(
                    "Fill in your restaurant details",
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFF1A1A2E), Color(0xFF2D1810), _orange],
                    ),
                  ),
                  child: Stack(
                    children: [
                      const Positioned(
                        right: -10,
                        top: -10,
                        child: Opacity(
                          opacity: 0.08,
                          child: Icon(
                            Icons.restaurant_rounded,
                            size: 90,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 60, 16, 16),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: _orange.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: _orange.withOpacity(0.4),
                                ),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.rocket_launch_rounded,
                                    size: 12,
                                    color: _orange,
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    "Partner with us",
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                      color: _orange,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 6),
                            const Text(
                              "Register your restaurant\nand grow with us",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                                height: 1.3,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            SliverToBoxAdapter(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    // ── Steps Indicator ─────────────────
                    const _StepsIndicator(),
                    const SizedBox(height: 4),

                    // ── Basic Info Card ──────────────────
                    _SectionCard(
                      icon: Icons.storefront_rounded,
                      iconBg: const Color(0xFFFFF0EB),
                      iconColor: _orange,
                      title: "Basic Information",
                      subtitle: "Tell us about your restaurant",
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _nameController,
                            validator: (v) => v!.isEmpty
                                ? "Restaurant name is required"
                                : null,
                            decoration: fieldDecoration(
                              "Restaurant name",
                              Icons.storefront_rounded,
                            ),
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: _descriptionController,
                            validator: (v) =>
                                v!.isEmpty ? "Description is required" : null,
                            minLines: 2,
                            maxLines: 4,
                            decoration: fieldDecoration(
                              "Description",
                              Icons.notes_rounded,
                            ),
                          ),
                          const SizedBox(height: 12),
                          InternationalPhoneNumberInput(
                            initialValue: _phoneNumber,
                            textFieldController: _phoneNumberController,
                            onInputChanged: (n) => _phoneNumber = n,
                            selectorConfig: const SelectorConfig(
                              selectorType: PhoneInputSelectorType.DROPDOWN,
                              setSelectorButtonAsPrefixIcon: true,
                              showFlags: false,
                            ),
                            countries: const ['SY'],
                            keyboardType: TextInputType.phone,
                            maxLength: 11,
                            formatInput: true,
                            validator: (v) =>
                                v!.isEmpty ? "Phone is required" : null,
                            inputDecoration: fieldDecoration(
                              "Restaurant phone",
                              Icons.phone_rounded,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // ── Categories Card ──────────────────
                    _SectionCard(
                      icon: Icons.sell_rounded,
                      iconBg: const Color(0xFFE8F5E9),
                      iconColor: const Color(0xFF43A047),
                      title: "Categories",
                      subtitle: "Select all that apply",
                      child: MultiSelectDialogField(
                        listType: MultiSelectListType.LIST,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8F8F6),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: const Color(0xFFEFEFEF),
                            width: 1.5,
                          ),
                        ),
                        dialogHeight: (state.categories.length * 55.0) + 50,
                        buttonText: const Text(
                          "Select Categories",
                          style: TextStyle(color: Colors.grey, fontSize: 13),
                        ),
                        buttonIcon: const Icon(
                          Icons.tag_rounded,
                          color: Colors.grey,
                          size: 20,
                        ),
                        title: const Text(
                          "Categories",
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                        searchable: true,
                        itemsTextStyle: const TextStyle(fontSize: 13),
                        selectedItemsTextStyle: const TextStyle(
                          fontSize: 13,
                          color: _orange,
                          fontWeight: FontWeight.w600,
                        ),
                        checkColor: Colors.white,
                        selectedColor: _orange,
                        items: state.categories.map((e) {
                          return MultiSelectItem<int>(e.id, e.name);
                        }).toList(),
                        onConfirm: (vals) =>
                            setState(() => selected = List<int>.from(vals)),
                      ),
                    ),

                    // ── Location Card ────────────────────
                    _SectionCard(
                      icon: Icons.location_on_rounded,
                      iconBg: const Color(0xFFFFF3E0),
                      iconColor: const Color(0xFFFF9800),
                      title: "Restaurant Location",
                      subtitle: "Search or tap on map",
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextFormField(
                            controller: _addressController,
                            validator: (v) =>
                                v!.isEmpty ? "Address is required" : null,
                            onFieldSubmitted: (v) async {
                              await ref
                                  .read(locationPickerNotifierProvider.notifier)
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
                                        locationPickerNotifierProvider.notifier,
                                      )
                                      .useCurrentLocation();
                                  final loc = ref
                                      .read(locationPickerNotifierProvider)
                                      .pickedLocation;
                                  _mapController.move(loc, 15);
                                },
                                child: Container(
                                  margin: const EdgeInsets.all(8),
                                  width: 32,
                                  height: 32,
                                  decoration: BoxDecoration(
                                    color: _orange,
                                    borderRadius: BorderRadius.circular(10),
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

                          // Map
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
                                            point: locationState.pickedLocation,
                                            child: const Icon(
                                              Icons.location_on,
                                              color: _orange,
                                              size: 40,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              // Expand button
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
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.15),
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

                    // ── Submit ───────────────────────────
                    Padding(
                      padding: const EdgeInsets.fromLTRB(14, 14, 14, 30),
                      child: Column(
                        children: [
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () async {
                                if (!_formKey.currentState!.validate()) return;

                                final loc = ref
                                    .read(locationPickerNotifierProvider)
                                    .pickedLocation;

                                await ref
                                    .read(addRestaurantProvider.notifier)
                                    .sendRestaurantRequest(
                                      name: _nameController.text,
                                      description: _descriptionController.text,
                                      number: _phoneNumber.phoneNumber!,
                                      address: _addressController.text,
                                      latitude: loc.latitude,
                                      longitude: loc.longitude,
                                      categories: selected,
                                    );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _orange,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18),
                                ),
                                elevation: 0,
                                shadowColor: _orange.withOpacity(0.4),
                              ),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.send_rounded, size: 20),
                                  SizedBox(width: 8),
                                  Text(
                                    "Submit Request",
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            "Our team will review your request within 24–48 hours",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 11, color: Colors.grey),
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

// ── Reusable Section Card ─────────────────────────────────────
class _SectionCard extends StatelessWidget {
  final IconData icon;
  final String title, subtitle;
  final Color iconBg;
  final Color iconColor;
  final Widget child;

  const _SectionCard({
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(14, 0, 14, 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: iconBg,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(child: Icon(icon, size: 20, color: iconColor)),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(fontSize: 10, color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }
}

// ── Steps Indicator ───────────────────────────────────────────
class _StepsIndicator extends StatelessWidget {
  const _StepsIndicator();

  @override
  Widget build(BuildContext context) {
    const orange = Color(0xFFFF6B35);
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 16),
      child: Row(
        children: [
          _step(Icons.check_rounded, "Basic Info", true, false, orange),
          _line(true, orange),
          _step(null, "Location", true, true, orange, number: "2"),
          _line(false, orange),
          _step(null, "Submit", false, false, orange, number: "3"),
        ],
      ),
    );
  }

  Widget _step(
    IconData? icon,
    String label,
    bool done,
    bool active,
    Color orange, {
    String? number,
  }) {
    return Column(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: (done || active) ? orange : const Color(0xFFE8E8E8),
          ),
          child: Center(
            child: icon != null
                ? Icon(icon, size: 15, color: Colors.white)
                : Text(
                    number ?? '',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: (done || active) ? Colors.white : Colors.grey,
                    ),
                  ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.w600,
            color: (done || active) ? orange : Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _line(bool done, Color orange) => Expanded(
    child: Container(
      height: 2,
      margin: const EdgeInsets.only(bottom: 14),
      color: done ? orange : const Color(0xFFE8E8E8),
    ),
  );
}
