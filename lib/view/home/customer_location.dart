// ignore_for_file: use_build_context_synchronously

import 'package:flutter_map/flutter_map.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:latlong2/latlong.dart';
import 'package:restaurants_system/providers/restaurant_request_provider.dart';

class CustomerLocation extends ConsumerStatefulWidget {
  const CustomerLocation({super.key});
  @override
  ConsumerState<CustomerLocation> createState() => _CustomerLocationState();
}

class _CustomerLocationState extends ConsumerState<CustomerLocation> {

  final _mapController = MapController();
  LatLng pickedLocation = LatLng(35.5317, 35.7917);
  String addressText = 'Move the map to select location';
  bool addressLoading = false;
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: LatLng(35.5317, 35.7917),
              initialZoom: 13,
              
              onTap: (tapPosition, latlng) async {
                setState(() {
                  pickedLocation = latlng;
                  addressLoading = true;
                });
                _mapController.move(pickedLocation, _mapController.camera.zoom);

                final notifier = ref.read(restaurantRequestProvider.notifier);

                await notifier.updateAddressFromMap(latlng);
                setState(() {
                  addressText = ref
                      .read(restaurantRequestProvider)
                      .addressField;
                  addressLoading = false;
                });
              },
            ),
            children: [
              TileLayer(
                // طبقة عرض الخريطة
                urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                userAgentPackageName: 'com.example.restaurants_system',
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    point: pickedLocation,
                    width: 40,
                    height: 40,
                    child: Icon(Icons.location_on, color: Colors.red, size: 30),
                  ),
                ],
              ),
            ],
          ),
          // زر الرجوع
          Positioned(
            top: MediaQuery.of(context).padding.top + 25,
            left: 15,
            child: SafeArea(
              child: CircleAvatar(
                backgroundColor: Colors.grey,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),
          ),
          //  أزرار الزوم
          Positioned(
            right: 15,
            bottom: 200,
            child: Column(
              children: [
                // اختيار الموقع الحالي
                FloatingActionButton.small(
                  heroTag: "MyLocation",
                  backgroundColor: Colors.white,
                  onPressed: () async {
                    await ref
                        .read(restaurantRequestProvider.notifier)
                        .getCurrentLocation();

                    final state = ref.read(restaurantRequestProvider);
                    final latlng = LatLng(
                      state.pickedLocation.latitude,
                      state.pickedLocation.longitude,
                    );
                    setState(() => pickedLocation = latlng);
                    _mapController.move(latlng, 15);
                    setState(() {
                      addressText = state.addressField;
                      addressLoading = false;
                    });
                  },
                  child: const Icon(
                    Icons.my_location_rounded,
                    color: Colors.red,
                  ),
                ),

                SizedBox(height: 10),
                FloatingActionButton.small(
                  heroTag: "ZoonIn",
                  backgroundColor: Colors.white,
                  onPressed: () {
                    final currentZoom =
                        _mapController.camera.zoom; // مركز الخريطة
                    final center = _mapController.camera.center; // مركز الخريطة

                    _mapController.move(center, currentZoom + 1);
                  },
                  child: Icon(Icons.add, color: colors.onSurface),
                ),

                SizedBox(height: 10),
                FloatingActionButton.small(
                  heroTag: "ZoomOut",
                  backgroundColor: Colors.white,
                  onPressed: () {
                    final currentZoom = _mapController.camera.zoom;
                    final center = _mapController.camera.center;

                    _mapController.move(center, currentZoom - 1);
                  },
                  child: Icon(Icons.remove, color: colors.onSurface),
                ),
              ],
            ),
          ),
          //____save location button_________________
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 32),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 16,
                    offset: Offset(0, -4),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // handle
                  Container(
                    width: 36,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 14),

                  // عرض العنوان بالأسفل
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF0EB),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.location_on_rounded,
                          color: Color(0xFFFF6B35),
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: addressLoading
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    height: 10,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Container(
                                    height: 10,
                                    width: 140,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),
                                ],
                              )
                            : Text(
                                addressText,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  // زر التأكيد
                  SizedBox(
                    width: double.infinity,
                    height: 40,
                    child: ElevatedButton(
                      onPressed: addressLoading
                          ? null
                          : () async {
                              
                              // حفظ الموقع ك lat, lng 
                              final box = Hive.box('locationBox');
                              await box.put("latitude", pickedLocation.latitude);
                              await box.put("longitude", pickedLocation.longitude);
                              await box.put("location_text", addressText);


                              Navigator.pop(context, {
                                "lat": pickedLocation.latitude,
                                "lng": pickedLocation.longitude,
                                "address": addressText,
                              });
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF6B35),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        "Deliver here",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
