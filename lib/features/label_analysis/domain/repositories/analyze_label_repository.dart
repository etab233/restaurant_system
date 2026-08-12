abstract class AnalyzeLabelRepository {
  Future<AnalyzeLabelResult> analyze({
    required String imagePath,
    required String token,
  });
}

class AnalyzeLabelResult {
  final bool isSuccess;
  final double? calories;
  final double? protein;
  final double? carbs;
  final double? fat;
  final String message;

  AnalyzeLabelResult.success({
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
  }) : isSuccess = true,
       message = "Operation successful";

  AnalyzeLabelResult.failure(this.message)
    : isSuccess = false,
      calories = null,
      protein = null,
      carbs = null,
      fat = null;
}
