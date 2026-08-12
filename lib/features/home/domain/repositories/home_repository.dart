import 'package:restaurants_system/features/home/data/models/category_model.dart';
import 'package:restaurants_system/features/home/data/models/restaurant_model.dart';

abstract class HomeRepository {
  /// بيرجع البيانات المخزنة محليًا فورًا (sync، بدون انتظار)
  HomeData getCachedHomeData();

  /// بحاول يجيب بيانات جديدة من الشبكة.
  /// لو نجح: يحدث الكاش ويرجع البيانات الجديدة.
  /// لو فشل: يرجع البيانات المخزنة (لو موجودة) بدل ما يرجع خطأ فاضي.
  Future<HomeResult> getHomeData({String? lat, String? lng});
}

class HomeData {
  final List<Category> categories;
  final List<RestaurantModel> restaurants;
  final bool isEmpty;

  HomeData({required this.categories, required this.restaurants})
      : isEmpty = categories.isEmpty && restaurants.isEmpty;
}

class HomeResult {
  final bool isSuccess;
  final HomeData? data;
  final bool isFromCache;

  HomeResult.success(this.data, {this.isFromCache = false}) : isSuccess = true;
  HomeResult.failure() : isSuccess = false, data = null, isFromCache = false;
}