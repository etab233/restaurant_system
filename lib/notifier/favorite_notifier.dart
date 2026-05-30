import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurants_system/models/favorite_meal_model.dart';
import 'package:restaurants_system/models/restaurant_model.dart';
import 'package:restaurants_system/services/hive/favorite_meal_services.dart';
import 'package:restaurants_system/services/hive/favorite_restaurant_services.dart';

class FavoriteState{
  final List<RestaurantModel> favoriteRestaurants;
  final List<FavoriteMeal>    favoriteMeals;

  FavoriteState({
    required this.favoriteRestaurants, 
    required this.favoriteMeals
  });
  FavoriteState copyWith({
    List<RestaurantModel>? favoriteRestaurants,
    List<FavoriteMeal>? favoriteMeals,
  }) {
    return FavoriteState(
      favoriteRestaurants: favoriteRestaurants ?? this.favoriteRestaurants,
      favoriteMeals:  favoriteMeals ?? this.favoriteMeals,
    );
  }
}

class FavoriteNotifier extends Notifier<FavoriteState>{
  @override
  FavoriteState build() {
    loadFavorites();
    return FavoriteState(favoriteRestaurants: [], favoriteMeals: []);
  }

  Future<void> loadFavorites() async{
    final restaurants = await FavoriteServices.getAllFavorites();
    final meals = await FavoriteMealServices.getAllFavorites();

    state = state.copyWith(
      favoriteRestaurants: restaurants, 
      favoriteMeals: meals
    );
  }

  Future<void> toggleRestaurant(RestaurantModel restaurant) async {
    await FavoriteServices.toggle(restaurant);
    await loadFavorites();
  }

  Future<void> toggleMeal(FavoriteMeal meal) async {
    await FavoriteMealServices.toggle(meal); 
    await loadFavorites();
  }
}