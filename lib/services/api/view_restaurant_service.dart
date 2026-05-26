import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:restaurants_system/constants.dart';

class ViewRestaurantService {
  Future<http.Response> viewRestaurant(int restaurantId) async {
    final box = Hive.box("locationBox");
    final double? lat = box.get("latitude");
    final double? lng = box.get("longitude");

    // ignore: unused_local_variable
    Uri uri;
    // إذا الموقع موجود
    if (lat != null && lng != null) {
      uri = Uri.parse("${Constants.baseUrl}/restaurants/$restaurantId/menu")
          .replace(
            queryParameters: {
              "latitude": lat.toString(),
              "longitude": lng.toString(),
            },
          );
    } else {
      // بدون موقع
      uri = Uri.parse("${Constants.baseUrl}/restaurants/$restaurantId/menu");
    }

    http.Response response = await http.get(
      uri,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    );

    return response;
  }
}

final viewRestaurantProvider = Provider<ViewRestaurantService>((ref) {
  return ViewRestaurantService();
});
