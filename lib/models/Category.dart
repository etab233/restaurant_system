import 'package:restaurants_system/models/menuItem.dart';

class Category {
  final int id;
  final String name;
  List<MenuItem>? menuItems;
  Category({required this.id, required this.name, this.menuItems});
  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json["id"] ?? 0,
      name: json["name"] ?? "Category Name",
      menuItems: (json["items"] as List?)
          ?.map((item) => MenuItem.fromJson(item))
          .toList() ?? []
    );
  }
}
