class OrderDetailsResponse {
  final String status;
  final String message;
  final List<OrderDetailItem> data;

  OrderDetailsResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory OrderDetailsResponse.fromJson(Map<String, dynamic> json) {
    return OrderDetailsResponse(
      status: json['status'] ?? '',
      message: json['message'] ?? '',
      data: (json['data'] as List<dynamic>? ?? [])
          .map((e) => OrderDetailItem.fromJson(e))
          .toList(),
    );
  }
}

class OrderDetailItem {
  final String itemName;
  final String? variantName;
  final double unitPrice;
  final int quantity;
  final double lineTotal;
  final List<ModifierGroup> modifierGroups;

  OrderDetailItem({
    required this.itemName,
    this.variantName,
    required this.unitPrice,
    required this.quantity,
    required this.lineTotal,
    required this.modifierGroups,
  });

  factory OrderDetailItem.fromJson(Map<String, dynamic> json) {
    return OrderDetailItem(
      itemName: json['item_name'] ?? '',
      variantName: json['variant_name'],
      unitPrice: (json['unit_price'] ?? 0).toDouble(),
      quantity: json['quantity'] ?? 0,
      lineTotal: (json['line_total'] ?? 0).toDouble(),
      modifierGroups: (json['modifier_groups'] as List<dynamic>? ?? [])
          .map((e) => ModifierGroup.fromJson(e))
          .toList(),
    );
  }
}

class ModifierGroup {
  final String name;
  final List<Modifier> modifiers;

  ModifierGroup({required this.name, required this.modifiers});

  factory ModifierGroup.fromJson(Map<String, dynamic> json) {
    return ModifierGroup(
      name: json['name'] ?? '',
      modifiers: (json['modifiers'] as List<dynamic>? ?? [])
          .map((e) => Modifier.fromJson(e))
          .toList(),
    );
  }
}

class Modifier {
  final String modifierName;
  final double price;

  Modifier({required this.modifierName, required this.price});

  factory Modifier.fromJson(Map<String, dynamic> json) {
    return Modifier(
      modifierName: json['modifier_name'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
    );
  }
}