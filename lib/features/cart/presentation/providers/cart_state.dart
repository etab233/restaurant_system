import 'package:restaurants_system/features/cart/data/models/cart_content_model.dart';
import 'package:restaurants_system/features/cart/data/models/restaurant_cart_model.dart';

class CartState {
  final String status;
  final bool isAddingToCart;
  final String message;
  final List<RestaurantCart> items;
  final CartContent? cartContent;

  CartState({
    required this.status,
    this.isAddingToCart = false,
    this.message = '',
    this.items = const [],
    this.cartContent,
  });

  CartState copyWith({
    String? status,
    String? message,
    bool? isAddingToCart,
    List<RestaurantCart>? items,
    CartContent? cartContent,
  }) {
    return CartState(
      status: status ?? this.status,
      message: message ?? this.message,
      isAddingToCart: isAddingToCart ?? this.isAddingToCart,
      items: items ?? this.items,
      cartContent: cartContent ?? this.cartContent,
    );
  }
}