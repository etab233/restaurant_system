import 'package:http/http.dart' as http;
import 'package:restaurants_system/constants.dart';

class HomeRemoteDataSource {
  Future<http.Response> getHomeData({String? lat, String? lng}) async {
    final url = Uri.parse("${Constants.baseUrl}/home").replace(
      queryParameters: {
        if (lat != null) 'latitude': lat.toString(),
        if (lng != null) 'longitude': lng.toString(),
      },
    );

    return http.get(
      url,
      headers: {"User-Agent": "restaurant_app", "Accept-Language": "ar"},
    );
  }
}
