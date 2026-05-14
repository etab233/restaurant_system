import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurants_system/services/api/health_profile_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HealthProfileState {
  final String? birthDate;
  final double heightCm;
  final double weightKg;
  final String gender;
  final String activityLevel;
  final String goal;

  const HealthProfileState({
    this.birthDate,
    this.gender = "",
    this.heightCm = 0.0,
    this.weightKg = 0.0,
    this.goal = "",
    this.activityLevel = "",
  });

  HealthProfileState copyWith({
    String? birthDate,
    double? heightCm,
    double? weightKg,
    String? gender,
    String? activityLevel,
    String? goal,
  }) {
    return HealthProfileState(
      birthDate: birthDate ?? this.birthDate,
      heightCm: heightCm ?? this.heightCm,
      weightKg: weightKg ?? this.weightKg,
      gender: gender ?? this.gender,
      goal: goal ?? this.goal,
      activityLevel: activityLevel ?? this.activityLevel,
    );
  }
}

class HealthProfileNotifier extends Notifier<HealthProfileState> {
  late final HealthProfileServices _healthProfileService;

  @override
  HealthProfileState build() {
    _healthProfileService = HealthProfileServices();
    return const HealthProfileState();
  }

  Future<bool> hasHealthAccount({required token}) async {
    try {
      final response = await _healthProfileService.hasHealthAccount(
        token: token,
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        state = state.copyWith(
          birthDate: data['data']['birth_date'],
          gender: data['data']['gender'],
          heightCm: double.parse(data['data']['height_cm'].toString()),
          weightKg: double.parse(data['data']['weight_kg'].toString()),
          activityLevel: data['data']['activity_level'],
          goal: data['data']['goal'],
        );
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  // نستدعيه لحفظ بياناته لما يسجل أول مرة
  Future<void> saveUserData({
    required String birthDate,
    required double heightCm,
    required double weightKg,
    required String gender,
    required String activityLevel,
    required String goal,
    required String token,
  }) async {
    try {
      final response = await _healthProfileService.saveUserData(
        gender: gender,
        birthDate: birthDate,
        heightCm: heightCm,
        weightKg: weightKg,
        activityLevel: activityLevel,
        goal: goal,
        token: token,
      );
      if (response.statusCode == 201 || response.statusCode == 200) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool("hasHealthAccount", true);

        state = state.copyWith(
          birthDate: birthDate,
          gender: gender,
          heightCm: heightCm,
          weightKg: weightKg,
          activityLevel: activityLevel,
          goal: goal,
        );
      } else {
        print("Error: ${response.body}");
      }
    } catch (e) {
      print(e);
    }
  }
}
