import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurants_system/models/restaurant.dart';
import 'package:restaurants_system/services/view_restaurant_service.dart';

class RestaurantState {
  final Restaurant? restaurant;
  final bool isLoading;
  final String? message;
  final String? status;

  RestaurantState({
    this.restaurant,
    this.isLoading = false,
    this.message,
    this.status,
  });

  RestaurantState copyWith({
    Restaurant? restaurant,
    bool? isLoading,
    String? message,
    String? status,
  }) {
    return RestaurantState(
      restaurant: restaurant ?? this.restaurant,
      isLoading: isLoading ?? this.isLoading,
      message: message ?? this.message,
      status: status ?? this.status,
    );
  }
}

class RestaurantNotifier extends Notifier<RestaurantState> {
  @override
  RestaurantState build() {
    return RestaurantState(
      restaurant: Restaurant(
        name: "",
        description: "",
        address: "",
        email: "",
        phone: "",
        logo: "",
        cover_image: "",
        longitude: "35.35590923062667",
        latitude: "35.92778819718201",
        openingTime: "",
        closingTime: "",
      ),
      isLoading: true,
      message: "",
    );
  }

  Future<void> viewRestaurant(int restaurantId) async {
    try {
      state = state.copyWith(isLoading: true, message: "");
      final result = await ref
          .read(viewRestaurantProvider)
          .viewRestaurant(1);
      final data = jsonDecode(result.body);
      if (result.statusCode == 200) {
        state = state.copyWith(
          restaurant: Restaurant.fromJson(data["data"]),
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
        message: e.toString(),
        status: "error",
      );
    }
  }
}
