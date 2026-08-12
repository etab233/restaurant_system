import 'package:restaurants_system/features/meal_details/data/models/meal_nutrition_model.dart';

class NutritionState {
  final MealNutritionModel? nutrition;
  final bool isLoading;
  final String? errorMessage;

  const NutritionState({
    this.nutrition,
    this.isLoading = false,
    this.errorMessage,
  });

  NutritionState copyWith({
    MealNutritionModel? nutrition,
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
  }) {
    return NutritionState(
      nutrition: nutrition ?? this.nutrition,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }

  factory NutritionState.initial() {
    return const NutritionState();
  }

  factory NutritionState.loading() {
    return const NutritionState(isLoading: true);
  }

  factory NutritionState.success(MealNutritionModel nutrition) {
    return NutritionState(nutrition: nutrition, isLoading: false);
  }

  factory NutritionState.error(String message) {
    return NutritionState(isLoading: false, errorMessage: message);
  }
}
