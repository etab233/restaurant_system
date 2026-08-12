import 'package:hive/hive.dart';

class DashboardLocalDataSource {
  Box get _box => Hive.box("health_account");

  Future<void> saveMacros({
    required double calories,
    required double protein,
    required double carbs,
    required double fat,
  }) async {
    await _box.put('calories', calories);
    await _box.put('protein', protein);
    await _box.put('carbs', carbs);
    await _box.put('fat', fat);
  }

  CachedMacros getSavedMacros() {
    return CachedMacros(
      calories: _box.get('calories') ?? 0,
      protein: _box.get('protein') ?? 0,
      carbs: _box.get('carbs') ?? 0,
      fat: _box.get('fat') ?? 0,
    );
  }

  Future<String> getToken() => Hive.box("user_data").get("token");
}

class CachedMacros {
  final double calories;
  final double protein;
  final double carbs;
  final double fat;

  CachedMacros({
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
  });
}
