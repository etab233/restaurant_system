import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurants_system/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:restaurants_system/features/auth/presentation/providers/auth_provider.dart';
import 'package:restaurants_system/features/profile/data/datasources/profile_local_data_source.dart';
import 'package:restaurants_system/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:restaurants_system/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:restaurants_system/features/profile/domain/repositories/profile_repository.dart';
import 'package:restaurants_system/features/profile/presentation/providers/profile_state.dart';

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  return ProfileRepositoryImpl(
    AuthRemoteDatasource(),
    ref.read(authRepositoryProvider),
    ProfileLocalDataSource(),
    ProfileRemoteDataSource(),
  );
});

final profileProvider = NotifierProvider<ProfileNotifier, ProfileState>(
  ProfileNotifier.new,
);

class ProfileNotifier extends Notifier<ProfileState> {
  late ProfileRepository _profileRepository;

  bool _isRefreshing = false;

  @override
  ProfileState build() {
    _profileRepository = ref.read(profileRepositoryProvider);

    final cachedProfile = _profileRepository.getCachedProfile();

    Future.microtask(refreshProfile);

    return ProfileState(
      profile: cachedProfile,
      status: cachedProfile != null ? 'success' : 'loading',
    );
  }

  Future<void> refreshProfile() async {
    if (_isRefreshing) return;

    _isRefreshing = true;

    try {
      final result = await _profileRepository.fetchProfile();

      if (result.isSuccess) {
        state = state.copyWith(
          profile: result.profile,
          status: 'success',
          message: null,
        );
      } else {
        state = state.copyWith(
          // إذا عندنا cache يبقى ظاهر
          profile: state.profile,
          status: state.profile != null ? 'success' : 'error',
          message: result.message,
        );
      }
    } finally {
      _isRefreshing = false;
    }
  }

  Future<bool> updateName(String name) async {
    state = state.copyWith(isUpdatingName: true, message: '');
    final result = await _profileRepository.changeName(name);

    state = state.copyWith(
      isUpdatingName: false,
      message: result.message,
      profile: result.isSuccess
          ? state.profile?.copyWith(name: name)
          : state.profile,
    );

    return result.isSuccess;
  }

  Future<bool> updatePhone(String phone) async {
    state = state.copyWith(isUpdatingPhone: true, message: '');

    final result = await _profileRepository.changePhone(phone);

    state = state.copyWith(
      isUpdatingPhone: false,
      message: result.message,
      profile: result.isSuccess
          ? state.profile?.copyWith(phone: phone)
          : state.profile,
    );

    return result.isSuccess;
  }

  Future<bool> updatePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    state = state.copyWith(isUpdatingPassword: true, message: '');

    final result = await _profileRepository.changePassword(
      currentPassword: currentPassword,
      newPassword: newPassword,
    );

    state = state.copyWith(isUpdatingPassword: false, message: result.message);

    return result.isSuccess;
  }
}
