import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:restaurants_system/constants.dart';

class MapScreen extends StatefulWidget {
  final LatLng initialLocation;
  const MapScreen({super.key, required this.initialLocation});
  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final _mapController = MapController(); // dispose لا يحتاج
  late LatLng pickedLocation;
  @override
  void initState() {
    super.initState();
    pickedLocation =
        widget.initialLocation; // القيمة التي مررناها للصفحة عند الإنشاء
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Select location")),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: pickedLocation,
              initialZoom: 15,
              onTap: (tapPosition, latlng) {
                setState(() {
                  pickedLocation = latlng;
                });
                _mapController.move(pickedLocation, 15);
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
                    point: pickedLocation,
                    child: Icon(Icons.location_on, color: Colors.red, size: 40),
                  ),
                ],
              ),
            ],
          ),
          //  أزرار الزوم
          Positioned(
            right: 15,
            bottom: 100,
            child: Column(
              children: [
                FloatingActionButton.small(
                  backgroundColor: Colors.white,
                  onPressed: () {
                    final currentZoom =
                        _mapController.camera.zoom; // مركز الخريطة
                    final center = _mapController.camera.center; // مركز الخريطة

                    _mapController.move(center, currentZoom + 1);
                  },
                  child: Icon(Icons.add),
                ),
                SizedBox(height: 10),
                FloatingActionButton.small(
                  backgroundColor: Colors.white,
                  onPressed: () {
                    final currentZoom = _mapController.camera.zoom;
                    final center = _mapController.camera.center;

                    _mapController.move(center, currentZoom - 1);
                  },
                  child: Icon(Icons.remove),
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
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context, pickedLocation),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(Constants.orangeColor),
                  foregroundColor: Colors.black,
                  elevation: 10,
                  padding: EdgeInsets.all(15),
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
