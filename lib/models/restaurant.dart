class Restaurant {
  final int id;
  final String name;
  final String description;
  final String logo;
  final String cover_image;
  final String address;
  final String email;
  final String phone;
  // final int rating;
  // final double latitude;
  // final double longitude;
  final bool isOpen;
  final String openingTime;
  final String closingTime;
  Restaurant({
    required this.id,
    required this.name,
    required this.description,
    required this.logo,
    required this.cover_image,
    required this.address,
    required this.email,
    required this.phone,
    // required this.rating,
    // required this.latitude,
    // required this.longitude,
    required this.isOpen,
    required this.openingTime,
    required this.closingTime,
  });
  factory Restaurant.fromJson(Map<String, dynamic> json) {
    return Restaurant(
      id: json['id'] ?? 0,
      name: json['name'] ?? 'Restaurant Name',
      description: json['description'] ?? 'Restaurant Description',
      logo: json['logo'] ?? 'assets/images/logo.jpg',
      cover_image: json['cover_image'] ?? 'assets/images/cover.png',
      address: json['address'] ?? 'Restaurant Address',
      phone: json['phone'] ?? '+963987654321',
      // rating: json['rate'] ?? 0,
      email: json['email'] ?? '-',
      // latitude: json['location']['latitude'] ?? -90.0000,
      // longitude: json['location']['longitude'] ?? 0.0000,
      isOpen: json['is_open'] ?? false,
      openingTime: json['opening_time'] ?? '09:00 AM',
      closingTime: json['closing_time'] ?? '09:00 PM',
    );
  }
}
