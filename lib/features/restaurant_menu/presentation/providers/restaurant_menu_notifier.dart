import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurants_system/core/location/presentation/providers/location_provider.dart';
import '../../data/datasources/restaurant_menu_remote_data_source.dart';
import '../../data/repositories/restaurant_menu_repository_impl.dart';
import '../../domain/repositories/restaurant_menu_repository.dart';
import 'restaurant_menu_state.dart';

final restaurantMenuRepositoryProvider = Provider<RestaurantMenuRepository>((ref) {
  return RestaurantMenuRepositoryImpl(
    RestaurantMenuRemoteDataSource(),
    ref.read(locationRepositoryProvider),
  );
});

final restaurantMenuProvider =
    NotifierProvider<RestaurantMenuNotifier, RestaurantMenuState>(
  RestaurantMenuNotifier.new,
);

class RestaurantMenuNotifier extends Notifier<RestaurantMenuState> {
  late RestaurantMenuRepository _repository;

  @override
  RestaurantMenuState build() {
    _repository = ref.read(restaurantMenuRepositoryProvider);
    return RestaurantMenuState(
      restaurant: null,
      isLoading: true,
      message: "please wait while we fetch restaurant data",
      status: null,
    );
  }

  Future<void> viewRestaurant(int restaurantId) async {
    state = state.copyWith(isLoading: true);
    final result = await _repository.viewRestaurant(restaurantId);

    state = result.isSuccess
        ? state.copyWith(
            restaurant: result.restaurant,
            categories: result.categories,
            isLoading: false,
            status: result.status,
          )
        : state.copyWith(isLoading: false, message: result.message, status: result.status);
  }
}