class FoodItem {
  String? id;
  String? name;
  double? caloriesPer100g;
  double? protein;
  double? carbs;
  double? fat;
  String? source;
  double? quantity;

  FoodItem({
    this.id,
    this.name,
    this.caloriesPer100g,
    this.protein,
    this.carbs,
    this.fat,
    this.source,
    this.quantity
  });

  // from openfoodfact
  factory FoodItem.fromOpenFoodFact(Map<String, dynamic> json) {
    final product = json['product'];

    return FoodItem(
      id      : product['code'], 
      name    : product['product_name'],
      caloriesPer100g: (product['nutriments']?['energy-kcal_100g'] ?? 0).toDouble(),
      protein : (product['nutriments']?['proteins_100g'] ?? 0).toDouble(),
      carbs   : (product['nutriments']?['carbohydrates_100g'] ?? 0).toDouble(),
      fat     : (product['nutriments']?['fat_100g'] ?? 0).toDouble(),
      source  : "OpenFoodFact",
      quantity: 0
    );
  }

  //from edamam
  factory FoodItem.fromEdamam(Map<String, dynamic> json) {
    return FoodItem(
      id      : json['food']['foodId'], 
      name    : json['food']['label'],
      caloriesPer100g: (json['food']['nutrients']?['ENERC_KCAL'] ?? 0).toDouble(),
      protein : (json['food']['nutrients']?['PROCNT'] ?? 0).toDouble(),
      carbs   : (json['food']['nutrients']?['CHOCDF'] ?? 0).toDouble(),
      fat     : (json['food']['nutrients']?['FAT'] ?? 0).toDouble(),
      source  : "Edamam",
      quantity: 0
    );
  }
}