import 'dart:convert';

import 'package:restaurants_system/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:restaurants_system/features/auth/domain/repositories/auth_repository.dart';
import 'package:restaurants_system/features/profile/data/datasources/profile_local_data_source.dart';
import 'package:restaurants_system/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:restaurants_system/features/profile/data/models/profile_model.dart';
import 'package:restaurants_system/features/profile/domain/repositories/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource _remoteDataSource;
  final ProfileLocalDataSource _localDataSource;
  final AuthRepository _authRepository;
  final AuthRemoteDatasource _authRemoteDatasource;

  ProfileRepositoryImpl(
    this._authRemoteDatasource,
    this._authRepository,
    this._localDataSource,
    this._remoteDataSource,
  );

  @override
  ProfileModel? getCachedProfile() => _localDataSource.getCachedProfile();

  @override
  Future<ProfileResult> fetchProfile() async {
    final token = await _authRepository.getCurrentToken();
    if (token == null) {
      return ProfileResult.failure("Please login first");
    }
    try {
      final response = await _remoteDataSource.getProfile(token: token);
      final data = json.decode(response.body);
      if (response.statusCode == 200) {
        final profile = ProfileModel.fromJson(
          data['data'] as Map<String, dynamic>,
        );
        await _localDataSource.saveProfile(profile);
        return ProfileResult.success(profile);
      }
      return ProfileResult.failure(data['message'] ?? 'Failed to load profile');
    } catch (e) {
      return ProfileResult.failure("An error occured $e");
    }
  }

  @override
  Future<UpdateResult> changeName(String newName) async {
    final token = await _authRepository.getCurrentToken();
    if (token == null) {
      return UpdateResult.failure("please login first");
    }
    try {
      final response = await _remoteDataSource.updateName(
        name: newName,
        token: token,
      );
      final data = json.decode(response.body);
      if (response.statusCode == 200) {
        final cached = _localDataSource.getCachedProfile();
        if (cached != null) {
          await _localDataSource.saveProfile(cached.copyWith(name: newName));
        }
        return UpdateResult.success(
          message: data['message'] ?? 'Name updated successfully',
        );
      }
      return UpdateResult.failure(data['message'] ?? 'Failed to update name');
    } catch (e) {
      return UpdateResult.failure("An error occurred: $e");
    }
  }

  @override
  Future<UpdateResult> changePhone(String newPhone) async {
    final token = await _authRepository.getCurrentToken();

    if (token == null) {
      return UpdateResult.failure("Please login first.");
    }

    try {
      final response = await _remoteDataSource.updatePhone(
        phone: newPhone,
        token: token,
      );

      final data = json.decode(response.body);

      if (response.statusCode == 200) {
        final cached = _localDataSource.getCachedProfile();

        if (cached != null) {
          await _localDataSource.saveProfile(cached.copyWith(phone: newPhone));
        }

        return UpdateResult.success(
          message: data['message'] ?? 'Phone number updated successfully',
        );
      }

      return UpdateResult.failure(
        data['message'] ?? 'Failed to update phone number',
      );
    } catch (e) {
      return UpdateResult.failure('An error occurred: $e');
    }
  }

  @override
  Future<UpdateResult> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    final token = await _authRepository.getCurrentToken();
    if (token == null) {
      return UpdateResult.failure("Please login first.");
    }
    final profile = _localDataSource.getCachedProfile();
    if (profile == null || profile.email.isEmpty) {
      return UpdateResult.failure(
        "Failed to verify your account, please login again.",
      );
    }

    try {
      final verifyResponse = await _authRemoteDatasource.login(
        email: profile.email,
        password: currentPassword,
      );
      if (verifyResponse.statusCode != 200) {
        return UpdateResult.failure("Current password isn't correct.");
      }
    } catch (e) {
      return UpdateResult.failure(
        "Failed to verify current password, please try again.",
      );
    }

    try {
      final response = await _remoteDataSource.updatePassword(
        token: token,
        newPassword: newPassword,
      );
      final data = json.decode(response.body);
      if (response.statusCode == 200) {
        return UpdateResult.success(
          message: data['message'] ?? 'Password changed successfully',
        );
      }
      return UpdateResult.failure(
        data['message'] ?? 'Failed to change password',
      );
    } catch (e) {
      return UpdateResult.failure("An error occurred: $e");
    }
  }
}
