import 'package:restaurants_system/models/restaurant_model.dart';
import 'package:restaurants_system/notifier/home_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurants_system/models/category_model.dart';

final homeProvider = NotifierProvider<HomeNotifier, HomeState>((){
  return HomeNotifier();
});

final categoriesProvider = Provider<List<Category>>((ref) {
  return ref.watch(homeProvider).categories;
},);

final restaurantsProvider = Provider<List<RestaurantModel>?>((ref) {
  return ref.watch(homeProvider).restaurants;
},);

final statusProvider = Provider<String>((ref) {
  return ref.watch(homeProvider).status;
},);