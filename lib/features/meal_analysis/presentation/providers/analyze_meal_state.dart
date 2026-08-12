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