import 'package:restaurants_system/features/home/data/models/category_model.dart';

abstract class AddRestaurantRepository {
  Future<RequestResult> sendRestaurantRequest({
    required String name,
    required String description,
    required String number,
    required String address,
    double? latitude,
    double? longitude,
    required List<int> categories,
    required String token,
  });

  Future<CategoriesResult> fetchCategories();
}

class RequestResult {
  final bool isSuccess;
  final String status;
  final String message;

  RequestResult.success({required this.status, required this.message}) : isSuccess = true;
  RequestResult.failure(this.message) : isSuccess = false, status = 'refused';
}

class CategoriesResult {
  final List<Category> categories;
  CategoriesResult({required this.categories});
}