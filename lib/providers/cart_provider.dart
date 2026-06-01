import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurants_system/notifier/cart_notifier.dart';

final cartProvider = NotifierProvider<CartNotifier, CartState>(() {
  return CartNotifier();
});
