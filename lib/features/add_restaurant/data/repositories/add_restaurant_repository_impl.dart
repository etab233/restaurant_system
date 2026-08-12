import 'dart:convert';
import 'package:restaurants_system/features/add_restaurant/data/datasources/add_restaurant_remote_data_source.dart';
import 'package:restaurants_system/features/add_restaurant/domain/repositories/add_restaurant_repository.dart';
import 'package:restaurants_system/features/home/data/datasources/category_local_data.dart';
import 'package:restaurants_system/features/home/data/models/category_model.dart';

class AddRestaurantRepositoryImpl implements AddRestaurantRepository {
  final AddRestaurantRemoteDataSource _remote;
  final CategoryLocalData _categoryLocal;

  AddRestaurantRepositoryImpl(this._remote, this._categoryLocal);

  @override
  Future<RequestResult> sendRestaurantRequest({
    required String name,
    required String description,
    required String number,
    required String address,
    double? latitude,
    double? longitude,
    required List<int> categories,
    required String token,
  }) async {
    try {
      final result = await _remote.sendRestaurantRequest(
        name: name,
        description: description,
        number: number,
        address: address,
        latitude: latitude,
        longitude: longitude,
        categories: categories,
        token: token,
      );
      final data = json.decode(result.body);

      if (result.statusCode == 200) {
        return RequestResult.success(
          status: data['data']?['status'] ?? "",
          message: data['message'] ?? "",
        );
      }

      if (data['errors'] != null && data['errors'] is Map) {
        final Map<String, dynamic> errors = data['errors'];
        return RequestResult.failure(errors.values.first[0]);
      }
      return RequestResult.failure(data['message'] ?? "try again please..");
    } catch (e) {
      return RequestResult.failure("try again please..");
    }
  }

  @override
  Future<CategoriesResult> fetchCategories() async {
    final cached = _categoryLocal.getCachedCategories();
    try {
      final response = await _remote.fetchCategories();
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List categoriesList = data['data'];
        final loaded = categoriesList.map((item) => Category.fromJson(item)).toList();
        return CategoriesResult(categories: loaded);
      }
      return CategoriesResult(categories: cached);
    } catch (e) {
      return CategoriesResult(categories: cached);
    }
  }
}