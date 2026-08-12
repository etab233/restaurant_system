import '../../data/models/category_model.dart';
import '../../data/models/restaurant_model.dart';

class HomeState {
  final String status;
  final List<Category> categories;
  final List<RestaurantModel> restaurants;

  const HomeState({
    required this.status,
    required this.categories,
    required this.restaurants,
  });

  HomeState copyWith({
    String? status,
    List<Category>? categories,
    List<RestaurantModel>? restaurants,
  }) {
    return HomeState(
      status: status ?? this.status,
      categories: categories ?? this.categories,
      restaurants: restaurants ?? this.restaurants,
    );
  }
}