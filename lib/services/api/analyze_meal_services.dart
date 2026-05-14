import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:restaurants_system/constants.dart';

class AnalyzeMealServices {
  Future<Map<String, dynamic>> analyze({
    required String imagePath,
    String? description,
    required String token,
  }) async {
    final url = Uri.parse("${Constants.baseUrl}/scan/meal");
    final req = http.MultipartRequest('POST', url);

    req.headers.addAll({
      "Authorization": "Bearer $token",
      "Accept": "application/json",
    });

    req.files.add(await http.MultipartFile.fromPath('image', imagePath));

    if (description != null && description.isNotEmpty) {
      req.fields['description'] = description;
    }

    final streamed = await req.send();
    final res = await http.Response.fromStream(streamed);

    if (res.statusCode == 200) {
      final data = json.decode(res.body);
      if (data.containsKey('data')) {
        return data['data'];
      } else {
        return data;
      }
    } else {
      throw Exception("Analysis failed: ${res.statusCode}\n${res.body}");
    }
  }
}
