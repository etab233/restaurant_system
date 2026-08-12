import 'package:restaurants_system/features/home/data/models/restaurant_model.dart';
import '../../data/models/favorite_meal_model.dart';

abstract class FavoriteRepository {
  Future<List<RestaurantModel>> getFavoriteRestaurants();
  Future<List<FavoriteMeal>> getFavoriteMeals();
  Future<void> toggleRestaurant(RestaurantModel restaurant);
  Future<void> toggleMeal(FavoriteMeal meal);
}