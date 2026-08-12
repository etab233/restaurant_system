import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurants_system/features/home/data/models/restaurant_model.dart';
import '../../data/datasources/favorite_meal_local_data_source.dart';
import '../../data/datasources/favorite_restaurant_local_data_source.dart';
import '../../data/models/favorite_meal_model.dart';
import '../../data/repositories/favorite_repository_impl.dart';
import '../../domain/repositories/favorite_repository.dart';
import 'favorite_state.dart';

final favoriteRepositoryProvider = Provider<FavoriteRepository>((ref) {
  return FavoriteRepositoryImpl(
    FavoriteRestaurantLocalDataSource(),
    FavoriteMealLocalDataSource(),
  );
});

final favoritesProvider = NotifierProvider<FavoriteNotifier, FavoriteState>(
  FavoriteNotifier.new,
);

class FavoriteNotifier extends Notifier<FavoriteState> {
  late FavoriteRepository _repository;

  @override
  FavoriteState build() {
    _repository = ref.read(favoriteRepositoryProvider);
    loadFavorites();
    return FavoriteState(favoriteRestaurants: [], favoriteMeals: []);
  }

  Future<void> loadFavorites() async {
    final restaurants = await _repository.getFavoriteRestaurants();
    final meals = await _repository.getFavoriteMeals();

    state = state.copyWith(favoriteRestaurants: restaurants, favoriteMeals: meals);
  }

  Future<void> toggleRestaurant(RestaurantModel restaurant) async {
    await _repository.toggleRestaurant(restaurant);
    await loadFavorites();
  }

  Future<void> toggleMeal(FavoriteMeal meal) async {
    await _repository.toggleMeal(meal);
    await loadFavorites();
  }
}