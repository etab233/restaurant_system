import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurants_system/features/cart/data/datasources/cart_remote_data_source.dart';
import 'package:restaurants_system/features/cart/data/repositories/cart_repository_impl.dart';
import 'package:restaurants_system/features/cart/domain/repositories/cart_repository.dart';
import 'package:restaurants_system/features/cart/presentation/providers/cart_notifier.dart';
import 'package:restaurants_system/features/cart/presentation/providers/cart_state.dart'
    show CartState;

final cartRepositoryProvider = Provider<CartRepository>((ref) {
  return CartRepositoryImpl(CartRemoteDataSource());
});

final cartNotifierProvider = NotifierProvider<CartNotifier, CartState>(
  CartNotifier.new,
);
