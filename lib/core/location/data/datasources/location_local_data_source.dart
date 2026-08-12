import 'package:hive/hive.dart';

class LocationLocalDataSource {
  Box get _box => Hive.box('locationBox');

  Future<void> saveLocation({
    required double lat,
    required double lng,
    required String address,
  }) async {
    await _box.put("latitude", lat);
    await _box.put("longitude", lng);
    await _box.put("location_text", address);
  }

  CachedLocation? getCachedLocation() {
    final lat = _box.get("latitude");
    final lng = _box.get("longitude");
    if (lat == null || lng == null) return null;
    return CachedLocation(
      latitude: lat,
      longitude: lng,
      addressText: _box.get("location_text") ?? '',
    );
  }
}

class CachedLocation {
  final double latitude;
  final double longitude;
  final String addressText;

  CachedLocation({
    required this.latitude,
    required this.longitude,
    required this.addressText,
  });
}