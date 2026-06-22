import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurants_system/models/carts/cart_content_model.dart';
import 'package:restaurants_system/models/carts/restaurant_cart_model.dart';
import 'package:restaurants_system/services/api/cart_services.dart';

class CartState {
  final String status;
  final bool isAddingToCart; 
  final String message;
  final List<RestaurantCart> items;
  final CartContent? cartContent;
  final PlatformFile? paymentFile;

  CartState({
    required this.status,
    this.isAddingToCart= false,
    this.message = '',
    this.items = const [],
    this.cartContent,
    this.paymentFile,
  });

  CartState copyWith({
    String? status,
    String? message,
    bool? isAddingToCart,
    List<RestaurantCart>? items,
    CartContent? cartContent,
    PlatformFile? paymentFile,
  }) {
    return CartState(
      status: status ?? this.status,
      message: message ?? this.message,
      isAddingToCart: isAddingToCart ?? this.isAddingToCart,
      items: items ?? this.items,
      cartContent: cartContent ?? this.cartContent,
      paymentFile: paymentFile,
    );
  }
}

class CartNotifier extends Notifier<CartState> {
  late CartServices _cartServices;

  @override
  CartState build() {
    _cartServices = CartServices();

    return CartState(status: 'loading', message: '', items: []);
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
    state = state.copyWith(isAddingToCart: true);
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
          isAddingToCart: false,
          message: data['message'],
        );
        // تحديث بيانات الحالة
        await index(token: token);
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
        state = state.copyWith(isAddingToCart: false, message: errorMessage);
      }
    } catch (e) {
      state = state.copyWith(isAddingToCart: false, message: 'An error occured $e');
    }
  }

  Future<void> index({required String token}) async {
    state = state.copyWith(status: 'loading');
    try {
      final response = await _cartServices.index(token: token);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        state = state.copyWith(
          status: data['status'],
          message: data['message'],
          items: (data['data'] as List)
              .map(
                (restaurant) =>
                    RestaurantCart.fromJson(restaurant as Map<String, dynamic>),
              )
              .toList(),
        );
      } else {
        final data = json.decode(response.body);
        state = state.copyWith(status: data['status'], message: data['error']);
      }
    } catch (e) {
      state = state.copyWith(status: 'error', message: 'an error occured $e');
    }
  }

  Future<void> deleteCart({required String token, required int id}) async {
    state = state.copyWith(status: 'loading');
    try {
      final response = await _cartServices.deleteCart(token: token, id: id);
      final data = json.decode(response.body);
      if (response.statusCode == 200) {
        final updatedItems = state.items
            .where((item) => item.restaurantId != id)
            .toList();

        state = state.copyWith(
          status: data['status'],
          message: data['message'],
          items: updatedItems,
        );
      } else {
        state = state.copyWith(status: "error", message: data['message']);
      }
    } catch (e) {
      state = state.copyWith(status: "error", message: 'an error occured $e');
    }
  }

  Future<void> getRestaurantCart({
    required int restaurantId,
    required String token,
  }) async {
    state = state.copyWith(status: "loading", cartContent: null);
    try {
      final response = await _cartServices.getRestaurantCart(
        restaurantId: restaurantId,
        token: token,
      );
      final data = json.decode(response.body);

      if (response.statusCode == 200) {
        state = state.copyWith(
          status: data['status'],
          message: data['message'],
          cartContent: CartContent.fromJson(
            data['data'] as Map<String, dynamic>,
          ),
        );
      } else {
        state = state.copyWith(status: "error", message: data['error']);
      }
    } catch (e) {
      state = state.copyWith(status: "error", message: 'an error occured $e');
    }
  }

  void updateQuantity({required int quantity, required int index}) {
    final updatedItems = [...state.cartContent!.item!];

    final price = double.tryParse(updatedItems[index].lineTotal);
    final newPrice = (price! / (updatedItems[index].quantity)) * quantity;

    updatedItems[index] = updatedItems[index].copyWith(
      quantity: quantity,
      lineTotal: newPrice.toString(),
    );

    final subtotal = updatedItems.fold<double>(
      0,
      (sum, item) => sum += double.tryParse(item.lineTotal) ?? 0,
    );

    final updatedCart = state.cartContent?.copyWith(
      item: updatedItems,
      subtotal: subtotal.toString(),
    );

    state = state.copyWith(cartContent: updatedCart);
  }

  Future<void> deleteItem({required String token, required int itemId}) async {
    state = state.copyWith(status: 'loading');
    try {
      final response = await _cartServices.deleteItem(
        token: token,
        itemId: itemId,
      );
      final data = json.decode(response.body);

      if (response.statusCode == 200) {
        final updatedItems = state.cartContent?.item
            ?.where((item) => item.itemId != itemId)
            .toList();

        final updatedItemCount = (state.cartContent?.itemCount ?? 0) - 1;

        final deletedItem = state.cartContent?.item?.firstWhere(
          (item) => item.itemId == itemId,
        );
        final deletedPrice =
            double.tryParse(deletedItem?.lineTotal ?? '0') ?? 0;

        final currentSubtotal =
            double.tryParse(state.cartContent?.subtotal ?? '0') ?? 0;

        final newSubtotal = currentSubtotal - deletedPrice;

        final newCart = state.cartContent?.copyWith(
          item: updatedItems,
          itemCount: updatedItemCount,
          subtotal: newSubtotal.toString(),
        );

        state = state.copyWith(
          status: data['status'],
          message: data['message'],
          cartContent: newCart,
        );
      } else {
        state = state.copyWith(status: 'error', message: data['message']);
      }
    } catch (e) {
      state = state.copyWith(status: "error", message: 'an error occured $e');
    }
  }

  Future<void> editeItemQuantity({
    required String token,
    required List<Map<String, dynamic>> items,
  }) async {
    state = state.copyWith(status: "loading");
    try {
      final response = await _cartServices.editeItemQuantity(
        token: token,
        items: items,
      );
      final data = json.decode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        state = state.copyWith(
          message: data['message'],
          status: data['status'],
        );
      } else {
        state = state.copyWith(message: data['message'], status: data['error']);
      }
    } catch (e) {
      state = state.copyWith(status: "error", message: 'an error occured $e');
    }
  }

  void setPaymentFile(PlatformFile file) {
    state = state.copyWith(paymentFile: file);
  }

  void removePaymentFile() {
    state = state.copyWith(paymentFile: null);
  }
}
