import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurants_system/services/api/analyze_meal_services.dart';

enum Status { initial, loading, success, error }

class AnalyzeMealState {
  final String name;
  final String description;
  final double calories;
  final double protein;
  final double carbs;
  final double fat;
  final String confidence;
  final String message;
  final Status analyzeStatus;

  const AnalyzeMealState({
    this.name = "",
    this.description = "",
    this.calories = 0.0,
    this.protein = 0.0,
    this.carbs = 0.0,
    this.fat = 0.0,
    this.confidence = "",
    this.message = "",
    this.analyzeStatus = Status.initial,
  });

  AnalyzeMealState copyWith({
    String? name,
    String? description,
    double? calories,
    double? protein,
    double? carbs,
    double? fat,
    String? confidence,
    String? message,
    Status? analyzeStatus,
  }) {
    return AnalyzeMealState(
      name: name ?? this.name,
      description: description ?? this.description,
      calories: calories ?? this.calories,
      protein: protein ?? this.protein,
      carbs: carbs ?? this.carbs,
      fat: fat ?? this.fat,
      confidence: confidence ?? this.confidence,
      message: message ?? this.message,
      analyzeStatus: analyzeStatus ?? this.analyzeStatus,
    );
  }
}

class AnalyzeMealNotifier extends Notifier<AnalyzeMealState> {
  late final AnalyzeMealServices _analyzeMealServices;

  @override
  AnalyzeMealState build() {
    _analyzeMealServices = AnalyzeMealServices();
    return const AnalyzeMealState();
  }

  Future<void> analyze({
    required String imagePath,
    String? description,
    required String token,
  }) async {
    // reset state
    state = const AnalyzeMealState(analyzeStatus: Status.loading, message: "");
    try {
      final response = await _analyzeMealServices
          .analyze(imagePath: imagePath, token: token, description: description)
          .timeout(const Duration(seconds: 40));

      if (response.containsKey("error")) {
        state = state.copyWith(
          analyzeStatus: Status.error,
          message: response['error'],
        );
        return;
      } else {
        // تم المسح بنجاح
        state = state.copyWith(
          name: response["dish_name"],
          description: response["description"],
          calories: (response["calories"] as num).toDouble(),
          protein: (response["protein"] as num).toDouble(),
          carbs: (response["carbs"] as num).toDouble(),
          fat: (response["fat"] as num).toDouble(),
          confidence: response["confidence"],
          message: "Operation successful",
          analyzeStatus: Status.success,
        );
      }
    } on TimeoutException catch (_) {
      state = state.copyWith(
        analyzeStatus: Status.error,
        message:
            "The image quality is too low for accurate analysis. Please provide a clearer image.",
      );
    } catch (e) {
      state = state.copyWith(
        analyzeStatus: Status.error,
        message: "Something went wrong. Please try again.",
      );
    }
  }
}
