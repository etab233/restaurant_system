import 'package:restaurants_system/features/home/data/datasources/category_local_data.dart';
import 'package:restaurants_system/features/home/data/datasources/restaurant_local_data.dart';
import 'package:restaurants_system/features/home/data/models/category_model.dart';
import 'package:restaurants_system/features/home/data/models/restaurant_model.dart';

class HomeLocalDataSource {
  final RestaurantLocalData _restaurantLocal;
  final CategoryLocalData _categoryLocal;

  HomeLocalDataSource({
    RestaurantLocalData? restaurantLocal,
    CategoryLocalData? categoryLocal,
  })  : _restaurantLocal = restaurantLocal ?? RestaurantLocalData(),
        _categoryLocal = categoryLocal ?? CategoryLocalData();

  List<RestaurantModel> getCachedRestaurants() => _restaurantLocal.getCachedRestaurants();

  List<Category> getCachedCategories() => _categoryLocal.getCachedCategories();

  Future<void> cacheRestaurants(List<RestaurantModel> restaurants) =>
      _restaurantLocal.cacheRestaurants(restaurants);

  Future<void> cacheCategories(List<Category> categories) =>
      _categoryLocal.cacheCategories(categories);

  bool get hasCache =>
      getCachedRestaurants().isNotEmpty || getCachedCategories().isNotEmpty;
}