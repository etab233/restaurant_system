import 'package:hive_flutter/hive_flutter.dart';
import 'package:restaurants_system/features/favorites/data/datasources/favorite_meal_local_data_source.dart';
import 'package:restaurants_system/features/favorites/data/datasources/favorite_restaurant_local_data_source.dart';
import 'package:restaurants_system/features/favorites/data/models/favorite_meal_model.dart';
import 'package:restaurants_system/features/home/data/models/category_model.dart';
import 'package:restaurants_system/features/home/data/models/restaurant_model.dart';

Future<void> setupHive() async {
  await Hive.initFlutter();

  Hive.registerAdapter(RestaurantModelAdapter());
  Hive.registerAdapter(RestaurantHoursAdapter());
  Hive.registerAdapter(RestaurantLocationAdapter());
  Hive.registerAdapter(CategoryAdapter());
  Hive.registerAdapter(FavoriteMealAdapter());

  await Future.wait<dynamic>([
    Hive.openBox<RestaurantModel>("restaurantsBox"),
    Hive.openBox<Category>("categoriesBox"),
    Hive.openBox('locationBox'),
    Hive.openBox('user_data'),
    Hive.openBox("health_account"),
    FavoriteRestaurantLocalDataSource.init(),
    FavoriteMealLocalDataSource.init(),
  ]);
}