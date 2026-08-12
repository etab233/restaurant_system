import 'package:restaurants_system/features/cart/data/models/cart_content_model.dart';
import 'package:restaurants_system/features/cart/data/models/restaurant_cart_model.dart';


abstract class CartRepository{
  Future<CartResult<String>> addToCart({
    required String restaurantId,
    required String itemId,
    String? variantId,
    String? description,
    required int quantity,
    required List<Map<String, dynamic>> modifierSelections,
    required String token,
  });

  Future<CartResult<String>> editAndAddToCart({
    required String restaurantId,
    required String itemId,
    required int cartId,
    String? variantId,
    String? description,
    required int quantity,
    required List<Map<String, dynamic>> modifierSelections,
    required String token,
  });

  Future<CartResult<List<RestaurantCart>>> index({required String token});

  Future<CartResult<void>> deleteCart({required String token, required int id});

  Future<CartResult<CartContent>> getRestaurantCart({
    required int restaurantId,
    required String token,
  });

  Future<CartResult<void>> deleteItem({required String token, required int itemId});

  Future<CartResult<String>> editeItemQuantity({
    required String token,
    required List<Map<String, dynamic>> items,
  });
}

/// نتيجة موحّدة بدل ما كل method يرجع Response خام
class CartResult<T> {
  final bool isSuccess;
  final T? data;
  final String message;

  CartResult.success(this.data, {this.message = ''}) : isSuccess = true;
  CartResult.failure(this.message) : isSuccess = false, data = null;
}