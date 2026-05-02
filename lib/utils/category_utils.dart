import 'package:flutter/material.dart';
class CategoryUtils {
  CategoryUtils._(); // منع الإنشاء

  static Color colorFromName(String name) {
    const colors = [
      Color(0xFFFF6B35),
      Color(0xFF2EC4B6),
      Color(0xFFE71D36),
      Color(0xFF9B5DE5),
      Color(0xFF00BBF9),
      Color(0xFFF15BB5),
      Color(0xFF06D6A0),
      Color(0xFFFFBE0B),
    ];
    final index = name.codeUnits.fold(0, (a, b) => a + b) % colors.length;
    return colors[index];
  }

  static IconData iconFromName(String name) {
    final n = name.toLowerCase();
    if (n.contains('المشروبات'))                                  return Icons.local_bar;
    if (n.contains('الوجبات السريعة') || n.contains('برغر'))     return Icons.fastfood;
    if (n.contains('المقبلات')  || n.contains('الحلويات'))        return Icons.cake;
    if (n.contains('المأكولات البحرية'))                          return Icons.set_meal;
    if (n.contains('مشاوي'))                                      return Icons.outdoor_grill;
    if (n.contains('الأطباق الرئيسية'))                           return Icons.restaurant;
    if (n.contains('السلطات'))                                    return Icons.eco;
    if (n.contains('شاورما'))                                     return Icons.tapas;
    if (n.contains('إفطار'))                                      return Icons.free_breakfast;
    if (n.contains('قهوة'))                                       return Icons.coffee;
    if (n.contains('شاي'))                                        return Icons.emoji_food_beverage;
    if (n.contains('بيتزا'))                                      return Icons.local_pizza;
    if (n.contains('soup'))                                       return Icons.soup_kitchen;
    return Icons.restaurant_menu;
  }
}