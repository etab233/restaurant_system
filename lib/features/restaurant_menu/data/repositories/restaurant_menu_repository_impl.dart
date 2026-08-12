import 'dart:convert';
import 'package:restaurants_system/core/location/domain/repositories/location_repository.dart';
import 'package:restaurants_system/features/home/data/models/category_model.dart';
import 'package:restaurants_system/features/home/data/models/restaurant_model.dart';
import '../datasources/restaurant_menu_remote_data_source.dart';
import '../../domain/repositories/restaurant_menu_repository.dart';

class RestaurantMenuRepositoryImpl implements RestaurantMenuRepository {
  final RestaurantMenuRemoteDataSource _remote;
  final LocationRepository _locationRepository;

  RestaurantMenuRepositoryImpl(this._remote, this._locationRepository);

  @override
  Future<RestaurantMenuResult> viewRestaurant(int restaurantId) async {
    try {
      final cachedLocation = _locationRepository.getCachedLocation();

      final result = await _remote.viewRestaurant(
        restaurantId: restaurantId,
        latitude: cachedLocation?.latitude,
        longitude: cachedLocation?.longitude,
      );
      final data = jsonDecode(result.body);

      if (result.statusCode == 200) {
        return RestaurantMenuResult.success(
          status: data["status"],
          message: data["message"] ?? '',
          restaurant: RestaurantModel.fromJson(data["data"]["restaurant"]),
          categories: (data["data"]["categories"] as List?)
              ?.map((e) => Category.fromJson(e))
              .toList(),
        );
      }
      return RestaurantMenuResult.failure(
        status: data["status"],
        message:
            data["message"] ??
            "An error occurred while fetching restaurant data",
      );
    } catch (e) {
      return RestaurantMenuResult.failure(
        status: "error",
        message:
            "An error has been occurred please try again later ${e.toString()}",
      );
    }
  }
}
