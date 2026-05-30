import 'package:hive/hive.dart';
part 'favorite_meal_model.g.dart';

@HiveType(typeId: 4)
class FavoriteMeal {
  @HiveField(0)
  final int itemId;

  @HiveField(1)
  final int restaurantId;

  @HiveField(2)
  final String name;

  @HiveField(3)
  final String? image;

  @HiveField(4)
  final String? description;

  FavoriteMeal({
    required this.itemId,
    required this.restaurantId,
    required this.name,
    this.image,
    this.description,
  });
}