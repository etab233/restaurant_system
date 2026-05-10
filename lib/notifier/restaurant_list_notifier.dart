import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurants_system/models/restaurant.dart';
import 'package:restaurants_system/providers/restaurant_by_category.dart';

class RestaurantListState {
  final List<Restaurant> restaurants;
  final bool isLoading;
  final String? message;
  final String? status;
  RestaurantListState({
    this.restaurants = const [],
    this.isLoading = false,
    this.message,
    this.status,
  });
  RestaurantListState copyWith({
    List<Restaurant>? restaurants,
    bool? isLoading,
    String? message,
    String? status,
  }) {
    return RestaurantListState(
      restaurants: restaurants ?? this.restaurants,
      isLoading: isLoading ?? this.isLoading,
      message: message ?? this.message,
      status: status ?? this.status,
    );
  }
}

class RestaurantListNotifier extends Notifier<RestaurantListState> {
  @override
  RestaurantListState build() {
    return RestaurantListState(
      restaurants: [],
      isLoading: true,
      message: "",
      status: "",
    );
  }

  Future<void> fetchRestaurantsByCategory(int categoryId) async {
    try {
      state = state.copyWith(isLoading: true, message: "", status: "");
      final response = await ref
          .read(restaurantCategoryProvider)
          .fetchRestaurantsByCategory(categoryId);
      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        final restaurants = (data["data"]["restaurants"] as List)
            .map((e) => Restaurant.fromJson(e))
            .toList();
        if (state.restaurants.isEmpty) {
          state = state.copyWith(
            message: "No Restaurants Found",
            status: data["status"],
          );
          return;
        }
        state = state.copyWith(
          restaurants: restaurants,
          status: data["status"],
        );
      } else {
        state = state.copyWith(
          message: data["message"],
          status: data["status"],
        );
      }
    } catch (e) {
      state = state.copyWith(
        message: "An error occurred while fetching data",
        status: "error",
      );
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }
}
