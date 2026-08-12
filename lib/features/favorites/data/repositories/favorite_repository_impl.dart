import 'package:restaurants_system/features/home/data/models/restaurant_model.dart';
import '../datasources/favorite_meal_local_data_source.dart';
import '../datasources/favorite_restaurant_local_data_source.dart';
import '../models/favorite_meal_model.dart';
import '../../domain/repositories/favorite_repository.dart';

class FavoriteRepositoryImpl implements FavoriteRepository {
  final FavoriteRestaurantLocalDataSource _restaurantSource;
  final FavoriteMealLocalDataSource _mealSource;

  FavoriteRepositoryImpl(this._restaurantSource, this._mealSource);

  @override
  Future<List<RestaurantModel>> getFavoriteRestaurants() =>
      _restaurantSource.getAllFavorites();

  @override
  Future<List<FavoriteMeal>> getFavoriteMeals() => _mealSource.getAllFavorites();

  @override
  Future<void> toggleRestaurant(RestaurantModel restaurant) =>
      _restaurantSource.toggle(restaurant);

  @override
  Future<void> toggleMeal(FavoriteMeal meal) => _mealSource.toggle(meal);
}