class FoodItem {
  String? description;
  double? calories;
  double? protein;
  double? carbs;
  double? fat;

  FoodItem({
    this.description,
    this.calories,
    this.protein,
    this.carbs,
    this.fat,
  });

  factory FoodItem.fromJson(Map<String, dynamic> j) => FoodItem(
    description:    j['description'],
    calories:       (j['calories']      as num).toDouble(),
    protein:        (j['protein']       as num).toDouble(),
    carbs:          (j['carbs']         as num).toDouble(),
    fat:            (j['fat']           as num).toDouble(),
  );
}