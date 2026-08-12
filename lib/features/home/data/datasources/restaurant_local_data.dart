import 'package:hive/hive.dart';
import 'package:restaurants_system/features/home/data/models/restaurant_model.dart';

class RestaurantLocalData {
  final Box<RestaurantModel> box = Hive.box("restaurantsBox");

  // تابع لحفظ البيانات 
  Future<void> cacheRestaurants(List<RestaurantModel> restaurants)async{
    // حذف البيانات القديمة 
    await box.clear();
    // إضافة البيانات الجديدة 
    for(int i=0; i<restaurants.length; i++){
      await box.put(i, restaurants[i]);
    }
  }

  // تابع لجلب البيانات 
  List<RestaurantModel> getCachedRestaurants(){
    return box.values.toList();
  }
}