import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurants_system/services/api/analyze_label_services.dart';

class AnalyzeLabelState {
  final double calories;
  final double protein;
  final double carbs;
  final double fat;
  final bool success;
  final String message;

  const AnalyzeLabelState({
    this.calories = 0.0,
    this.protein = 0.0,
    this.carbs = 0.0,
    this.fat = 0.0,
    this.success = false,
    this.message = "",
  });

  AnalyzeLabelState copyWith({
    double? calories,
    double? protein,
    double? carbs,
    double? fat,
    bool? success,
    String? message,
  }) {
    return AnalyzeLabelState(
      calories: calories ?? this.calories,
      protein: protein ?? this.protein,
      carbs: carbs ?? this.carbs,
      fat: fat ?? this.fat,
      success: success ?? this.success,
      message: message ?? this.message,
    );
  }
}

class AnalyzeLabelNotifier extends Notifier<AnalyzeLabelState> {
  late final AnalyzeLabelServices _analyzeLabelServices;

  @override
  AnalyzeLabelState build() {
    _analyzeLabelServices = AnalyzeLabelServices();
    return const AnalyzeLabelState();
  }

  // تابع لاستخراج الأرقام من الرد
  double extractNumber(String value) {
    final number = RegExp(r'[\d.]+').firstMatch(value);

    if (number != null) {
      return double.parse(number.group(0)!);
    }

    return 0;
  }

  Future<void> analyze({
    required String imagePath,
    required String token,
  }) async {
    try {
      final response = await _analyzeLabelServices.analyze(
        imagePath: imagePath,
        token: token,
      );

      if (response.containsKey("error")) {
        // حالة خطأ
        state = state.copyWith(success: false, message: response['error']);
      } else {
        // تم المسح بنجاح
        state = state.copyWith(
          calories: extractNumber(response['calories']),
          protein: extractNumber(response['protein']),
          fat: extractNumber(response['fat']),
          carbs: extractNumber(response['carbs']),
          success: true,
          message: "Operation successful",
        );
      }
    } catch (e) {
      state = state.copyWith(
        success: false,
        message: "Something went wrong. Please try again.",
      );
    }
  }
}
