import 'dart:convert';
import '../datasources/restaurant_by_category_remote_data_source.dart';
import '../models/restaurant_by_category_model.dart';
import '../../domain/repositories/restaurant_by_category_repository.dart';

class RestaurantByCategoryRepositoryImpl implements RestaurantByCategoryRepository {
  final RestaurantByCategoryRemoteDataSource _remote;

  RestaurantByCategoryRepositoryImpl(this._remote);

  @override
  Future<RestaurantByCategoryResult> fetchRestaurantsByCategory(int categoryId) async {
    try {
      final response = await _remote.fetchRestaurantsByCategory(categoryId);
      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final restaurants = (data["data"]["restaurants"] as List)
            .map((e) => RestaurantByCategoryModel.fromJson(e))
            .toList();

        return RestaurantByCategoryResult.success(
          restaurants: restaurants,
          status: data["status"],
        );
      }
      return RestaurantByCategoryResult.failure(
        status: data["status"],
        message: data["message"],
      );
    } catch (e) {
      return RestaurantByCategoryResult.failure(
        status: "error",
        message: "An error occurred while fetching data",
      );
    }
  }
}