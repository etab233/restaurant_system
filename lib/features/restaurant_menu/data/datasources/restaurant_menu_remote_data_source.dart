import 'package:http/http.dart' as http;
import 'package:restaurants_system/constants.dart';

class RestaurantMenuRemoteDataSource {
  Future<http.Response> viewRestaurant({
    required int restaurantId,
    double? latitude,
    double? longitude,
  }) async {
    final uri = (latitude != null && longitude != null)
        ? Uri.parse("${Constants.baseUrl}/restaurants/$restaurantId/menu").replace(
            queryParameters: {
              "latitude": latitude.toString(),
              "longitude": longitude.toString(),
            },
          )
        : Uri.parse("${Constants.baseUrl}/restaurants/$restaurantId/menu");

    return http.get(
      uri,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    );
  }
}