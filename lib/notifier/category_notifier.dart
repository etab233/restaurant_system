import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurants_system/models/Category.dart';
import 'package:restaurants_system/models/menuItem.dart';
import 'package:restaurants_system/services/view_restaurant_service.dart';

class CategoryState {
  final Category? category;
  final bool isLoading;
  final String? message;
  final String? status;
  CategoryState({
    this.category,
    this.isLoading = false,
    this.message,
    this.status,
  });
  CategoryState copyWith({
    Category? category,
    bool? isLoading,
    String? message,
    String? status,
  }) {
    return CategoryState(
      category: category ?? this.category,
      isLoading: isLoading ?? this.isLoading,
      message: message ?? this.message,
      status: status ?? this.status,
    );
  }
}

class CategoryNotifier extends Notifier<CategoryState> {
  @override
  CategoryState build() {
    return CategoryState();
  }

  Future<void> fetchCategory(int index) async {
    try {
      state = state.copyWith(isLoading: true);
      final response = await ref.read(viewRestaurantProvider).viewRestaurant(2);
      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        final category = Category.fromJson(data["data"]["categories"][index]);
        state = state.copyWith(category: category, status: data["status"]);
      } else {
        state = state.copyWith(
          isLoading: false,
          message: data["message"],
          status: data["status"],
        );
      }
    } catch (e) {
      state = state.copyWith(
        message: "Error fetching categories",
        status: "Error",
      );
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }
}
