import 'dart:convert';
import 'package:restaurants_system/features/auth/data/datasources/auth_local_data_source.dart';

import '../datasources/health_profile_remote_data_source.dart';
import '../datasources/health_profile_local_data_source.dart';
import '../../domain/repositories/health_profile_repository.dart';

class HealthProfileRepositoryImpl implements HealthProfileRepository {
  final HealthProfileRemoteDataSource _remote;
  final HealthProfileLocalDataSource _local;
  final AuthLocalDataSource _authLocal;

  HealthProfileRepositoryImpl(this._remote, this._local, this._authLocal);

  @override
  Future<HealthAccountResult> checkHealthAccount() async {
    final token = await _authLocal.getToken();
    // تحقق من الكاش المحلي أولًا)

    if (token == null) {
      await _local.setHasHealthAccount(false);
      return HealthAccountResult(hasAccount: false);
    }

    try {
      final response = await _remote.hasHealthAccount(token: token);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        await _local.setHasHealthAccount(true);

        return HealthAccountResult(
          hasAccount: true,
          birthDate: data['data']['birth_date'],
          gender: data['data']['gender'],
          heightCm: double.parse(data['data']['height_cm'].toString()),
          weightKg: double.parse(data['data']['weight_kg'].toString()),
          activityLevel: data['data']['activity_level'],
          goal: data['data']['goal'],
        );
      }
      await _local.setHasHealthAccount(false);
      return HealthAccountResult(hasAccount: false);
    } catch (e) {
      await _local.setHasHealthAccount(false);
      return HealthAccountResult(hasAccount: false);
    }
  }

  @override
  Future<SaveProfileResult> saveUserData({
    required String birthDate,
    required double heightCm,
    required double weightKg,
    required String gender,
    required String activityLevel,
    required String goal,
  }) async {
    final token = await _authLocal.getToken();
    if (token == null) {
      return SaveProfileResult.failure("No token found");
    }

    try {
      final response = await _remote.saveUserData(
        birthDate: birthDate,
        heightCm: heightCm,
        weightKg: weightKg,
        gender: gender,
        activityLevel: activityLevel,
        goal: goal,
        token: token,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        await _local.setHasHealthAccount(true);
        return SaveProfileResult.success();
      }
      return SaveProfileResult.failure(response.body);
    } catch (e) {
      return SaveProfileResult.failure(e.toString());
    }
  }
}
