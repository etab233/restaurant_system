import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurants_system/models/dashboard_model.dart';

class DashboardNotifier extends Notifier<DashboardModel> {
  @override
  DashboardModel build() {
    return DashboardModel();
  }

  void addMeal({
    required calories,
    required protein,
    required carbs,
    required fat,
    required food,
  }) {
    state = state.copyWith(
      calories: state.calories + calories,
      protein: state.protein + protein,
      carbs: state.carbs + carbs,
      fat: state.fat + fat,
      meals: [...state.meals, food],
    );
  }

  void removeMeal(int index) {
    if (index < 0 || index >= state.meals.length) return;
    final updated = [...state.meals]..removeAt(index);
    state = state.copyWith(meals: updated);
  }
}
