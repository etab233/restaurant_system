import 'package:hive_flutter/hive_flutter.dart';
import 'package:restaurants_system/models/menu_item.dart';
part 'category_model.g.dart';

@HiveType(typeId: 3)
class Category {
  @HiveField(0)
  int id;
  @HiveField(1)
  String name;
  @HiveField(2)
  String? image;
  @HiveField(3)
  List<MenuItem>? menuItems;

  Category({required this.id, required this.name, this.image, this.menuItems});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] as int,
      name: json['name'] as String,
      image: json['image'],
      menuItems:
          (json['items'] as List<dynamic>?)
              ?.map((item) => MenuItem.fromJson(item as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {'id': id, 'name': name, 'image': image};
}
