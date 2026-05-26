class MenuItem {
  final int id;
  final String name;
  final String description;
  final String? image;
  final bool? isFeatured;
  final String preparationTime;
  MenuItem({
    required this.id,
    required this.name,
    required this.description,
    this.image,
    this.isFeatured,
    required this.preparationTime,
  });
  factory MenuItem.fromJson(Map<String, dynamic> json) {
    return MenuItem(
      id: json["id"] ?? 0,
      name: json["name"] ?? "Meal Name",
      description: json["description"] ?? "Meal Description",
      image: json["image"] ,
      isFeatured: json["is_featured"] ?? false,
      preparationTime: json["preparation_time"] ?? "",
    );
  }
}
