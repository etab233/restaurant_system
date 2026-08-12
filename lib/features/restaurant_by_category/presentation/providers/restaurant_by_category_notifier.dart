import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/restaurant_by_category_remote_data_source.dart';
import '../../data/repositories/restaurant_by_category_repository_impl.dart';
import '../../domain/repositories/restaurant_by_category_repository.dart';
import 'restaurant_by_category_state.dart';

final restaurantByCategoryRepositoryProvider =
    Provider<RestaurantByCategoryRepository>((ref) {
      return RestaurantByCategoryRepositoryImpl(
        RestaurantByCategoryRemoteDataSource(),
      );
    });

final restaurantByCategoryProvider =
    NotifierProvider<RestaurantByCategoryNotifier, RestaurantByCategoryState>(
      RestaurantByCategoryNotifier.new,
    );

class RestaurantByCategoryNotifier extends Notifier<RestaurantByCategoryState> {
  late RestaurantByCategoryRepository _repository;

  @override
  RestaurantByCategoryState build() {
    _repository = ref.read(restaurantByCategoryRepositoryProvider);
    return RestaurantByCategoryState();
  }

  Future<void> fetchRestaurantsByCategory(int categoryId) async {
    state = state.copyWith(
      isLoading: true,
      restaurants: [],
      message: "",
      status: "loading",
    );

    final result = await _repository.fetchRestaurantsByCategory(categoryId);

    state = result.isSuccess
        ? state.copyWith(
            restaurants: result.restaurants,
            status: result.status,
            isLoading: false,
          )
        : state.copyWith(
            message: result.message,
            status: result.status,
            isLoading: false,
          );
  }
}
