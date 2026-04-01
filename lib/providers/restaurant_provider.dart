import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurants_system/models/restaurant.dart';
import 'package:restaurants_system/notifier/restaurant_screen_notifier.dart';

final restaurantProvider = NotifierProvider<RestaurantNotifier, RestaurantState>((){
  return RestaurantNotifier();
});

final messageProvider = Provider<String?>((ref) {
  return ref.watch(restaurantProvider).message;
},);

final isLoadingProvider = Provider<bool?>((ref) {
  return ref.watch(restaurantProvider).isLoading;
},);
final restaurantDataProvider = Provider<Restaurant?>((ref) {
  return ref.watch(restaurantProvider).restaurant;
},);