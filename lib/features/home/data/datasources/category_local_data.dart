import 'package:hive/hive.dart';
import 'package:restaurants_system/features/home/data/models/category_model.dart';

class CategoryLocalData {
  final Box<Category> box = Hive.box<Category>('categoriesBox');

  Future<void> cacheCategories(List<Category> categories) async {
    await box.clear();
    await box.addAll(categories);
  }

  List<Category> getCachedCategories() {
    return box.values.toList();
  }
}