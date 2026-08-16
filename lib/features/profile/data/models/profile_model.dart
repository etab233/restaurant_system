class ProfileModel {
  final String name;
  final String email;
  final String phone;

  ProfileModel({
    required this.name,
    required this.email,
    required this.phone
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      name: json['name'],
      email: json['email'],
      phone: json['phone']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'phone': phone
    };
  }
  ProfileModel copyWith({
    String? name,
    String? email,
    String? phone,
  }) {
    return ProfileModel(
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
    );
  }
}