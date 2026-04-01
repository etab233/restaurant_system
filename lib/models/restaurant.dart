class Restaurant {
  final String name;
  final String description;
  final String logo;
  final String cover_image;
  final String address;
  final String email;
  final String phone;
  final String latitude;
  final String longitude;
  final String openingTime;
  final String closingTime;
  Restaurant({
    required this.name,
    required this.description,
    required this.logo,
    required this.cover_image,
    required this.address,
    required this.email,
    required this.phone,
    required this.latitude,
    required this.longitude,
    required this.openingTime,
    required this.closingTime,
  });
  factory Restaurant.fromJson(Map<String, dynamic> json) {
    return Restaurant(
      name: json['name'] ?? 'Restaurant Name',
      description: json['description'] ?? 'Restaurant Description',
      logo: json['logo'] ?? 'assets/images/placeholder.png',
      cover_image: json['cover_image'] ?? 'assets/images/placeholder_cover.png',
      address: json['address'] ?? 'Restaurant Address',
      phone: json['phone'] ?? '+963987654321',
      email: json['email'] ?? 'someone@example.com',
      latitude: json['latitude'] ?? '-90.0000',
      longitude: json['longitude'] ?? '0.0000',
      openingTime: json['opening_time'] ?? '09:00',
      closingTime: json['closing_time'] ?? '21:00',
    );
  }
}
