import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:restaurants_system/constants.dart';

class AnalyzeMealRemoteDataSource {
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
    Map<String, dynamic> data = {};

    try {
      data = json.decode(res.body);
    } catch (e) {
      return {"error": "Invalid server response"};
    }

    if (streamed.statusCode != 200) {
      return {"error": data["message"] ?? "Server error (${streamed.statusCode})"};
    }

    return data.containsKey('data') ? data['data'] : data;
  }
}