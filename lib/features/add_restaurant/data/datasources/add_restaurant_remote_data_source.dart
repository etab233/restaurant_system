import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:restaurants_system/constants.dart';

class AddRestaurantRemoteDataSource {
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
    return http.post(
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
        'categories': categories,
        'latitude': latitude,
        'longitude': longitude,
      }),
    );
  }

  Future<http.Response> fetchCategories() async {
    final url = Uri.parse("${Constants.baseUrl}/restaurant-categories");
    return http.get(url);
  }
}