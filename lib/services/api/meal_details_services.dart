import 'package:http/http.dart' as http;
import 'package:restaurants_system/constants.dart';

class MealDetailsServices {
  Future<http.Response> getMealDetails({
    required int restaurantId,
    required mealId,
  }) async {
    return await http.get(
      Uri.parse("${Constants.baseUrl}/restaurants/$restaurantId/menu/$mealId"),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    );
  }
}
