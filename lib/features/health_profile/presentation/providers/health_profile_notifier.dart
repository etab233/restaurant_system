import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurants_system/features/auth/data/datasources/auth_local_data_source.dart';
import '../../data/datasources/health_profile_local_data_source.dart';
import '../../data/datasources/health_profile_remote_data_source.dart';
import '../../data/repositories/health_profile_repository_impl.dart';
import '../../domain/repositories/health_profile_repository.dart';
import 'health_profile_state.dart';

final healthProfileRepositoryProvider = Provider<HealthProfileRepository>((
  ref,
) {
  return HealthProfileRepositoryImpl(
    HealthProfileRemoteDataSource(),
    HealthProfileLocalDataSource(),
    AuthLocalDataSource(),
  );
});

final healthProfileProvider =
    NotifierProvider<HealthProfileNotifier, HealthProfileState>(
      HealthProfileNotifier.new,
    );

class HealthProfileNotifier extends Notifier<HealthProfileState> {
  late HealthProfileRepository _repository;

  @override
  HealthProfileState build() {
    _repository = ref.read(healthProfileRepositoryProvider);
    return const HealthProfileState();
  }

  void setBirthDate(String birthDate) {
    state = state.copyWith(birthDate: birthDate);
  }

  void setGender(String gender) {
    state = state.copyWith(gender: gender);
  }

  void setBodyInfo({required double heightCm, required double weightKg}) {
    state = state.copyWith(heightCm: heightCm, weightKg: weightKg);
  }

  void setActivityAndGoal({
    required String activityLevel,
    required String goal,
  }) {
    state = state.copyWith(activityLevel: activityLevel, goal: goal);
  }

  Future<bool> hasHealthAccount() async {
    final result = await _repository.checkHealthAccount();

    if (result.hasAccount) {
      state = state.copyWith(
        birthDate: result.birthDate,
        gender: result.gender,
        heightCm: result.heightCm,
        weightKg: result.weightKg,
        activityLevel: result.activityLevel,
        goal: result.goal,
      );
    }
    return result.hasAccount;
  }

  Future<void> saveUserData({
    required String birthDate,
    required double heightCm,
    required double weightKg,
    required String gender,
    required String activityLevel,
    required String goal,
  }) async {
    final result = await _repository.saveUserData(
      birthDate: birthDate,
      heightCm: heightCm,
      weightKg: weightKg,
      gender: gender,
      activityLevel: activityLevel,
      goal: goal,
    );

    if (result.isSuccess) {
      state = state.copyWith(
        birthDate: birthDate,
        gender: gender,
        heightCm: heightCm,
        weightKg: weightKg,
        activityLevel: activityLevel,
        goal: goal,
      );
    }
  }
}
