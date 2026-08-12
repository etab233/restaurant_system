import 'package:hive_flutter/hive_flutter.dart';
import '../models/favorite_meal_model.dart';

class FavoriteMealLocalDataSource {
  static late LazyBox<FavoriteMeal> _box;

  static Future<void> init() async {
    _box = await Hive.openLazyBox<FavoriteMeal>("favorite_meals");
  }

  Future<void> toggle(FavoriteMeal meal) async {
    if (_box.containsKey(meal.itemId)) {
      await _box.delete(meal.itemId);
    } else {
      await _box.put(meal.itemId, meal);
    }
  }

  bool isFavorite(int itemId) => _box.containsKey(itemId);

  Future<List<FavoriteMeal>> getAllFavorites() async {
    final List<FavoriteMeal> items = [];
    for (final key in _box.keys) {
      final item = await _box.get(key);
      if (item != null) items.add(item);
    }
    return items;
  }
}