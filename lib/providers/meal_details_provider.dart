import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurants_system/notifier/meal_details_notifier.dart';

final mealDetailsProvider = NotifierProvider<MealDetailsNotifier, MealDetailsState>((){
  return MealDetailsNotifier();
});