import '../../data/models/restaurant_by_category_model.dart';

abstract class RestaurantByCategoryRepository {
  Future<RestaurantByCategoryResult> fetchRestaurantsByCategory(int categoryId);
}

class RestaurantByCategoryResult {
  final bool isSuccess;
  final String? status;
  final String? message;
  final List<RestaurantByCategoryModel> restaurants;

  RestaurantByCategoryResult.success({required this.restaurants, this.status})
    : isSuccess = true,
      message = null;

  RestaurantByCategoryResult.failure({this.status, this.message})
    : isSuccess = false,
      restaurants = const [];
}
