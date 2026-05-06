import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:restaurants_system/constants.dart';
import 'package:restaurants_system/models/food_item.dart';

class AnalyzeMealServices {
  Future<FoodItem> analyze({
    required String imagePath,
    required String token,
  }) async {
    final url = Uri.parse("${Constants.baseUrl}/scan/meal");
    final req = http.MultipartRequest('POST', url);

    req.headers.addAll({
      "Authorization": "Bearer $token",
      "Accept": "application/json",
    });

    req.files.add(await http.MultipartFile.fromPath('image', imagePath));

    final streamed = await req.send();
    final res = await http.Response.fromStream(streamed);

    if (res.statusCode == 200) {
      final data = json.decode(res.body);
      return FoodItem.fromJson(data['data']);
    }
    print(res.statusCode);
    throw Exception('Analysis failed: ${res.statusCode}');
  }
}
