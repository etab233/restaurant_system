import 'package:hive/hive.dart';
import 'package:restaurants_system/models/restaurant_model.dart';

class FavoriteServices {
  static late LazyBox<RestaurantModel> box;

  static Future<void> init() async {
    box = await Hive.openLazyBox<RestaurantModel>("favorite_restaurants");
  }

  // تابع لإضافة او حذف مطعم من المفضلة( عند الضغط على زر القلب)
  static Future<void> toggle(RestaurantModel restaurant)async {
    if (box.containsKey(restaurant.id)) {
      await box.delete(restaurant.id);
    } else {
      await box.put(restaurant.id, restaurant);
    }
  }

  // تابع للتحقق إذا المطعم مفضل
  static bool isFavorite(int id) {
    return box.containsKey(id);
  }

  // تابع لجلب كل المفضلة
  static Future<List<RestaurantModel>> getAllFavorites() async {
    final List<RestaurantModel> items = [];
    for (final key in box.keys) {
      final item = await box.get(key);
      if (item != null) items.add(item);
    }
    return items;
  }
}
