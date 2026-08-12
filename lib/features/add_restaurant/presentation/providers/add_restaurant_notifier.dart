import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurants_system/features/add_restaurant/domain/repositories/add_restaurant_repository.dart';
import 'package:restaurants_system/features/add_restaurant/presentation/providers/add_restaurant_provider.dart';
import 'package:restaurants_system/features/add_restaurant/presentation/providers/add_restaurant_state.dart';
import 'package:restaurants_system/features/auth/domain/repositories/auth_repository.dart';
import 'package:restaurants_system/features/auth/presentation/providers/auth_provider.dart';

class AddRestaurantNotifier extends Notifier<AddRestaurantState> {
  late AddRestaurantRepository _repository;
  late AuthRepository _authRepository;

  @override
  AddRestaurantState build() {
    _repository = ref.read(addRestaurantRepositoryProvider);
    _authRepository = ref.read(authRepositoryProvider);
    
    return const AddRestaurantState(
      status: "",
      message: "",
      isLoading: true,
      categories: [],
      isLoadCategories: false,
    );
  }

  Future<void> sendRestaurantRequest({
    required String name,
    required String description,
    required String number,
    required String address,
    double? latitude,
    double? longitude,
    required List<int> categories,
  }) async {
    state = state.copyWith(status: "", message: "");

    final token = await _authRepository.getCurrentToken();

    if (token == null) {
      state = state.copyWith(
        message: "Please login first",
        isLoadCategories: false,
        status: "unauthenticated",
      );
      return;
    }

    final result = await _repository.sendRestaurantRequest(
      name: name,
      description: description,
      number: number,
      address: address,
      latitude: latitude,
      longitude: longitude,
      categories: categories,
      token: token,
    );

    state = result.isSuccess
        ? state.copyWith(
            isLoading: false,
            status: result.status,
            message: result.message,
          )
        : state.copyWith(
            isLoading: false,
            status: "refused",
            message: result.message,
          );
  }

  Future<void> fetchCategories() async {
    state = state.copyWith(isLoadCategories: false);
    final result = await _repository.fetchCategories();
    state = state.copyWith(
      isLoadCategories: false,
      categories: result.categories,
    );
  }
}
