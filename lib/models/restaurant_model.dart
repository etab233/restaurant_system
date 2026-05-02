import 'package:restaurants_system/models/category_model.dart';
class RestaurantModel {
  final int id;
  final String name;
  final String description;
  final String address;
  final String phone;
  final String? logo;
  final String? coverImage;
  final RestaurantHours hours;
  final RestaurantLocation location;
  final List<dynamic> categories;
  final int rate;

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
      hours: RestaurantHours.fromJson(json['hours']),
      location: RestaurantLocation.fromJson(json['location']),
      categories:
          (json['categories'] as List<dynamic>?)
              ?.map((c) => Category.fromJson(c))
              .toList() ??
          [],
      rate: json['rate'],
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
      'coverImage': coverImage,
      'hours': hours.toJson(),
      'location': location.toJson(),
      'categories': categories,
      'rate': rate,
    };
  }
}

class RestaurantHours {
  final String? opens;
  final String? closes;
  final bool isOpen;

  RestaurantHours({this.opens, this.closes, required this.isOpen});

  // fromJson
  factory RestaurantHours.fromJson(Map<String, dynamic> json) {
    return RestaurantHours(
      opens: json['opens'],
      closes: json['closes'],
      isOpen: json['is_open'],
    );
  }

  // toJson
  Map<String, dynamic> toJson() {
    return {'opens': opens, 'closes': closes, 'isOpen': isOpen};
  }
}

class RestaurantLocation {
  final double? latitude;
  final double? longitude;
  final double? distanceKm;

  RestaurantLocation({this.latitude, this.longitude, this.distanceKm});

  // fromJson
  factory RestaurantLocation.fromJson(Map<String, dynamic> json) {
    return RestaurantLocation(
      latitude: (json ['latitude'] != null)
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