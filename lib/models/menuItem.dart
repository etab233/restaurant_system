class MenuItem {
  final int id;
  final String name;
  final String description;
  final String price;
  // final bool has_variants;
  final String? image;
  final bool is_featured;
  final String preparation_time;
  MenuItem({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    // required this.has_variants,
    required this.image,
    required this.is_featured,
    required this.preparation_time,
  });
  factory MenuItem.fromJson(Map<String, dynamic> json) {
    return MenuItem(
      id: json["id"] ?? 0,
      name: json["name"] ?? "Meal Name",
      description: json["description"] ?? "Meal Description",
      price: json["price"] ?? "",
      // has_variants: json["has_variants"],
      image: json["image"] ?? "assets/images/burger.png",
      is_featured: json["is_featured"] ?? false,
      preparation_time: json["preparation_time"] ?? "",
    );
  }
}
