import 'package:restaurants_system/models/menuItem.dart';

class Category {
  final int id;
  final String name;
  final String? image;
  List<MenuItem>? menuItems;

  Category({required this.id, required this.name, this.image, this.menuItems});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] as int,
      name: json['name'] as String,
      image: json['image'],
      menuItems: (json["items"] as List?)
          ?.map((item) => MenuItem.fromJson(item))
          .toList() ?? []
    );
  }

  Map<String, dynamic> toJson() => {'id': id, 'name': name, 'image': image};
}
