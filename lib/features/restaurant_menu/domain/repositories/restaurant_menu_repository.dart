import 'package:restaurants_system/features/home/data/models/category_model.dart';
import 'package:restaurants_system/features/home/data/models/restaurant_model.dart';

abstract class RestaurantMenuRepository {
  Future<RestaurantMenuResult> viewRestaurant(int restaurantId);
}

class RestaurantMenuResult {
  final bool isSuccess;
  final String? status;
  final String message;
  final RestaurantModel? restaurant;
  final List<Category>? categories;

  RestaurantMenuResult.success({
    this.status,
    required this.message,
    required this.restaurant,
    required this.categories,
  }) : isSuccess = true;

  RestaurantMenuResult.failure({this.status, required this.message})
    : isSuccess = false,
      restaurant = null,
      categories = null;
}
