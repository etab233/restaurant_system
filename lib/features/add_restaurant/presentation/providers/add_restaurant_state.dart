import 'package:restaurants_system/features/home/data/models/category_model.dart';

class AddRestaurantState {
  final String status;
  final String message;
  final bool isLoading;
  final List<Category> categories;
  final bool isLoadCategories;

  const AddRestaurantState({
    required this.status,
    required this.message,
    required this.isLoading,
    required this.categories,
    required this.isLoadCategories,
  });

  AddRestaurantState copyWith({
    String? status,
    String? message,
    bool? isLoading,
    List<Category>? categories,
    bool? isLoadCategories,
  }) {
    return AddRestaurantState(
      status: status ?? this.status,
      message: message ?? this.message,
      isLoading: isLoading ?? this.isLoading,
      categories: categories ?? this.categories,
      isLoadCategories: isLoadCategories ?? this.isLoadCategories,
    );
  }
}
