import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:restaurants_system/constants.dart';

class ViewRestaurantService {
  Future<http.Response> viewRestaurant(int restaurantId) async {
    http.Response response = await http.get(
      Uri.parse("${Constants.baseUrl}/restaurants/$restaurantId/menu"),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json'
        // 'Authorization': 'Bearer $token'
        }
    );
    return response;
  }
}
final viewRestaurantProvider = Provider<ViewRestaurantService>((ref) {
  return ViewRestaurantService();
});