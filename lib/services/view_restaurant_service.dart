import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:restaurants_system/constants.dart';

class ViewRestaurantService {
  Future<http.Response> viewRestaurant(int restaurantId) async {
    http.Response response = await http.get(
      Uri.parse("${Constants.baseUrl}/restaurant/$restaurantId"),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json'
        // 'Authorization': 'Bearer $token'
        }
    );
    print(response.body);
    return response;
  }
}
final viewRestaurantProvider = Provider<ViewRestaurantService>((ref) {
  return ViewRestaurantService();
});