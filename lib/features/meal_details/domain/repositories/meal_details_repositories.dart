import 'package:restaurants_system/features/meal_details/data/models/meal_nutrition_model.dart';

import '../../data/models/meal_item_model.dart';

abstract class MealDetailsRepository {
  Future<MealDetailsResult> getMealDetails({
    required int restaurantId,
    required int mealId,
  });

  Future<MealDetailsResult> getCartMealDetails({
    required int itemId,
    required String token,
  });

  Future<NutritionResult> getMealNutrition({
    required int restaurantId,
    required int mealItemId,
  });
}

class MealDetailsResult {
  final bool isSuccess;
  final String status;
  final String message;
  final MealItem? meal;

  MealDetailsResult.success({
    required this.status,
    required this.message,
    required this.meal,
  }) : isSuccess = true;

  MealDetailsResult.failure({required this.status, required this.message})
    : isSuccess = false,
      meal = null;
}

class NutritionResult {
  final bool isSuccess;
  final String status;
  final String message;
  final MealNutritionModel? nutrition;

  NutritionResult.success({
    required this.status,
    required this.message,
    this.nutrition,
  }) : isSuccess = true;

  NutritionResult.failure({required this.status, required this.message})
    : isSuccess = false,
      nutrition = null;
}
