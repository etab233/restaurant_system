import 'package:hive_flutter/hive_flutter.dart';
part 'category_model.g.dart';

@HiveType(typeId: 3)
class Category {
  @HiveField(0) int id;
  @HiveField(1) String name;
  @HiveField(2) String? image;

  Category({
    required this.id,
    required this.name,
    this.image,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id   : json['id'] as int,
      name : json['name'] as String,
      image: json['image'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id'   : id,
    'name' : name,
    'image': image,
  };
}