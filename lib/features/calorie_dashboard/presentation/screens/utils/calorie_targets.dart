import 'package:restaurants_system/core/utils/calorie_logic.dart';
import 'package:restaurants_system/features/health_profile/presentation/providers/health_profile_state.dart';

class CalorieTargets {
  final double dailyCalorieNeeds;
  final double protein;
  final double carbs;
  final double fat;
  final double? weightKg;

  const CalorieTargets({
    required this.dailyCalorieNeeds,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.weightKg,
  });

  factory CalorieTargets.fromHealthProfile(HealthProfileState health) {
    final birth = health.birthDate;
    final age = birth != null ? calculateAge(birth) : null;
    final h = health.heightCm;
    final w = health.weightKg;
    final gender = health.gender;
    final goal = health.goal;
    final activityLevel = health.activityLevel;

    final hasCompleteProfile =
        age != null &&
        gender.isNotEmpty &&
        h > 0 &&
        w > 0 &&
        activityLevel.isNotEmpty &&
        goal.isNotEmpty;

    if (!hasCompleteProfile) {
      return const CalorieTargets(
        dailyCalorieNeeds: 0,
        protein: 0,
        carbs: 0,
        fat: 0,
        weightKg: null,
      );
    }

    final bmr = calculateBMR(age: age, gender: gender, h: h, w: w);
    final tdee = determineTDEE(activityLevel: activityLevel, bmr: bmr);
    final dailyCalorieNeeds = calculatingDailyCalorieNeeds(
      goal: goal,
      tdee: tdee,
    );
    final fat = calculateDailyFat(weightKg: w);
    final protein = calculateDailyProtein(weightKg: w, goal: goal);
    final carbs = calculateDailyCarbs(
      calories: dailyCalorieNeeds,
      proteinGrams: protein,
      fatGrams: fat,
    );

    return CalorieTargets(
      dailyCalorieNeeds: dailyCalorieNeeds,
      protein: protein,
      carbs: carbs,
      fat: fat,
      weightKg: w,
    );
  }
}
