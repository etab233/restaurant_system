import 'package:http/http.dart' as http;
import 'package:restaurants_system/constants.dart';

class RestaurantByCategoryRemoteDataSource {
  Future<http.Response> fetchRestaurantsByCategory(int categoryId) {
    return http.get(
      Uri.parse("${Constants.baseUrl}/categories/$categoryId/restaurants"),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    );
  }
}
