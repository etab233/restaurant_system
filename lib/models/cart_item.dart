class CartItem {
  final int id;
  final String itemId;
  final String itemName;
  final String? variantId;
  final String? variantName;
  final String unitPrice;
  final String? description;
  final int quantity;
  final List<CartModifierSelection>? modifierSelections;

  CartItem({
    required this.id,
    required this.itemId,
    required this.itemName,
    this.variantId,
    this.variantName,
    this.description,
    required this.unitPrice,
    required this.quantity,
    this.modifierSelections,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'],
      itemId: json['item_id'],
      itemName: json['item_name'],
      variantId: json['variant_id'],
      variantName: json['variant_name'],
      description: json['special_note'],
      unitPrice:  json['unit_price'],
      quantity: json['quantity'],
      modifierSelections:
          (json['modifier_selections'] as List?)
              ?.map(
                (modifier) => CartModifierSelection.fromJson(
                  modifier as Map<String, dynamic>,
                ),
              )
              .toList() ?? []
    );
  }
}

class CartModifierSelection {
  final int modifierGroupId;
  final String modifierGroupName;

  final int modifierId;
  final String modifierName;

  final double price;

  CartModifierSelection({
    required this.modifierGroupId,
    required this.modifierGroupName,

    required this.modifierId,
    required this.modifierName,

    required this.price,
  });

  factory CartModifierSelection.fromJson(Map<String, dynamic> json) {
    return CartModifierSelection(
      modifierGroupId: json['modifier_group_id'],
      modifierGroupName: json['modifier_group_name'],

      modifierId: json['modifier_id'],
      modifierName: json['modifier_name'],

      price:  double.parse(json['unit_price'].toString()),
    );
  }
}
