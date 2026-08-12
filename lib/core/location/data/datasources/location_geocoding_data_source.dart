import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

class LocationGeocodingDataSource {
  Future<http.Response> reverseGeocode(LatLng location) {
    final url = Uri.parse(
      "https://nominatim.openstreetmap.org/reverse?lat=${location.latitude}&lon=${location.longitude}&format=json",
    );
    return http.get(url, headers: _headers);
  }

  Future<http.Response> search(String query) {
    final url = Uri.https("nominatim.openstreetmap.org", "/search", {
      "q": query,
      "format": "json",
      "limit": "5",
      "accept-language": "ar",
      "countrycodes": "sy",
    });
    return http.get(url, headers: _headers);
  }

  Map<String, String> get _headers => {
    "User-Agent": "restaurant_app",
    "Accept-Language": "ar",
  };
}