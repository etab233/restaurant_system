class RestaurantByCategoryModel {
  final int id;
  final String name;
  final String description;
  final String address;
  final String? logo;
  final double rate;
  final bool isOpen;

  RestaurantByCategoryModel({
    required this.id,
    required this.name,
    required this.description,
    required this.address,
    this.logo,
    required this.rate,
    required this.isOpen,
  });

  factory RestaurantByCategoryModel.fromJson(Map<String, dynamic> json) {
    return RestaurantByCategoryModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      address: json['address'] ?? '',
      logo: json['logo'],
      rate: (json['rate'] as num?)?.toDouble() ?? 0.0,
      isOpen: json['hours'] != null
          ? (json['hours']['is_open'] ?? false)
          : false,
    );
  }
}
