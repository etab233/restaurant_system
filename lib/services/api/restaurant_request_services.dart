import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../constants.dart';
import 'package:latlong2/latlong.dart';

class RestaurantRequestServices {
  Future<http.Response> sendRestaurantRequest({
    required String name,
    required String description,
    required String number,
    required String address,
    double? latitude,
    double? longitude,
    required List<int> categories,
    required String token,
  }) async {
    final url = Uri.parse("${Constants.baseUrl}/restaurant-request");
    return await http.post(
      url,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        "Authorization": "Bearer $token",
      },
      body: json.encode({
        'restaurant_name': name,
        'description': description,
        'restaurant_phone': number,
        'address': address,
        'categories' : categories,
        'latitude': latitude,
        'longitude': longitude
      }),
    );
  }

  Future<http.Response> updateAddressFromMap(LatLng location) async {
    final url = Uri.parse(
      "https://nominatim.openstreetmap.org/reverse?lat=${location.latitude}&lon=${location.longitude}&format=json",
    );
    return await http.get(
      url,
      headers: {"User-Agent": "restaurant_app", "Accept-Language": "ar"},
    );
  }

  Future<http.Response> searchAddress(String address) async {
    final query = address.trim();
    final url = Uri.https("nominatim.openstreetmap.org", "/search", {
      "q": query,
      "format": "json",
      "limit": "5",
      "accept-language": "ar",
      "countrycodes": "sy",
    });

    return await http.get(
      url,
      headers: {"User-Agent": "restaurant_app", "Accept-Language": "ar"},
    );
  }

  Future<http.Response> fetchCategories({required String token}) async{
    final url = Uri.parse("${Constants.baseUrl}/restaurant-categories");
    return await http.get(
      url,
      headers: {
        "Authorization": "Bearer $token",
      }
    );
  }
}
