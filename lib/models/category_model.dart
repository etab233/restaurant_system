class Category {
  final int id;
  final String name;
  final String? image;

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