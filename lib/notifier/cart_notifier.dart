import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurants_system/models/cart_item.dart';
import 'package:restaurants_system/services/api/cart_services.dart';

class CartState {
  final String status;
  final String message;
  final List<CartItem> items;

  CartState({required this.status, this.message = '', this.items = const []});

  CartState copyWith({String? status, String? message, List<CartItem>? items}) {
    return CartState(
      status: status ?? this.status,
      message: message ?? this.message,
      items: items ?? this.items,
    );
  }
}

class CartNotifier extends Notifier<CartState> {
  late CartServices _cartServices;

  @override
  CartState build() {
    _cartServices = CartServices();

    return CartState(status: 'loading', message: '');
  }

  Future<void> addToCart({
    required String restaurantId,
    required String itemId,
    String? variantId,
    String? description,
    required int quantity,
    required List<Map<String, dynamic>> modifierSelections,
    required String token,
  }) async {
    state = state.copyWith(status: 'idle');
    try {
      final result = await _cartServices.addToCart(
        restaurantId: restaurantId,
        itemId: itemId,
        variantId: variantId,
        description: description,
        quantity: quantity,
        modifierSelections: modifierSelections,
        token: token,
      );
      if (result.statusCode == 200 || result.statusCode == 201) {
        final data = json.decode(result.body);
        state = state.copyWith(
          status: data['status'],
          message: data['message'],
        );
      } else {
        final data = json.decode(result.body);
        String errorMessage = "Unknown error";
        if (data['errors'] != null) {
          errorMessage = (data['errors'].values.first as List).first.toString();
        } else if (data['error'] != null) {
          errorMessage = data['error'].toString();
        } else if (data['message'] != null) {
          errorMessage = data['message'].toString();
        }
        state = state.copyWith(status: data['status'], message: errorMessage);
      }
    } catch (e) {
      state = state.copyWith(status: 'error', message: 'An error occured $e');
    }
  }
}
