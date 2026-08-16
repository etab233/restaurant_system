class MealItem {
  final int itemId;
  final int restaurantId;
  final String name;
  final bool isNutritionallyAnalyzed;
  final String? description;
  final String? image;
  final bool isFeatured;
  final String preparationTime;
  final double price;
  final int? cartId;
  final int quantity;
  final List<Variant> variants;
  final List<ModifierGroup> modifierGroups;

  MealItem({
    required this.itemId,
    required this.restaurantId,
    required this.name,
    this.description,
    this.isNutritionallyAnalyzed = false,
    this.image,
    required this.isFeatured,
    required this.preparationTime,
    required this.price,
    this.cartId,
    this.quantity = 1,
    required this.variants,
    required this.modifierGroups,
  });

  factory MealItem.fromJson(Map<String, dynamic> json) {
    return MealItem(
      itemId: json["item"]?["id"] ?? json["item_id"] ?? json["id"] ?? 0,
      cartId: json["cart_id"],
      restaurantId: json["restaurant_id"] ?? 0,
      name: json["item"]?["name"] ?? json["item_name"] ?? json["name"] ?? "",
      description: json["item"]?["description"] ?? json["description"],
      isNutritionallyAnalyzed: json["is_nutritionally_analyzed"] ?? false,
      image: json["image"],
      isFeatured: json["is_featured"] ?? false,
      quantity: json["quantity"] ?? 1,
      preparationTime:
          (json["preparation_time"] ?? json["item"]?["preparation_time"] ?? 0)
              .toString(),
      price: json["price"] != null
          ? double.tryParse(json["price"].toString()) ?? 0
          : json["item"]?["price"] != null
          ? double.tryParse(json["item"]["price"].toString()) ?? 0
          : 0,
      variants: (json["variants"] as List? ?? [])
          .map((e) => Variant.fromJson(e))
          .toList(),
      modifierGroups: (json["modifier_groups"] as List? ?? [])
          .map((e) => ModifierGroup.fromJson(e))
          .toList(),
    );
  }

  factory MealItem.loading() {
    return MealItem(
      itemId: 0,
      restaurantId: 0,
      name: 'Loading meal name here',
      description:
          'Loading meal description that is long enough to create a skeleton placeholder.',
      image: null,
      isFeatured: false,
      preparationTime: '10 min',
      price: 0,
      variants: [
        Variant(id: 0, name: 'الاسم', price: 0, isAvailable: true),
        Variant(id: 1, name: 'الاسم', price: 0, isAvailable: true),
        Variant(id: 2, name: 'الاسم', price: 0, isAvailable: true),
      ],
      modifierGroups: [],
    );
  }
}

class Variant {
  final int id;
  final String name;
  final double price;
  final bool isAvailable;
  final bool selected;

  Variant({
    required this.id,
    required this.name,
    required this.price,
    required this.isAvailable,
    this.selected = false,
  });

  factory Variant.fromJson(Map<String, dynamic> json) {
    return Variant(
      id: json["id"] ?? 0,
      name: json["name"] ?? "",
      price: json["price"] != null
          ? double.tryParse(json["price"].toString()) ?? 0.0
          : 0.0,
      isAvailable: json["is_available"] ?? false,
      selected: json["selected"] ?? false,
    );
  }
}

class ModifierGroup {
  final int id;
  final String name;
  final bool isRequired;
  final bool isMultiple;
  final int minSelections;
  final int maxSelections;
  final List<Modifier> modifiers;
  final bool selected;

  ModifierGroup({
    required this.id,
    required this.name,
    required this.isRequired,
    required this.isMultiple,
    required this.minSelections,
    required this.maxSelections,
    required this.modifiers,
    this.selected = false,
  });

  factory ModifierGroup.fromJson(Map<String, dynamic> json) {
    return ModifierGroup(
      id: json["id"] ?? 0,
      name: json["name"] ?? "",
      isRequired: json["is_required"] ?? false,
      isMultiple: json["is_multiple"] ?? false,
      minSelections: json["min_selections"] ?? 0,
      maxSelections: json["max_selections"] ?? 0,
      selected: json["selected"] ?? false,
      modifiers: (json["modifiers"] as List? ?? [])
          .map((e) => Modifier.fromJson(e))
          .toList(),
    );
  }
}

class Modifier {
  final int id;
  final String name;
  final double price;
  final bool isAvailable;
  final bool selected;

  Modifier({
    required this.id,
    required this.name,
    required this.price,
    required this.isAvailable,
    this.selected = false,
  });

  factory Modifier.fromJson(Map<String, dynamic> json) {
    return Modifier(
      id: json['id'] ?? 0,
      name: json['name'] ?? "",
      price: json["price"] != null
          ? double.tryParse(json["price"].toString()) ?? 0.0
          : 0.0,
      isAvailable: json['is_available'] ?? false,
      selected: json["selected"] ?? false,
    );
  }
}
