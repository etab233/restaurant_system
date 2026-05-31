class MenuItem {
  final int itemId;
  final int restaurantId;
  final String name;
  final String? description;
  final String? image;
  final bool isFeatured;
  final String preparationTime;
  final double price;
  final List<Variant> variants;
  final List<ModifierGroup> modifierGroups;

  MenuItem({
    required this.itemId,
    required this.restaurantId,
    required this.name,
    this.description,
    this.image,
    required this.isFeatured,
    required this.preparationTime,
    required this.price,
    required this.variants,
    required this.modifierGroups,
  });
  factory MenuItem.fromJson(Map<String, dynamic> json) {
    return MenuItem(
      itemId: json["id"] ?? 0,
      restaurantId: json["restaurant_id"] ?? 0,
      name: json["name"] ?? " ",
      description: json["description"],
      image: json["image"],
      isFeatured: json["is_featured"] ?? false,
      preparationTime: json["preparation_time"] ?? "",
      price: json["price"] != null
          ? double.tryParse(json["price"].toString()) ?? 0.0
          : 0.0,
      variants: (json["variants"] as List? ?? [])
          .map((e) => Variant.fromJson(e))
          .toList(),
      modifierGroups: (json["modifier_groups"] as List? ?? [])
          .map((e) => ModifierGroup.fromJson(e))
          .toList(),
    );
  }
}

class Variant {
  final int id;
  final String name;
  final double price;
  final bool isAvailable;

  Variant({
    required this.id,
    required this.name,
    required this.price,
    required this.isAvailable,
  });

  factory Variant.fromJson(Map<String, dynamic> json) {
    return Variant(
      id: json["id"] ?? 0,
      name: json["name"] ?? "",
      price: json["price"] != null
          ? double.tryParse(json["price"].toString()) ?? 0.0
          : 0.0,
      isAvailable: json["is_available"] ?? false,
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

  ModifierGroup({
    required this.id,
    required this.name,
    required this.isRequired,
    required this.isMultiple,
    required this.minSelections,
    required this.maxSelections,
    required this.modifiers,
  });

  factory ModifierGroup.fromJson(Map<String, dynamic> json) {
    return ModifierGroup(
      id: json["id"] ?? 0,
      name: json["name"] ?? "",
      isRequired: json["is_required"] ?? false,
      isMultiple: json["is_multiple"] ?? false,
      minSelections: json["min_selections"] ?? 0,
      maxSelections: json["max_selections"] ?? 0,
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

  Modifier({
    required this.id,
    required this.name,
    required this.price,
    required this.isAvailable,
  });

  factory Modifier.fromJson(Map<String, dynamic> json) {
    return Modifier(
      id: json['id'] ?? 0,
      name: json['name'] ?? "",
      price: json["price"] != null
          ? double.tryParse(json["price"].toString()) ?? 0.0
          : 0.0,
      isAvailable: json['is_available'] ?? false,
    );
  }
}
