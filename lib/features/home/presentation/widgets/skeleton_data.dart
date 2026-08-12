// ── Skeleton Data ─────────────────────────────────────────────
// لاستخدامه أثناء تحميل البيانات فقط
import 'package:restaurants_system/features/home/data/models/category_model.dart';
import 'package:restaurants_system/features/home/data/models/restaurant_model.dart';

class SkeletonData {
  static List<Category> get categories =>
      List.generate(7, (i) => Category(id: i, name: 'Category $i'));

  static List<RestaurantModel> get restaurants => List.generate(
    4,
    (i) => RestaurantModel(
      id: i,
      name: 'Restaurant $i',
      description: 'Loading description...',
      address: 'Loading address...',
      phone: '0000000000',
      logo: null,
      coverImage: null,
      hours: RestaurantHours(
        opens: '09:00:00',
        closes: '23:00:00',
        isOpen: true,
      ),
      location: RestaurantLocation(latitude: 0, longitude: 0, distanceKm: null),
      categories: [],
      rate: 4,
    ),
  );
}

class SkeletonHomeState {
  final String status = 'success';
  final List<Category> categories = SkeletonData.categories;
  final List<RestaurantModel> restaurants = SkeletonData.restaurants;
}
