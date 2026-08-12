import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurants_system/features/meal_details/data/datasources/meal_details_remote_data_source.dart';
import 'package:restaurants_system/features/meal_details/data/repositories/meal_details_repositories_impl.dart';
import 'package:restaurants_system/features/meal_details/domain/repositories/meal_details_repositories.dart';
import 'package:restaurants_system/features/meal_details/presentation/providers/meal_nutrition_state.dart';

final nutritionRemoteDataSourceProvider = Provider<MealDetailsRemoteDataSource>(
  (ref) {
    return MealDetailsRemoteDataSource();
  },
);

final nutritionRepositoryProvider = Provider<MealDetailsRepository>((ref) {
  return MealDetailsRepositoryImpl(ref.read(nutritionRemoteDataSourceProvider));
});

final nutritionProvider = NotifierProvider<NutritionNotifier, NutritionState>(
  NutritionNotifier.new,
);

class NutritionNotifier extends Notifier<NutritionState> {
  late MealDetailsRepository _repository;

  @override
  NutritionState build() {
    _repository = ref.read(nutritionRepositoryProvider);

    return NutritionState.initial();
  }

  Future<void> fetchNutrition({
    required int menuItemId,
    required int restaurantId,
  }) async {
    state = NutritionState.loading();

    try {
      final result = await _repository.getMealNutrition(
        mealItemId: menuItemId,
        restaurantId: restaurantId,
      );

      if (result.isSuccess && result.nutrition != null) {
        state = NutritionState.success(result.nutrition!);
      } else {
        state = NutritionState.error(result.message);
      }
    } catch (e) {
      state = NutritionState.error('Failed to load nutrition analysis');
    }
  }
}
