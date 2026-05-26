import 'package:http/http.dart' as http;
import 'package:restaurants_system/constants.dart';

class RestaurantByCategoryService {
  Future<http.Response> fetchRestaurantsByCategory(int categoryId) async {
    http.Response response = await http.get(
      Uri.parse("${Constants.baseUrl}/categories/$categoryId/restaurants"),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    );
    return response;
  }
}
