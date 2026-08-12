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