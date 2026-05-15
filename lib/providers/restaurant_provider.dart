import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurants_system/notifier/restaurant_notifier.dart';

final restaurantProvider =
    NotifierProvider<RestaurantNotifier, RestaurantScreenState>(() {
      return RestaurantNotifier();
    });
