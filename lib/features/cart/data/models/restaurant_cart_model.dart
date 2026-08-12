class RestaurantCart {
  final String tenantId;
  final int restaurantId;
  final String restaurantName;
  final String? logo;
  final int itemCount;
  final String subtotal;
  final List<SummaryItem> items;

  RestaurantCart({
    required this.tenantId,
    required this.restaurantId,
    required this.restaurantName,
    this.logo,
    required this.itemCount,
    required this.subtotal,
    required this.items,
  });

  factory RestaurantCart.fromJson(Map<String, dynamic> json) {
    return RestaurantCart(
      tenantId: json['tenant_id'],
      restaurantId: json['restaurant_id'],
      restaurantName: json['restaurant_name'],
      logo: json['restaurant_logo'],
      itemCount: json['item_count'],
      subtotal: json['subtotal'],
      items: (json['items'] as List)
          .map((item) => SummaryItem.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}

class SummaryItem{
  final String itemName; 
  final String? variantName;
  final int quantity;
  final String? modifiersSummary;

  SummaryItem({
    required this.itemName, 
    this.variantName, 
    required this.quantity, 
    this.modifiersSummary
  });

  factory SummaryItem.fromJson(Map<String,dynamic> json){
    return SummaryItem(
      itemName: json['item_name'], 
      variantName: json['variant_name'], 
      quantity: json['quantity'], 
      modifiersSummary: json['modifiers_summary']
    );
  }
}
