import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurants_system/models/category_model.dart';
import 'package:restaurants_system/models/menu_item.dart';
import 'package:restaurants_system/models/restaurant_model.dart';
import 'package:restaurants_system/services/api/view_restaurant_service.dart';
import 'package:url_launcher/url_launcher.dart';

class RestaurantScreenState {
  final RestaurantModel? restaurant;
  final List<Category> categories;
  final bool isLoading;
  final String? message;
  final String? status;

  RestaurantScreenState({
    this.restaurant,
    this.categories = const [],
    this.isLoading = false,
    this.message,
    this.status,
  });

  RestaurantScreenState copyWith({
    RestaurantModel? restaurant,
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
      isLoading: true,
      message: "please wait while we fetch restaurant data",
      status: null,
    );
  }

  Future<void> viewRestaurant(int restaurantId) async {
    try {
      state = state.copyWith(isLoading: true);
      final result = await ref
          .read(viewRestaurantProvider)
          .viewRestaurant(restaurantId);
      final data = jsonDecode(result.body);
      if (result.statusCode == 200) {
        state = state.copyWith(
          restaurant: RestaurantModel.fromJson(data["data"]["restaurant"]),
          categories: (data["data"]["categories"] as List?)
              ?.map((e) => Category.fromJson(e))
              .toList(),
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
    } catch (e,s) {
      state = state.copyWith(
        isLoading: false,
        message:
            "An error has been occurred please try again later ${e.toString()}, $s",
        status: "error",
      );
      print("ERROR : $e, $s");
    }
  }
}

Future<void> openMap({required double lat, required double lng, required String name}) async {
  final Uri url = Uri.parse(
    'https://www.google.com/maps/search/?api=1&query=$name&center=$lat,$lng',
  );

  await launchUrl(url, mode: LaunchMode.externalApplication);
}

Future<void> makePhoneCall(String phoneNumber) async {
  final url = Uri(scheme: 'tel', path: phoneNumber);

  await launchUrl(url, mode: LaunchMode.externalApplication);
}

// ── Skeleton Data ────────────────────────────────────────────────────────────
class RestaurantSkeletonizer {
  static RestaurantScreenState get loadingData {
    final fakeCategories = List.generate(
      3,
      (categoryIndex) => Category(
        id: categoryIndex,
        name: "Category",
        menuItems: List.generate(
          5,
          (mealIndex) => MenuItem(
            itemId: mealIndex,
            restaurantId: 0,
            name: "loading category..",
            description: "loading description..",
            image: null,
            preparationTime: "00 min",
            isFeatured: true,
            price: 0.0,
            variants: [], 
            modifierGroups: []
          ),
        ),
      ),
    );

    return RestaurantScreenState(
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
        hours: RestaurantHours(
          opens: "00:00:00",
          closes: "00:00:00",
          isOpen: true,
        ),
        categories: fakeCategories,
        location: RestaurantLocation(
          latitude: 0,
          longitude: 0,
          distanceKm: null,
        ),
      ),
    );
  }
}
