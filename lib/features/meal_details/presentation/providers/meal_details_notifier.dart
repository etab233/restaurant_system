import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurants_system/features/auth/domain/repositories/auth_repository.dart';
import 'package:restaurants_system/features/auth/presentation/providers/auth_provider.dart';
import 'package:restaurants_system/features/meal_details/data/repositories/meal_details_repositories_impl.dart';
import 'package:restaurants_system/features/meal_details/domain/repositories/meal_details_repositories.dart';
import '../../data/datasources/meal_details_remote_data_source.dart';
import '../../data/models/meal_item_model.dart';
import 'meal_details_state.dart';

final mealDetailsRepositoryProvider = Provider<MealDetailsRepository>((ref) {
  return MealDetailsRepositoryImpl(MealDetailsRemoteDataSource());
});

final mealDetailsProvider = NotifierProvider<MealDetailsNotifier, MealState>(
  MealDetailsNotifier.new,
);

class MealDetailsNotifier extends Notifier<MealState> {
  late MealDetailsRepository _repository;
  late AuthRepository _authRepository;

  MealState _initialState() {
    return MealState(
      status: "",
      message: "",
      menuItem: MealItem.loading()
    );
  }

  @override
  MealState build() {
    _repository = ref.read(mealDetailsRepositoryProvider);
    _authRepository = ref.read(authRepositoryProvider);

    return _initialState();
  }

  Future<void> getMealDetails({
    required int restaurantId,
    required int mealId,
  }) async {
    // تصفير البيانات القديمة قبل بدء الطلب
    state = _initialState().copyWith(
      status: "loading",
      message: "loading data ..",
    );

    final result = await _repository.getMealDetails(
      restaurantId: restaurantId,
      mealId: mealId,
    );

    state = result.isSuccess
        ? state.copyWith(
            status: result.status,
            message: result.message,
            menuItem: result.meal,
          )
        : state.copyWith(status: result.status, message: result.message);
  }

  Future<void> getCartMealDetails({required int itemId}) async {
    state = state.copyWith(status: "loading");

    final token = await _authRepository.getCurrentToken();

    if (token == null) {
      state = state.copyWith(
        message: "Please login first",
        status: "unauthenticated",
      );
      return;
    }

    final result = await _repository.getCartMealDetails(
      itemId: itemId,
      token: token,
    );

    if (result.isSuccess) {
      state = state.copyWith(
        status: result.status,
        message: result.message,
        menuItem: result.meal,
      );
      loadCartItemData(result.meal!);
    } else {
      state = state.copyWith(status: result.status, message: result.message);
    }
  }

  void loadCartItemData(MealItem meal) {
    int variantId = -1;
    final variant = meal.variants.where((v) => v.selected);
    if (variant.isNotEmpty) {
      variantId = variant.first.id;
    }

    final Map<int, List<int>> modifiers = {};
    for (final group in meal.modifierGroups) {
      final selected = group.modifiers
          .where((m) => m.selected)
          .map((m) => m.id)
          .toList();
      if (selected.isNotEmpty) {
        modifiers[group.id] = selected;
      }
    }

    state = state.copyWith(
      quantity: meal.quantity,
      selectedVariantId: variantId,
      selectedModifier: modifiers,
      note: meal.description ?? "",
    );
  }

  void selectVariant(int variantId) {
    state = state.copyWith(selectedVariantId: variantId);
  }

  void toggleModifier(int groupId, int modifierId) {
    final group = state.menuItem.modifierGroups.firstWhere(
      (g) => g.id == groupId,
    );

    final current = Map<int, List<int>>.from(state.selectedModifier);
    final list = List<int>.from(current[groupId] ?? []);

    if (group.isMultiple) {
      if (list.contains(modifierId)) {
        list.remove(modifierId);
      } else if (list.length < group.maxSelections) {
        list.add(modifierId);
      }
    } else {
      list
        ..clear()
        ..add(modifierId);
    }

    current[groupId] = list;
    state = state.copyWith(selectedModifier: current);
  }

  void incrementQuantity() {
    state = state.copyWith(quantity: state.quantity + 1);
  }

  void decrementQuantity() {
    if (state.quantity > 1) {
      state = state.copyWith(quantity: state.quantity - 1);
    }
  }

  void setNote(String note) {
    state = state.copyWith(note: note);
  }
}
