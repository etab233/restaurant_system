import 'package:hive/hive.dart';
import 'package:restaurants_system/features/home/data/models/restaurant_model.dart';

class FavoriteRestaurantLocalDataSource {
  static late LazyBox<RestaurantModel> _box;

  static Future<void> init() async {
    _box = await Hive.openLazyBox<RestaurantModel>("favorite_restaurants");
  }

  Future<void> toggle(RestaurantModel restaurant) async {
    if (_box.containsKey(restaurant.id)) {
      await _box.delete(restaurant.id);
    } else {
      await _box.put(restaurant.id, restaurant);
    }
  }

  bool isFavorite(int id) => _box.containsKey(id);

  Future<List<RestaurantModel>> getAllFavorites() async {
    final List<RestaurantModel> items = [];
    for (final key in _box.keys) {
      final item = await _box.get(key);
      if (item != null) items.add(item);
    }
    return items;
  }
}