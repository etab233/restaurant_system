import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurants_system/notifier/restaurant_list_notifier.dart';
import 'package:restaurants_system/services/api/restaurant_by_category_service.dart';

final restaurantListProvider = NotifierProvider<RestaurantListNotifier, RestaurantListState>((){
  return RestaurantListNotifier();
});
final restaurantCategoryProvider = Provider<RestaurantByCategoryService>((ref) {
  return RestaurantByCategoryService();
});