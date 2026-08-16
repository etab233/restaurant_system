import 'package:hive/hive.dart';

class DashboardLocalDataSource {
  Box get _box => Hive.box("health_account");

  Future<void> saveMacros({
    required double calories,
    required double protein,
    required double carbs,
    required double fat,
    required double fiber,
    required double sugars,
    required double sodium,
    required double potassium,
    required double calcium,
    required double vitaminC,
    required double iron,
    required double vitaminA,
  }) async {
    await _box.put('calories', calories);
    await _box.put('protein', protein);
    await _box.put('carbs', carbs);
    await _box.put('fat', fat);

    await _box.put('fiber', fiber);
    await _box.put('sugars', sugars);
    await _box.put('sodium', sodium);
    await _box.put('potassium', potassium);
    await _box.put('calcium', calcium);
    await _box.put('vitaminC', vitaminC);
    await _box.put('iron', iron);
    await _box.put('vitaminA', vitaminA);
  }

  CachedMacros getSavedMacros() {
    return CachedMacros(
      calories: (_box.get('calories', defaultValue: 0) as num).toDouble(),
      protein: (_box.get('protein', defaultValue: 0) as num).toDouble(),
      carbs: (_box.get('carbs', defaultValue: 0) as num).toDouble(),
      fat: (_box.get('fat', defaultValue: 0) as num).toDouble(),

      fiber: (_box.get('fiber', defaultValue: 0) as num).toDouble(),
      sugars: (_box.get('sugars', defaultValue: 0) as num).toDouble(),
      sodium: (_box.get('sodium', defaultValue: 0) as num).toDouble(),
      potassium: (_box.get('potassium', defaultValue: 0) as num).toDouble(),
      calcium: (_box.get('calcium', defaultValue: 0) as num).toDouble(),
      vitaminC: (_box.get('vitaminC', defaultValue: 0) as num).toDouble(),
      iron: (_box.get('iron', defaultValue: 0) as num).toDouble(),
      vitaminA: (_box.get('vitaminA', defaultValue: 0) as num).toDouble(),
    );
  }

  Future<String?> getToken() async {
    return Hive.box("user_data").get("token") as String?;
  }
}

class CachedMacros {
  final double calories;
  final double protein;
  final double carbs;
  final double fat;

  final double fiber;
  final double sugars;
  final double sodium;
  final double potassium;
  final double calcium;
  final double vitaminC;
  final double iron;
  final double vitaminA;

  CachedMacros({
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.fiber,
    required this.sugars,
    required this.sodium,
    required this.potassium,
    required this.calcium,
    required this.vitaminC,
    required this.iron,
    required this.vitaminA,
  });
}