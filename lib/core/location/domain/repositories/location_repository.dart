import 'package:latlong2/latlong.dart';
import '../../data/datasources/location_local_data_source.dart';

abstract class LocationRepository {
  Future<LocationResult> getCurrentLocation();
  Future<GeocodeResult> reverseGeocode(LatLng location);
  Future<SearchResult> searchAddress(String query);
  Future<void> cacheLocation({
    required double lat,
    required double lng,
    required String address,
  });
  CachedLocation? getCachedLocation();
}

class LocationResult {
  final bool isSuccess;
  final double? lat;
  final double? lng;
  final String message;

  LocationResult.success({required this.lat, required this.lng})
      : isSuccess = true,
        message = "true";

  LocationResult.failure(this.message)
      : isSuccess = false,
        lat = null,
        lng = null;
}

class GeocodeResult {
  final bool isSuccess;
  final String? address;
  final String message;

  GeocodeResult.success(this.address) : isSuccess = true, message = '';
  GeocodeResult.failure(this.message) : isSuccess = false, address = null;
}

class SearchResult {
  final bool isSuccess;
  final bool isNetworkError;
  final double? lat;
  final double? lon;

  SearchResult.success({required this.lat, required this.lon})
      : isSuccess = true,
        isNetworkError = false;

  SearchResult.failure({this.isNetworkError = false})
      : isSuccess = false,
        lat = null,
        lon = null;
}