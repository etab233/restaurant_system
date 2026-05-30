import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurants_system/models/menu_item.dart';
import 'package:restaurants_system/services/api/meal_details_services.dart';

class MealDetailsState {
  final String status;
  final String message;
  final MenuItem menuItem;

  MealDetailsState({
    required this.status,
    required this.message,
    required this.menuItem,
  });

  MealDetailsState copyWith({
    String? status,
    String? message,
    MenuItem? menuItem,
  }) {
    return MealDetailsState(
      status: status ?? this.status,
      message: message ?? this.message,
      menuItem: menuItem ?? this.menuItem,
    );
  }
}

class MealDetailsNotifier extends Notifier<MealDetailsState> {
  late MealDetailsServices _mealDetailsServices;

  @override
  MealDetailsState build() {
    _mealDetailsServices = MealDetailsServices();

    return MealDetailsState(
      status: "",
      message: "",
      menuItem: MenuItem(
        itemId: 0,
        restaurantId: 0,
        name: "",
        description: "",
        isFeatured: false,
        preparationTime: "",
        price: 0.0,
        variants: [],
        modifierGroups: [],
      ),
    );
  }

  Future<void> getMealDetails({
    required int restaurantId,
    required mealId,
  }) async {
    state = state.copyWith(status: "loading", message: "loading data ..");
    try {
      final result = await _mealDetailsServices.getMealDetails(
        mealId: mealId,
        restaurantId: restaurantId,
      );

      final data = json.decode(result.body);
      if (result.statusCode == 200) {
        state = state.copyWith(
          status: data['status'],
          message: data['message'],
          menuItem: MenuItem.fromJson(data['data']),
        );
      } else {
        state = state.copyWith(
          status: data['status'],
          message: data['message'],
        );
      }
    } catch (e) {
      state = state.copyWith(
        status: "error",
        message:
            "An error has been occurred please try again later ${e.toString()}",
      );
    }
  }
}
