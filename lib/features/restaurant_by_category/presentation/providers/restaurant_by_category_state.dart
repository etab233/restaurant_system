import '../../data/models/restaurant_by_category_model.dart';

class RestaurantByCategoryState {
  final List<RestaurantByCategoryModel> restaurants;
  final bool isLoading;
  final String? message;
  final String? status;

  RestaurantByCategoryState({
    this.restaurants = const [],
    this.isLoading = false,
    this.message,
    this.status,
  });

  RestaurantByCategoryState copyWith({
    List<RestaurantByCategoryModel>? restaurants,
    bool? isLoading,
    String? message,
    String? status,
  }) {
    return RestaurantByCategoryState(
      restaurants: restaurants ?? this.restaurants,
      isLoading: isLoading ?? this.isLoading,
      message: message ?? this.message,
      status: status ?? this.status,
    );
  }
}