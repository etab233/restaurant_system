import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:restaurants_system/services/api/location_services.dart';
import 'package:geolocator/geolocator.dart';

class LocationState {
  final double lat;
  final double lng;
  final String message;

  LatLng get userLocation => LatLng(lat, lng);

  LocationState({required this.lat, required this.lng, required this.message});

  LocationState copyWith({double? lat, double? lng, String? message}) {
    return LocationState(lat: lat ?? this.lat, lng: lng ?? this.lng, message: message?? this.message);
  }
}

class LocationNotifier extends Notifier<LocationState> {
  late LocationServices _locationServices;
  @override
  LocationState build(){
    _locationServices = LocationServices();
    return LocationState(lat: 35.5317, lng: 35.7900, message: "");
  }

  Future<void> getCurrentLocation() async {
    state = state.copyWith(lat: 35.5317, lng:35.7900);
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        state = state.copyWith(message: "Location service disabled");
        return;
      }
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied ||
            permission == LocationPermission.deniedForever) {
          state = state.copyWith(message: "Location permission denied");
          return;
        }
      }

      final position = await Geolocator.getCurrentPosition();
      state = state.copyWith(lat : position.latitude, lng: position.longitude, message: "true");

    } catch (e) {
      state = state.copyWith(message: "location error");
    }
  }
}