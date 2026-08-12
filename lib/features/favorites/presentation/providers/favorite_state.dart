import 'package:restaurants_system/features/home/data/models/restaurant_model.dart';
import '../../data/models/favorite_meal_model.dart';

class FavoriteState {
  final List<RestaurantModel> favoriteRestaurants;
  final List<FavoriteMeal> favoriteMeals;

  FavoriteState({
    required this.favoriteRestaurants,
    required this.favoriteMeals,
  });

  FavoriteState copyWith({
    List<RestaurantModel>? favoriteRestaurants,
    List<FavoriteMeal>? favoriteMeals,
  }) {
    return FavoriteState(
      favoriteRestaurants: favoriteRestaurants ?? this.favoriteRestaurants,
      favoriteMeals: favoriteMeals ?? this.favoriteMeals,
    );
  }
}