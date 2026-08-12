import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurants_system/features/add_restaurant/data/datasources/add_restaurant_remote_data_source.dart';
import 'package:restaurants_system/features/add_restaurant/data/repositories/add_restaurant_repository_impl.dart';
import 'package:restaurants_system/features/add_restaurant/domain/repositories/add_restaurant_repository.dart';
import 'package:restaurants_system/features/add_restaurant/presentation/providers/add_restaurant_notifier.dart';
import 'package:restaurants_system/features/add_restaurant/presentation/providers/add_restaurant_state.dart';
import 'package:restaurants_system/features/home/data/datasources/category_local_data.dart';

final addRestaurantRepositoryProvider = Provider<AddRestaurantRepository>((
  ref,
) {
  return AddRestaurantRepositoryImpl(
    AddRestaurantRemoteDataSource(),
    CategoryLocalData(),
  );
});

final addRestaurantProvider =
    NotifierProvider<AddRestaurantNotifier, AddRestaurantState>(
      AddRestaurantNotifier.new,
    );
