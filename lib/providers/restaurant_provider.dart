import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:restaurants_system/models/restaurant.dart';
import 'package:restaurants_system/notifier/category_notifier.dart';
import 'package:restaurants_system/notifier/restaurant_notifier.dart';

final restaurantProvider =
    NotifierProvider<RestaurantNotifier, RestaurantScreenState>(() {
      return RestaurantNotifier();
    });
final categoryProvider = NotifierProvider<CategoryNotifier, CategoryState>(() {
  return CategoryNotifier();
});
// final tabIndexProvider = StateProvider<int>((ref) => 0);
