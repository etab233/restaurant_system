import 'package:restaurants_system/features/home/data/models/category_model.dart';
import 'package:restaurants_system/features/home/data/models/restaurant_model.dart';
import 'package:restaurants_system/features/meal_details/data/models/meal_item_model.dart';

class RestaurantMenuState {
  final RestaurantModel? restaurant;
  final List<Category> categories;
  final bool isLoading;
  final String? message;
  final String? status;

  RestaurantMenuState({
    this.restaurant,
    this.categories = const [],
    this.isLoading = false,
    this.message,
    this.status,
  });

  RestaurantMenuState copyWith({
    RestaurantModel? restaurant,
    List<Category>? categories,
    bool? isLoading,
    String? message,
    String? status,
  }) {
    return RestaurantMenuState(
      restaurant: restaurant ?? this.restaurant,
      categories: categories ?? this.categories,
      isLoading: isLoading ?? this.isLoading,
      message: message ?? this.message,
      status: status ?? this.status,
    );
  }
}

// ── Skeleton Data ────────────────────────────────────────────
class RestaurantSkeletonizer {
  static RestaurantMenuState get loadingData {
    final fakeCategories = List.generate(
      3,
      (categoryIndex) => Category(
        id: categoryIndex,
        name: "Category",
        menuItems: List.generate(
          5,
          (mealIndex) => MealItem(
            itemId: mealIndex,
            restaurantId: 0,
            name: "loading category..",
            description: "loading description..",
            image: null,
            preparationTime: "00 min",
            isFeatured: true,
            price: 0.0,
            variants: [],
            modifierGroups: [],
          ),
        ),
      ),
    );

    return RestaurantMenuState(
      isLoading: true,
      restaurant: RestaurantModel(
        id: 1,
        name: "restaurant",
        description: "Loading description...",
        address: "Loading address...",
        phone: "00000000000",
        coverImage: null,
        logo: null,
        rate: 4,
        hours: RestaurantHours(opens: "00:00:00", closes: "00:00:00", isOpen: true),
        categories: fakeCategories,
        location: RestaurantLocation(latitude: 0, longitude: 0, distanceKm: null),
      ),
    );
  }
}