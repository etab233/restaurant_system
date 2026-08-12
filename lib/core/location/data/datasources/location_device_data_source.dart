import 'package:geolocator/geolocator.dart';

class LocationDeviceDataSource {
  Future<bool> isServiceEnabled() => Geolocator.isLocationServiceEnabled();

  Future<LocationPermission> checkPermission() => Geolocator.checkPermission();

  Future<LocationPermission> requestPermission() => Geolocator.requestPermission();

  Future<Position> getCurrentPosition() => Geolocator.getCurrentPosition();
}