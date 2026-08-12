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

import 'dart:convert';
import '../datasources/home_local_data_source.dart';
import '../datasources/home_remote_data_source.dart';
import '../models/category_model.dart';
import '../models/restaurant_model.dart';
import '../../domain/repositories/home_repository.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource _remote;
  final HomeLocalDataSource _local;

  HomeRepositoryImpl(this._remote, this._local);

  @override
  HomeData getCachedHomeData() {
    return HomeData(
      categories: _local.getCachedCategories(),
      restaurants: _local.getCachedRestaurants(),
    );
  }

  @override
  Future<HomeResult> getHomeData({String? lat, String? lng}) async {
    try {
      final response = await _remote.getHomeData(lat: lat, lng: lng);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        final categories = ((data['data']['categories'] ?? []) as List)
            .map((e) => Category.fromJson(e))
            .toList();
        final restaurants = ((data['data']['restaurants'] ?? []) as List)
            .map((e) => RestaurantModel.fromJson(e))
            .toList();

        // خزن بالكاش قبل ما نرجع النتيجة
        await _local.cacheRestaurants(restaurants);
        await _local.cacheCategories(categories);

        return HomeResult.success(
          HomeData(categories: categories, restaurants: restaurants),
        );
      }

      // فشل الـ API بس مش exception - جرب ترجع الكاش
      return _fallbackToCache();
    } catch (e) {
      // فشل بسبب انقطاع الشبكة أو أي استثناء - جرب ترجع الكاش
      return _fallbackToCache();
    }
  }

  HomeResult _fallbackToCache() {
    final cached = getCachedHomeData();
    if (!cached.isEmpty) {
      return HomeResult.success(cached, isFromCache: true);
    }
    return HomeResult.failure();
  }
}