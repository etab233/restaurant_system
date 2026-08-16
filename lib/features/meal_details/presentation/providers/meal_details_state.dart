import '../../data/models/meal_item_model.dart';

enum MealDetailsStatus {
  initial,
  loading,
  success,
  error,
  unauthenticated,
}

class MealState {
  final MealDetailsStatus status;
  final String message;
  final MealItem menuItem;
  final int quantity;
  final int selectedVariantId;
  final Map<int, List<int>> selectedModifier;
  final String note;

  MealState({
    this.status= MealDetailsStatus.initial,
    required this.message,
    required this.menuItem,
    this.quantity = 1,
    this.selectedVariantId = -1,
    this.selectedModifier = const {},
    this.note = "",
  });

  MealState copyWith({
    MealDetailsStatus? status,
    String? message,
    MealItem? menuItem,
    int? quantity,
    int? selectedVariantId,
    Map<int, List<int>>? selectedModifier,
    String? note,
  }) {
    return MealState(
      status: status ?? this.status,
      message: message ?? this.message,
      menuItem: menuItem ?? this.menuItem,
      quantity: quantity ?? this.quantity,
      selectedVariantId: selectedVariantId ?? this.selectedVariantId,
      selectedModifier: selectedModifier ?? this.selectedModifier,
      note: note ?? this.note,
    );
  }

  double get totalPrice {
    double base = menuItem.price;

    if (selectedVariantId != -1 && menuItem.variants.isNotEmpty) {
      final v = menuItem.variants.firstWhere(
        (v) => v.id == selectedVariantId,
        orElse: () => menuItem.variants.first,
      );
      base = v.price;
    }

    double extras = 0;
    for (final group in menuItem.modifierGroups) {
      final selected = selectedModifier[group.id] ?? [];
      for (final modId in selected) {
        final mod = group.modifiers.firstWhere(
          (m) => m.id == modId,
          orElse: () => group.modifiers.first,
        );
        extras += mod.price;
      }
    }

    return (base + extras) * quantity;
  }
}
