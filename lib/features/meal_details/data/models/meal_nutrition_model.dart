class NutritionValue {
  final double value;
  final String unit;

  const NutritionValue({required this.value, required this.unit});

  factory NutritionValue.fromJson(Map<String, dynamic> json) {
    return NutritionValue(
      value: (json['value'] as num).toDouble(),
      unit: json['unit'] as String,
    );
  }
}

class MealNutritionModel {
  final int menuItemId;
  final String menuItemName;
  final double totalGrams;

  final NutritionValue energy;
  final NutritionValue protein;
  final NutritionValue fat;
  final NutritionValue carbs;
  final NutritionValue fiber;
  final NutritionValue sugars;
  final NutritionValue calcium;
  final NutritionValue iron;
  final NutritionValue sodium;
  final NutritionValue potassium;
  final NutritionValue vitaminC;
  final NutritionValue vitaminA;

  const MealNutritionModel({
    required this.menuItemId,
    required this.menuItemName,
    required this.totalGrams,
    required this.energy,
    required this.protein,
    required this.fat,
    required this.carbs,
    required this.fiber,
    required this.sugars,
    required this.calcium,
    required this.iron,
    required this.sodium,
    required this.potassium,
    required this.vitaminC,
    required this.vitaminA,
  });

  factory MealNutritionModel.fromJson(Map<String, dynamic> json) {
    final nutrients = json['nutrients'] as Map<String, dynamic>;

    return MealNutritionModel(
      menuItemId: json['menu_item_id'] as int,
      menuItemName: json['menu_item_name'] as String,
      totalGrams: (json['total_grams'] as num).toDouble(),

      energy: NutritionValue.fromJson(nutrients['energy_kcal']),
      protein: NutritionValue.fromJson(nutrients['protein_g']),
      fat: NutritionValue.fromJson(nutrients['fat_total_g']),
      carbs: NutritionValue.fromJson(nutrients['carbs_g']),
      fiber: NutritionValue.fromJson(nutrients['fiber_g']),
      sugars: NutritionValue.fromJson(nutrients['sugars_total_g']),
      calcium: NutritionValue.fromJson(nutrients['calcium_mg']),
      iron: NutritionValue.fromJson(nutrients['iron_mg']),
      sodium: NutritionValue.fromJson(nutrients['sodium_mg']),
      potassium: NutritionValue.fromJson(nutrients['potassium_mg']),
      vitaminC: NutritionValue.fromJson(nutrients['vitamin_c_mg']),
      vitaminA: NutritionValue.fromJson(nutrients['vitamin_a_rae_ug']),
    );
  }
}
