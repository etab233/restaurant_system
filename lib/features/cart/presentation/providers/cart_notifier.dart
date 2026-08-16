import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurants_system/features/auth/domain/repositories/auth_repository.dart';
import 'package:restaurants_system/features/auth/presentation/providers/auth_provider.dart';
import 'package:restaurants_system/features/auth/presentation/providers/auth_state.dart';
import 'package:restaurants_system/features/cart/domain/repositories/cart_repository.dart';
import 'package:restaurants_system/features/cart/presentation/providers/cart_provider.dart';
import 'package:restaurants_system/features/cart/presentation/providers/cart_state.dart';

class CartNotifier extends Notifier<CartState> {
  late CartRepository _repository;
  late AuthRepository _authRepository;

  @override
  CartState build() {
    _repository = ref.read(cartRepositoryProvider);
    _authRepository = ref.read(authRepositoryProvider);

    ref.listen<AuthState>(authNotifierProvider, (previous, next) {
      final wasLoggedIn = previous?.isLoggedIn ?? false;
      if (!wasLoggedIn && next.isLoggedIn) {
        index();
      } else if (wasLoggedIn && !next.isLoggedIn) {
        state = state.copyWith(status: 'unauthenticated', items: []);
      }
    });

    return CartState(status: 'loading', items: []);
  }

  Future<void> addToCart({
    required String restaurantId,
    required String itemId,
    String? variantId,
    String? description,
    required int quantity,
    required List<Map<String, dynamic>> modifierSelections,
  }) async {
    state = state.copyWith(isAddingToCart: true);
    final token = await _authRepository.getCurrentToken();

    if (token == null) {
      state = state.copyWith(
        message: "Please login first",
        isAddingToCart: false,
        status: "unauthenticated",
      );
      return;
    }

    final result = await _repository.addToCart(
      restaurantId: restaurantId,
      itemId: itemId,
      variantId: variantId,
      description: description,
      quantity: quantity,
      modifierSelections: modifierSelections,
      token: token,
    );

    if (result.isSuccess) {
      //await index();

      state = state.copyWith(
        status: 'success',
        message: result.data!,
        isAddingToCart: false,
      );
    } else {
      state = state.copyWith(
        status: 'error',
        message: result.message,
        isAddingToCart: false,
      );
    }
  }

  Future<void> editAndAddToCart({
    required String restaurantId,
    required String itemId,
    required int cartId,
    String? variantId,
    String? description,
    required int quantity,
    required List<Map<String, dynamic>> modifierSelections,
  }) async {
    state = state.copyWith(isAddingToCart: true);

    final token = await _authRepository.getCurrentToken();

    if (token == null) {
      state = state.copyWith(
        message: "Please login first",
        isAddingToCart: false,
        status: "unauthenticated",
      );
      return;
    }

    final result = await _repository.editAndAddToCart(
      restaurantId: restaurantId,
      itemId: itemId,
      cartId: cartId,
      variantId: variantId,
      description: description,
      quantity: quantity,
      modifierSelections: modifierSelections,
      token: token,
    );
    if (!result.isSuccess) {
      state = state.copyWith(
        isAddingToCart: false,
        message: result.message,
        status: "error",
      );
      return;
    }

    await getRestaurantCart(restaurantId: int.tryParse(restaurantId) ?? 0);

    state = state.copyWith(
      isAddingToCart: false,
      message: result.data!,
      status: "success",
    );
  }

  Future<void> index() async {
    state = state.copyWith(status: 'loading');

    final token = await _authRepository.getCurrentToken();

    if (token == null) {
      state = state.copyWith(
        message: "Please login first",
        isAddingToCart: false,
        status: "unauthenticated",
      );
      return;
    }

    final result = await _repository.index(token: token);
    state = result.isSuccess
        ? state.copyWith(
            status: 'success',
            message: result.message,
            items: result.data!,
          )
        : state.copyWith(status: 'error', message: result.message);
  }

  Future<void> deleteCart({required int id}) async {
    state = state.copyWith(status: 'loading');

    final token = await _authRepository.getCurrentToken();

    if (token == null) {
      state = state.copyWith(
        message: "Please login first",
        isAddingToCart: false,
        status: "unauthenticated",
      );
      return;
    }

    final result = await _repository.deleteCart(token: token, id: id);
    if (result.isSuccess) {
      final updatedItems = state.items
          .where((item) => item.restaurantId != id)
          .toList();
      state = state.copyWith(
        status: 'success',
        message: result.message,
        items: updatedItems,
      );
    } else {
      state = state.copyWith(status: 'error', message: result.message);
    }
  }

  Future<void> getRestaurantCart({required int restaurantId}) async {
    state = state.copyWith(status: 'loading', cartContent: null);

    final token = await _authRepository.getCurrentToken();

    if (token == null) {
      state = state.copyWith(
        message: "Please login first",
        isAddingToCart: false,
        status: "unauthenticated",
      );
      return;
    }

    final result = await _repository.getRestaurantCart(
      restaurantId: restaurantId,
      token: token,
    );

    state = result.isSuccess
        ? state.copyWith(
            status: 'success',
            message: result.message,
            cartContent: result.data,
          )
        : state.copyWith(status: 'error', message: result.message);
  }

  Future<void> deleteItem({required int itemId}) async {
    state = state.copyWith(status: 'loading');

    final token = await _authRepository.getCurrentToken();

    if (token == null) {
      state = state.copyWith(
        message: "Please login first",
        isAddingToCart: false,
        status: "unauthenticated",
      );
      return;
    }

    final result = await _repository.deleteItem(token: token, itemId: itemId);
    if (result.isSuccess) {
      final updatedItems = state.cartContent?.item
          ?.where((item) => item.itemId != itemId)
          .toList();
      final deletedItem = state.cartContent?.item?.firstWhere(
        (item) => item.itemId == itemId,
      );
      final deletedPrice = double.tryParse(deletedItem?.lineTotal ?? '0') ?? 0;
      final currentSubtotal =
          double.tryParse(state.cartContent?.subtotal ?? '0') ?? 0;
      final newCart = state.cartContent?.copyWith(
        item: updatedItems,
        itemCount: (state.cartContent?.itemCount ?? 0) - 1,
        subtotal: (currentSubtotal - deletedPrice).toString(),
      );
      state = state.copyWith(
        status: 'success',
        message: result.message,
        cartContent: newCart,
      );
    } else {
      state = state.copyWith(status: 'error', message: result.message);
    }
  }

  Future<void> editeItemQuantity({
    required List<Map<String, dynamic>> items,
  }) async {
    state = state.copyWith(status: 'loading');

    final token = await _authRepository.getCurrentToken();

    if (token == null) {
      state = state.copyWith(
        message: "Please login first",
        isAddingToCart: false,
        status: "unauthenticated",
      );
      return;
    }

    final result = await _repository.editeItemQuantity(
      token: token,
      items: items,
    );
    state = state.copyWith(
      status: result.isSuccess ? 'success' : 'error',
      message: result.isSuccess ? result.data! : result.message,
    );
  }

  void updateQuantity({required int quantity, required int index}) {
    final updatedItems = [...state.cartContent!.item!];
    final unitPrice =
        (double.tryParse(updatedItems[index].lineTotal) ?? 0) /
        updatedItems[index].quantity;
    final newPrice = unitPrice * quantity;

    updatedItems[index] = updatedItems[index].copyWith(
      quantity: quantity,
      lineTotal: newPrice.toString(),
    );

    final subtotal = updatedItems.fold<double>(
      0,
      (sum, item) => sum + (double.tryParse(item.lineTotal) ?? 0),
    );

    state = state.copyWith(
      cartContent: state.cartContent?.copyWith(
        item: updatedItems,
        subtotal: subtotal.toString(),
      ),
    );
  }
}
