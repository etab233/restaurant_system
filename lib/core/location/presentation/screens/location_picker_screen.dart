import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/location_picker_notifier.dart';

class LocationPickerScreen extends ConsumerStatefulWidget {
  const LocationPickerScreen({super.key});

  @override
  ConsumerState<LocationPickerScreen> createState() => _LocationPickerScreenState();
}

class _LocationPickerScreenState extends ConsumerState<LocationPickerScreen> {
  final _mapController = MapController();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final state = ref.watch(locationPickerNotifierProvider);
    final notifier = ref.read(locationPickerNotifierProvider.notifier);

    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: state.pickedLocation,
              initialZoom: 15,
              onTap: (tapPosition, latlng) {
                _mapController.move(latlng, _mapController.camera.zoom);
                notifier.pickLocationOnMap(latlng);
              },
            ),
            children: [
              TileLayer(
                urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                userAgentPackageName: 'com.example.restaurants_system',
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    point: state.pickedLocation,
                    width: 40,
                    height: 40,
                    child: const Icon(Icons.location_on, color: Colors.red, size: 40),
                  ),
                ],
              ),
            ],
          ),
          Positioned(
            top: MediaQuery.of(context).padding.top + 5,
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
          Positioned(
            right: 15,
            bottom: 200,
            child: Column(
              children: [
                FloatingActionButton.small(
                  heroTag: "MyLocation",
                  backgroundColor: Colors.white,
                  onPressed: () async {
                    await notifier.useCurrentLocation();
                    if (!context.mounted) return;
                    _mapController.move(
                      ref.read(locationPickerNotifierProvider).pickedLocation,
                      15,
                    );
                  },
                  child: const Icon(Icons.my_location_rounded, color: Colors.red),
                ),
                const SizedBox(height: 10),
                FloatingActionButton.small(
                  heroTag: "ZoomIn",
                  backgroundColor: Colors.white,
                  onPressed: () {
                    final zoom = _mapController.camera.zoom;
                    _mapController.move(_mapController.camera.center, zoom + 1);
                  },
                  child: Icon(Icons.add, color: colors.onSurface),
                ),
                const SizedBox(height: 10),
                FloatingActionButton.small(
                  heroTag: "ZoomOut",
                  backgroundColor: Colors.white,
                  onPressed: () {
                    final zoom = _mapController.camera.zoom;
                    _mapController.move(_mapController.camera.center, zoom - 1);
                  },
                  child: Icon(Icons.remove, color: colors.onSurface),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: state.addressLoading ? null : () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF6B35),
                  foregroundColor: Colors.white,
                  elevation: 10,
                  padding: const EdgeInsets.all(15),
                ),
                child: const Text(
                  "Confirm Location",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}