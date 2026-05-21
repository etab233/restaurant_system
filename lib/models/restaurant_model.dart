import 'package:hive/hive.dart';
import 'package:restaurants_system/models/category_model.dart';
<<<<<<< HEAD
part 'restaurant_model.g.dart';

@HiveType(typeId: 0) // hive adapter
=======

>>>>>>> 92ee6f91d0fcf992e722100014ed996468c4d7f5
class RestaurantModel {
  @HiveField(0) final int id;
  @HiveField(1) final String name;
  @HiveField(2) final String description;
  @HiveField(3) final String address;
  @HiveField(4) final String phone;
  @HiveField(5) final String? logo;
  @HiveField(6) final String? coverImage;
  @HiveField(7) final RestaurantHours hours;
  @HiveField(8) final RestaurantLocation location;
  @HiveField(9) final List<Category> categories;
  @HiveField(10) final int rate;

  RestaurantModel({
    required this.id,
    required this.name,
    required this.description,
    required this.address,
    required this.phone,
    this.logo,
    this.coverImage,
    required this.hours,
    required this.location,
    required this.categories,
    required this.rate,
  });

  // fromJson
  factory RestaurantModel.fromJson(Map<String, dynamic> json) {
    return RestaurantModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      address: json['address'],
      phone: json['phone'],
      logo: json['logo'],
      coverImage: json['cover_image'],
      hours: RestaurantHours.fromJson(json['hours'] ?? json),
      location: json['location'] != null
          ? RestaurantLocation.fromJson(json['location'])
          : RestaurantLocation(),
      categories:
          (json['categories'] as List<dynamic>?)
              ?.map((c) => Category.fromJson(c))
              .toList() ??
          [],
      rate: json['rate'] ?? 0,
    );
  }

  // toJson
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'address': address,
      'phone': phone,
      'logo': logo,
      'cover_image': coverImage,
      'hours': hours.toJson(),
      'location': location.toJson(),
      // 'categories': categories,
      'rate': rate,
    };
  }
}

@HiveType(typeId: 1)
class RestaurantHours {
  @HiveField(0) final String? opens;
  @HiveField(1) final String? closes;
  @HiveField(2) final bool isOpen;

  RestaurantHours({this.opens, this.closes, required this.isOpen});

  // fromJson
  factory RestaurantHours.fromJson(Map<String, dynamic> json) {
    return RestaurantHours(
      opens: json['opens'] ?? json['opening_time'],
      closes: json['closes'] ?? json['closing_time'],
      isOpen: json['is_open'] ?? json['is_open_now'],
    );
  }

  // toJson
  Map<String, dynamic> toJson() {
    return {'opens': opens, 'closes': closes, 'isOpen': isOpen};
  }
}

@HiveType(typeId: 2)
class RestaurantLocation {
  @HiveField(0) final double? latitude;
  @HiveField(1) final double? longitude;
  @HiveField(2) final double? distanceKm;

  RestaurantLocation({this.latitude, this.longitude, this.distanceKm});

  // fromJson
  factory RestaurantLocation.fromJson(Map<String, dynamic> json) {
    return RestaurantLocation(
      latitude: (json['latitude'] != null)
          ? (json['latitude'] as num).toDouble()
          : null,
      longitude: (json['longitude'] != null)
          ? (json['longitude'] as num).toDouble()
          : null,
      distanceKm: (json['distance_km'] != null)
          ? (json['distance_km'] as num).toDouble()
          : null,
    );
  }

  // toJson
  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'distance_km': distanceKm,
    };
  }
}
