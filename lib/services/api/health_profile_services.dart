import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:restaurants_system/constants.dart';

class HealthProfileServices {
  Future<http.Response> saveUserData({
    required String birthDate,
    required double heightCm,
    required double weightKg,
    required String gender,
    required String activityLevel,
    required String goal,
    required String token
  }) async {
    final url = Uri.parse("${Constants.baseUrl}/health-profile");
    return http.post(
      url,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({
        "birth_date": birthDate,
        "height_cm": heightCm,
        "weight_kg": weightKg,
        "gender": gender,
        "activity_level": activityLevel,
        "goal": goal,
      }),
    );
  }
}
