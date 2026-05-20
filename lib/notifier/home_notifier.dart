import 'package:restaurants_system/data/local/category_local_data.dart';
import 'package:restaurants_system/data/local/restaurant_local_data.dart';
import 'package:restaurants_system/models/category_model.dart';
import 'package:restaurants_system/models/restaurant_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurants_system/services/api/home_services.dart';
import 'dart:convert';
/*
            ┌──────────────────────┐
            │   App Starts (Home)  │
            └─────────┬────────────┘
                      │
                      ▼
        ┌────────────────────────────┐
        │ Load Cached Data (Hive)    │
        └─────────┬──────────────────┘
                  │
        ┌─────────▼─────────┐
        │ Cache Exists ?    │
        └──────┬─────┬──────┘
               │Yes  │No
               │     │
               ▼     ▼
┌──────────────────┐   ┌──────────────────┐
│ Show Cached Data │   │ Show Loading UI  │
└─────────┬────────┘   └─────────┬────────┘
          │                      │
          └──────────┬───────────┘
                     ▼
        ┌────────────────────────────┐
        │ Call API (HomeService)     │
        └─────────┬──────────────────┘
                  ▼
        ┌────────────────────────────┐
        │ API Success ?              │
        └──────┬───────────┬────────┘
               │Yes        │No
               ▼           ▼
 ┌────────────────────┐   ┌────────────────────┐
 │ Parse Response      │   │ Keep Cached Data   │
 │ Update State        │   │
 └─────────┬──────────┘   └────────────────────┘
           ▼
 ┌────────────────────┐
 │ Save to Hive       │
 └────────────────────┘
           ▼
 ┌────────────────────┐
 │ Update UI          │
 └────────────────────┘
 */

class HomeState {
  final String status;
  final List<Category> categories;
  final List<RestaurantModel>? restaurants;

  const HomeState({
    required this.status,
    required this.categories,
    required this.restaurants,
  });

  HomeState copyWith({
    String? status,
    List<Category>? categories,
    List<RestaurantModel>? restaurants,
  }) {
    return HomeState(
      status: status ?? this.status,
      categories: categories ?? this.categories,
      restaurants: restaurants ?? this.restaurants,
    );
  }
}

class HomeNotifier extends Notifier<HomeState> {
  late HomeServices _homeServices;
  @override
  HomeState build() {
    _homeServices = HomeServices();
    return HomeState(status: "", categories: [], restaurants: []);
  }

  Future<void> getHomeData({String? lat, String? lng}) async {
    final localData = RestaurantLocalData();
    final categoryLocal = CategoryLocalData();

    final cachedRestaurants = localData.getCachedRestaurants();
    final cachedCategories = categoryLocal.getCachedCategories();

    if (cachedRestaurants.isNotEmpty || cachedCategories.isNotEmpty) {
      state = state.copyWith(
        status: 'success',
        restaurants: cachedRestaurants,
        categories: cachedCategories,
      );
    } else {
      state = state.copyWith(status: 'loading');
    }
    try {
      final result = await _homeServices.getHomeData(lat: lat, lng: lng);
      if (result.statusCode == 200) {
        final data = json.decode(result.body);
        final categories = (data['data']['categories'] as List)
            .map((e) => Category.fromJson(e))
            .toList();

        final restaurants = (data['data']['restaurants'] as List)
            .map((e) => RestaurantModel.fromJson(e))
            .toList();

        // خزن بالكاش
        await localData.cacheRestaurants(restaurants);
        await categoryLocal.cacheCategories(categories);

        state = state.copyWith(
          status: 'success',
          categories: categories,
          restaurants: restaurants,
        );
      } else {
        final cachedR = localData.getCachedRestaurants();
        final cachedC = categoryLocal.getCachedCategories();

        if (cachedR.isNotEmpty || cachedC.isNotEmpty) {
          state = state.copyWith(
            status: 'success',
            restaurants: cachedR,
            categories: cachedC,
          );
        } else {
          state = state.copyWith(status: 'false');
        }
      }
    } catch (e) {
      final cachedR = localData.getCachedRestaurants();
      final cachedC = categoryLocal.getCachedCategories();

      if (cachedR.isNotEmpty || cachedC.isNotEmpty) {
        state = state.copyWith(
          status: 'success',
          restaurants: cachedR,
          categories: cachedC,
        );
      } else {
        state = state.copyWith(status: 'false');
      }
    }
  }
}

// ── Skeleton Data ─────────────────────────────────────────────
// لاستخدامه أثناء تحميل البيانات فقط
class SkeletonData {
  static List<Category> get categories =>
      List.generate(7, (i) => Category(id: i, name: 'Category $i'));

  static List<RestaurantModel> get restaurants => List.generate(
    4,
    (i) => RestaurantModel(
      id: i,
      name: 'Restaurant $i',
      description: 'Loading description...',
      address: 'Loading address...',
      phone: '0000000000',
      logo: null,
      coverImage: null,
      hours: RestaurantHours(
        opens: '09:00:00',
        closes: '23:00:00',
        isOpen: true,
      ),
      location: RestaurantLocation(latitude: 0, longitude: 0, distanceKm: null),
      categories: [],

      rate: 4,
    ),
  );
}

class SkeletonHomeState {
  final String status = 'success';
  final List<Category> categories = SkeletonData.categories;
  final List<RestaurantModel> restaurants = SkeletonData.restaurants;
}
