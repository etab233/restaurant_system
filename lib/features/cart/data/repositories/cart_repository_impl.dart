import 'dart:convert';

import 'package:restaurants_system/features/cart/data/datasources/cart_remote_data_source.dart';
import 'package:restaurants_system/features/cart/data/models/cart_content_model.dart';
import 'package:restaurants_system/features/cart/data/models/restaurant_cart_model.dart';
import 'package:restaurants_system/features/cart/domain/repositories/cart_repository.dart';

class CartRepositoryImpl implements CartRepository {
  final CartRemoteDataSource _dataSource;

  CartRepositoryImpl(this._dataSource);

  String _extractError(Map<String, dynamic> data) {
    if (data['errors'] != null) {
      return (data['errors'].values.first as List).first.toString();
    } else if (data['error'] != null) {
      return data['error'].toString();
    } else if (data['message'] != null) {
      return data['message'].toString();
    }
    return "Unknown error";
  }

  @override
  Future<CartResult<String>> addToCart({
    required String restaurantId,
    required String itemId,
    String? variantId,
    String? description,
    required int quantity,
    required List<Map<String, dynamic>> modifierSelections,
    required String token,
  }) async {
    try {
      final response = await _dataSource.addToCart(
        restaurantId: restaurantId,
        itemId: itemId,
        variantId: variantId,
        description: description,
        quantity: quantity,
        modifierSelections: modifierSelections,
        token: token,
      );
      final data = json.decode(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return CartResult.success(data['message'] as String);
      }
      return CartResult.failure(_extractError(data));
    } catch (e) {
      return CartResult.failure('An error occurred: $e');
    }
  }

  @override
  Future<CartResult<List<RestaurantCart>>> index({
    required String token,
  }) async {
    try {
      final response = await _dataSource.index(token: token);
      final data = json.decode(response.body);
      if (response.statusCode == 200) {
        final items = (data['data'] as List)
            .map((r) => RestaurantCart.fromJson(r as Map<String, dynamic>))
            .toList();
        return CartResult.success(items, message: data['message'] ?? '');
      }
      return CartResult.failure(_extractError(data));
    } catch (e) {
      return CartResult.failure('An error occurred: $e');
    }
  }

  @override
  Future<CartResult<CartContent>> getRestaurantCart({
    required int restaurantId,
    required String token,
  }) async {
    try {
      final response = await _dataSource.getRestaurantCart(
        restaurantId: restaurantId,
        token: token,
      );
      final data = json.decode(response.body);
      if (response.statusCode == 200) {
        return CartResult.success(
          CartContent.fromJson(data['data'] as Map<String, dynamic>),
          message: data['message'] ?? '',
        );
      }
      return CartResult.failure(_extractError(data));
    } catch (e) {
      return CartResult.failure('An error occurred: $e');
    }
  }

  @override
  Future<CartResult<void>> deleteCart({
    required String token,
    required int id,
  }) async {
    try {
      final response = await _dataSource.deleteCart(token: token, id: id);
      final data = json.decode(response.body);
      if (response.statusCode == 200) {
        return CartResult.success(null, message: data['message'] ?? '');
      }
      return CartResult.failure(_extractError(data));
    } catch (e) {
      return CartResult.failure('An error occurred: $e');
    }
  }

  @override
  Future<CartResult<void>> deleteItem({
    required String token,
    required int itemId,
  }) async {
    try {
      final response = await _dataSource.deleteItem(
        token: token,
        itemId: itemId,
      );
      final data = json.decode(response.body);
      if (response.statusCode == 200) {
        return CartResult.success(null, message: data['message'] ?? '');
      }
      return CartResult.failure(_extractError(data));
    } catch (e) {
      return CartResult.failure('An error occurred: $e');
    }
  }

  @override
  Future<CartResult<String>> editeItemQuantity({
    required String token,
    required List<Map<String, dynamic>> items,
  }) async {
    try {
      final response = await _dataSource.editeItemQuantity(
        token: token,
        items: items,
      );
      final data = json.decode(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return CartResult.success(data['message'] as String);
      }
      return CartResult.failure(_extractError(data));
    } catch (e) {
      return CartResult.failure('An error occurred: $e');
    }
  }

  @override
  Future<CartResult<String>> editAndAddToCart({
    required String restaurantId,
    required String itemId,
    required int cartId,
    String? variantId,
    String? description,
    required int quantity,
    required List<Map<String, dynamic>> modifierSelections,
    required String token,
  }) async {
    try {
      final response = await _dataSource.editAndAddToCart(
        restaurantId: restaurantId,
        itemId: itemId,
        cartId: cartId,
        variantId: variantId,
        description: description,
        quantity: quantity,
        modifierSelections: modifierSelections,
        token: token,
      );
      final data = json.decode(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return CartResult.success(data['message'] as String);
      }
      return CartResult.failure(_extractError(data));
    } catch (e) {
      return CartResult.failure('An error occurred: $e');
    }
  }
}
