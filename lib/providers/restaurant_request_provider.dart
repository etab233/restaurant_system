import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:restaurants_system/models/category_model.dart';
import 'package:restaurants_system/notifier/restaurant_request_notifier.dart';

final restaurantRequestProvider = NotifierProvider<RestaurantRequestNotifier,RestaurantRequestState>((){
  return RestaurantRequestNotifier();
});

final messageProvider = Provider<String?>((ref) {
  return ref.watch(restaurantRequestProvider).message;
},);

final isLoadingProvider = Provider<bool?>((ref) {
  return ref.watch(restaurantRequestProvider).isLoading;
},);

final statusProvider = Provider<String?>((ref) {
  return ref.watch(restaurantRequestProvider).status;
},);

final pickedLocationProvider = Provider<LatLng?>((ref) {
  return ref.watch(restaurantRequestProvider).pickedLocation;
},);

final finalAddressProvider = Provider<bool?>((ref){
  return ref.watch(restaurantRequestProvider).findAddress;
});

final categories = Provider<List<Category>?>((ref){
  return ref.watch(restaurantRequestProvider).categories;
});

final isLoadCategories = Provider<bool?>((ref) {
  return ref.watch(restaurantRequestProvider).isLoadCategories;
});