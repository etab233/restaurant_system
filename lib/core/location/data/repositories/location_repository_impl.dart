import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import '../datasources/location_device_data_source.dart';
import '../datasources/location_geocoding_data_source.dart';
import '../datasources/location_local_data_source.dart';
import '../../domain/repositories/location_repository.dart';

class LocationRepositoryImpl implements LocationRepository {
  final LocationDeviceDataSource _device;
  final LocationGeocodingDataSource _geocoding;
  final LocationLocalDataSource _local;

  static const _noLocationError =
      "this address not found, please type it in the field above";

  LocationRepositoryImpl(this._device, this._geocoding, this._local);

  @override
  Future<LocationResult> getCurrentLocation() async {
    try {
      final serviceEnabled = await _device.isServiceEnabled();
      if (!serviceEnabled) {
        return LocationResult.failure("Location service disabled");
      }

      LocationPermission permission = await _device.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await _device.requestPermission();
        if (permission == LocationPermission.denied ||
            permission == LocationPermission.deniedForever) {
          return LocationResult.failure("Location permission denied");
        }
      }

      final position = await _device.getCurrentPosition();
      return LocationResult.success(
        lat: position.latitude,
        lng: position.longitude,
      );
    } catch (e) {
      return LocationResult.failure("location error: $e");
    }
  }

  @override
  Future<GeocodeResult> reverseGeocode(LatLng location) async {
    try {
      final response = await _geocoding.reverseGeocode(location);
      if (response.statusCode != 200) {
        return GeocodeResult.failure(_noLocationError);
      }

      final data = jsonDecode(response.body);
      if (data["display_name"] == null) {
        return GeocodeResult.failure(_noLocationError);
      }

      return GeocodeResult.success(data["display_name"]);
    } catch (e) {
      return GeocodeResult.failure(_noLocationError);
    }
  }

  @override
  Future<SearchResult> searchAddress(String query) async {
    try {
      final response = await _geocoding.search(query);
      if (response.statusCode != 200) return SearchResult.failure();

      final data = jsonDecode(response.body);
      if (data.isEmpty) return SearchResult.failure();

      final lat = double.parse(data[0]["lat"]);
      final lon = double.parse(data[0]["lon"]);
      return SearchResult.success(lat: lat, lon: lon);
    } catch (e) {
      // خطأ شبكة يوقف البحث فورًا، عكس "ما في نتيجة"
      return SearchResult.failure(isNetworkError: true);
    }
  }

  @override
  Future<void> cacheLocation({
    required double lat,
    required double lng,
    required String address,
  }) {
    return _local.saveLocation(lat: lat, lng: lng, address: address);
  }

  @override
  CachedLocation? getCachedLocation() => _local.getCachedLocation();
}
