import 'dart:convert';
import 'package:restaurants_system/features/meal_details/data/models/meal_nutrition_model.dart';
import 'package:restaurants_system/features/meal_details/domain/repositories/meal_details_repositories.dart';
import '../datasources/meal_details_remote_data_source.dart';
import '../models/meal_item_model.dart';

class MealDetailsRepositoryImpl implements MealDetailsRepository {
  final MealDetailsRemoteDataSource _remote;

  MealDetailsRepositoryImpl(this._remote);

  @override
  Future<MealDetailsResult> getMealDetails({
    required int restaurantId,
    required int mealId,
  }) async {
    try {
      final result = await _remote.getMealDetails(
        restaurantId: restaurantId,
        mealId: mealId,
      );
      final data = json.decode(result.body);

      if (result.statusCode == 200) {
        return MealDetailsResult.success(
          status: data['status'],
          message: data['message'],
          meal: MealItem.fromJson(data["data"] as Map<String, dynamic>),
        );
      }
      return MealDetailsResult.failure(
        status: data['status'],
        message: data['message'],
      );
    } catch (e) {
      return MealDetailsResult.failure(
        status: "error",
        message:
            "An error has been occurred please try again later ${e.toString()}",
      );
    }
  }

  @override
  Future<MealDetailsResult> getCartMealDetails({
    required int itemId,
    required String token,
  }) async {
    try {
      final response = await _remote.getCartMealDetails(
        itemId: itemId,
        token: token,
      );
      final data = json.decode(response.body);

      if (response.statusCode == 200) {
        return MealDetailsResult.success(
          status: data['status'],
          message: data['message'],
          meal: MealItem.fromJson(data["data"] as Map<String, dynamic>),
        );
      }
      return MealDetailsResult.failure(
        status: "error",
        message: data["message"] ?? "Unknown error",
      );
    } catch (e) {
      return MealDetailsResult.failure(status: "error", message: e.toString());
    }
  }

  @override
  Future<NutritionResult> getMealNutrition({
    required int restaurantId,
    required int mealItemId,
  }) async {
    try {
      final response = await _remote.getMealNutrition(
        restaurantId: restaurantId,
        mealItemId: mealItemId,
      );
      final data = json.decode(response.body);
      if (response.statusCode == 200) {
        return NutritionResult.success(
          status: "success",
          message: data['message'],
          nutrition: MealNutritionModel.fromJson(
            data['data'] as Map<String, dynamic>,
          ),
        );
      }
      return NutritionResult.failure(
        status: "error",
        message: data["message"] ?? "Unknown error",
      );
    } catch (e) {
      return NutritionResult.failure(status: "error", message: e.toString());
    }
  }
}
