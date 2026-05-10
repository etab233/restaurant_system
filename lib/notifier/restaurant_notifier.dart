import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurants_system/models/Category.dart';
import 'package:restaurants_system/models/restaurant.dart';
import 'package:restaurants_system/services/view_restaurant_service.dart';

class RestaurantScreenState {
  final Restaurant? restaurant;
  final List<Category>? categories;
  final bool isLoading;
  final String? message;
  final String? status;
  RestaurantScreenState({
    this.restaurant,
    this.categories,
    this.isLoading = false,
    this.message,
    this.status,
  });

  RestaurantScreenState copyWith({
    Restaurant? restaurant,
    List<Category>? categories,
    bool? isLoading,
    String? message,
    String? status,
  }) {
    return RestaurantScreenState(
      restaurant: restaurant ?? this.restaurant,
      categories: categories ?? this.categories,
      isLoading: isLoading ?? this.isLoading,
      message: message ?? this.message,
      status: status ?? this.status,
    );
  }
}

class RestaurantNotifier extends Notifier<RestaurantScreenState> {
  @override
  RestaurantScreenState build() {
    return RestaurantScreenState(
      restaurant: null,
      categories: null,
      isLoading: false,
      message: "please wait while we fetch restaurant data",
      status: null,
    );
  }

  Future<void> viewRestaurant(int restaurantId) async {
    try {
      state = state.copyWith(isLoading: true);
      final result = await ref.read(viewRestaurantProvider).viewRestaurant(2);
      final data = jsonDecode(result.body);
      if (result.statusCode == 200) {
        state = state.copyWith(
          restaurant: Restaurant.fromJson(data["data"]["restaurant"]),
          categories: (data["data"]["categories"] as List?)?.map((e) => Category.fromJson(e)).toList(),
          isLoading: false,
          status: data["status"],
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          message:
              data["message"] ??
              "An error occurred while fetching restaurant data",
          status: data["status"],
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        message:
            "An error has been occured please try again later ${e.toString()}",
        status: "error",
      );
    }
  }
}
