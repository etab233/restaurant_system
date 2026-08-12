import 'dart:async';
import 'package:restaurants_system/features/meal_analysis/data/datasources/analyze_meal_remote_data_souce.dart';

import '../../domain/repositories/analyze_meal_repository.dart';

class AnalyzeMealRepositoryImpl implements AnalyzeMealRepository {
  final AnalyzeMealRemoteDataSource _remote;

  AnalyzeMealRepositoryImpl(this._remote);

  @override
  Future<AnalyzeMealResult> analyze({
    required String imagePath,
    String? description,
    required String token,
  }) async {
    try {
      final response = await _remote
          .analyze(imagePath: imagePath, description: description, token: token)
          .timeout(const Duration(seconds: 40));

      if (response.containsKey("error")) {
        return AnalyzeMealResult.failure(response['error']);
      }

      return AnalyzeMealResult.success(
        name: response["dish_name"],
        description: response["description"],
        calories: (response["calories"] as num).toDouble(),
        protein: (response["protein"] as num).toDouble(),
        carbs: (response["carbs"] as num).toDouble(),
        fat: (response["fat"] as num).toDouble(),
        confidence: response["confidence"],
      );
    } on TimeoutException catch (_) {
      return AnalyzeMealResult.failure(
        "The image quality is too low for accurate analysis. Please provide a clearer image.",
      );
    } catch (e) {
      return AnalyzeMealResult.failure(
        "Something went wrong. Please try again.",
      );
    }
  }
}
