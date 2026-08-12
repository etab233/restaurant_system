import 'package:latlong2/latlong.dart';

class LocationState {
  final double lat;
  final double lng;
  final String message;

  LatLng get userLocation => LatLng(lat, lng);

  LocationState({required this.lat, required this.lng, required this.message});

  LocationState copyWith({double? lat, double? lng, String? message}) {
    return LocationState(
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
      message: message ?? this.message,
    );
  }
}