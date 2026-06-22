// يستخدم في صفحة restaurant Cart
class CartContent {
  final List<Item>? item;
  final int? itemCount;
  final String? subtotal;
  final bool hasDelivery;
  final String? shamCachAccountBarcode;
  final String? shamCachAccountId;

  CartContent({
    this.item,
    this.itemCount,
    this.subtotal,
    required this.hasDelivery,
    this.shamCachAccountBarcode,
    this.shamCachAccountId,
  });

  factory CartContent.fromJson(Map<String, dynamic> json) {
    return CartContent(
      item:
          (json["cart_items"] as List?)
              ?.map((item) => Item.fromJson(item))
              .toList() ??
          [],
      itemCount: json['summary']['items_count'],
      subtotal: json['summary']['subtotal'],
      hasDelivery: json["has_delivery"],
      shamCachAccountBarcode: json["sham_cach_account_barcode"],
      shamCachAccountId: json["sham_cach_account_id"],
    );
  }

  CartContent copyWith({
    List<Item>? item,
    int? itemCount,
    String? subtotal,
    bool? hasDelivery,
    String? shamCachAccountBarcode,
    String? shamCachAccountId,
  }) {
    return CartContent(
      item: item ?? this.item,
      itemCount: itemCount ?? this.itemCount,
      subtotal: subtotal ?? this.subtotal,
      hasDelivery: hasDelivery ?? this.hasDelivery,
      shamCachAccountBarcode:
          shamCachAccountBarcode ?? this.shamCachAccountBarcode,
      shamCachAccountId: shamCachAccountId ?? this.shamCachAccountId,
    );
  }
}

class Item {
  final int itemId;
  final String itemName;
  final String? variantName;
  final int quantity;
  final String lineTotal;
  final String? modifiers;

  Item({
    required this.itemId,
    required this.itemName,
    this.variantName,
    required this.quantity,
    required this.lineTotal,
    this.modifiers,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      itemId: json["item_id"],
      itemName: json["item_name"],
      variantName: json["variant_name"],
      quantity: json["quantity"],
      lineTotal: json["line_total"],
      modifiers: json["modifiers_summary"],
    );
  }

  Item copyWith({
    int? itemId,
    String? itemName,
    String? variantName,
    int? quantity,
    String? lineTotal,
    String? modifiers,
  }) {
    return Item(
      itemId: itemId ?? this.itemId,
      itemName: itemName ?? this.itemName,
      variantName: variantName ?? this.variantName,
      quantity: quantity ?? this.quantity,
      lineTotal: lineTotal ?? this.lineTotal,
      modifiers: modifiers ?? this.modifiers,
    );
  }
}
