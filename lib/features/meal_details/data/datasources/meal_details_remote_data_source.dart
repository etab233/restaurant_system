import 'package:http/http.dart' as http;
import 'package:restaurants_system/constants.dart';

class MealDetailsRemoteDataSource {
  Future<http.Response> getMealDetails({
    required int restaurantId,
    required int mealId,
  }) async {
    return http.get(
      Uri.parse("${Constants.baseUrl}/restaurants/$restaurantId/menu/$mealId"),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    );
  }

  Future<http.Response> getCartMealDetails({
    required int itemId,
    required String token,
  }) async {
    final url = Uri.parse("${Constants.baseUrl}/cart/restaurant/item/$itemId");
    return http.get(
      url,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        "Authorization": "Bearer $token",
      },
    );
  }

  Future<http.Response> getMealNutrition({
    required int restaurantId,
    required int mealItemId,
  }) async {
    final url = Uri.parse(
      "${Constants.baseUrl}/restaurants/$restaurantId/menu-items/$mealItemId/analysis",
    );
    return http.get(
      url,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    );
  }
}
