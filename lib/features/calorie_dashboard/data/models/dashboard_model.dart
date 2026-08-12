import 'food_item_model.dart';

class DashboardModel {
  final double calories;
  final double protein;
  final double fat;
  final double carbs;
  final List<FoodItem> meals;

  DashboardModel({
    this.calories = 0,
    this.protein = 0,
    this.fat = 0,
    this.carbs = 0,
    this.meals = const [],
  });

  DashboardModel copyWith({
    double? calories,
    double? protein,
    double? fat,
    double? carbs,
    List<FoodItem>? meals,
  }) {
    return DashboardModel(
      calories: calories ?? this.calories,
      protein: protein ?? this.protein,
      fat: fat ?? this.fat,
      carbs: carbs ?? this.carbs,
      meals: meals ?? this.meals,
    );
  }
}
