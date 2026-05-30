import 'package:hive_flutter/hive_flutter.dart';
import 'package:restaurants_system/models/favorite_meal_model.dart';

class FavoriteMealServices {
  static late LazyBox<FavoriteMeal> box;

  static Future<void> init() async {
    box = await Hive.openLazyBox<FavoriteMeal>("favorite_meals");
  }

  // add / remove
  static Future<void> toggle(FavoriteMeal meal) async {
    if (box.containsKey(meal.itemId)) {
      await box.delete(meal.itemId);
    } else {
      await box.put(meal.itemId, meal);
    }
  }

  // check
  static bool isFavorite(int itemId) {
    return box.containsKey(itemId);
  }

  // get all
  static Future<List<FavoriteMeal>> getAllFavorites() async {
    final List<FavoriteMeal> items = [];
    for (final key in box.keys) {
      final item = await box.get(key);
      if (item != null) items.add(item);
    }
    return items;
  }
}
