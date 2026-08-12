abstract class AnalyzeMealRepository {
  Future<AnalyzeMealResult> analyze({
    required String imagePath,
    String? description,
    required String token,
  });
}

class AnalyzeMealResult {
  final bool isSuccess;
  final String? name;
  final String? description;
  final double? calories;
  final double? protein;
  final double? carbs;
  final double? fat;
  final String? confidence;
  final String message;

  AnalyzeMealResult.success({
    this.name,
    this.description,
    this.calories,
    this.protein,
    this.carbs,
    this.fat,
    this.confidence,
  }) : isSuccess = true,
       message = "Operation successful";

  AnalyzeMealResult.failure(this.message)
    : isSuccess = false,
      name = null,
      description = null,
      calories = null,
      protein = null,
      carbs = null,
      fat = null,
      confidence = null;
}
