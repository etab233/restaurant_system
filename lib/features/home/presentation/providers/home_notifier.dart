import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurants_system/features/home/presentation/providers/home_provider.dart';
import '../../domain/repositories/home_repository.dart';
import 'home_state.dart';

class HomeNotifier extends Notifier<HomeState> {
  late HomeRepository _repository;

  @override
  HomeState build() {
    _repository = ref.read(homeRepositoryProvider);
    return const HomeState(status: "", categories: [], restaurants: []);
  }

  Future<void> getHomeData({String? lat, String? lng}) async {
    // اعرض الكاش فورًا لو موجود (نفس السلوك الأصلي بالضبط)
    final cached = _repository.getCachedHomeData();
    state = cached.isEmpty
        ? state.copyWith(status: 'loading')
        : state.copyWith(
            status: 'success',
            categories: cached.categories,
            restaurants: cached.restaurants,
          );

    // جرب تجيب بيانات جديدة من الشبكة
    final result = await _repository.getHomeData(lat: lat, lng: lng);

    state = result.isSuccess
        ? state.copyWith(
            status: 'success',
            categories: result.data!.categories,
            restaurants: result.data!.restaurants,
          )
        : state.copyWith(status: 'false');
  }
}