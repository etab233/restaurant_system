import 'food_item_model.dart';

class DashboardModel {
  final double calories;
  final double protein;
  final double fat;
  final double carbs;

  final double fiber;
  final double sugars;
  final double sodium;
  final double potassium;
  final double calcium;
  final double vitaminC;
  final double iron;
  final double vitaminA;

  final List<FoodItem> meals;

  DashboardModel({
    this.calories = 0,
    this.protein = 0,
    this.fat = 0,
    this.carbs = 0,
    this.fiber = 0,
    this.sugars = 0,
    this.sodium = 0,
    this.potassium = 0,
    this.calcium = 0,
    this.vitaminC = 0,
    this.iron = 0,
    this.vitaminA = 0,
    this.meals = const [],
  });

  DashboardModel copyWith({
    double? calories,
    double? protein,
    double? fat,
    double? carbs,
    double? fiber,
    double? sugars,
    double? sodium,
    double? potassium,
    double? calcium,
    double? vitaminC,
    double? iron,
    double? vitaminA,
    List<FoodItem>? meals,
  }) {
    return DashboardModel(
      calories: calories ?? this.calories,
      protein: protein ?? this.protein,
      fat: fat ?? this.fat,
      carbs: carbs ?? this.carbs,
      fiber: fiber ?? this.fiber,
      sugars: sugars ?? this.sugars,
      sodium: sodium ?? this.sodium,
      potassium: potassium ?? this.potassium,
      calcium: calcium ?? this.calcium,
      vitaminC: vitaminC ?? this.vitaminC,
      iron: iron ?? this.iron,
      vitaminA: vitaminA ?? this.vitaminA,
      meals: meals ?? this.meals,
    );
  }
}