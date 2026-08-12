import 'package:restaurants_system/features/profile/data/models/profile_model.dart';

abstract class ProfileRepository {
  ProfileModel? getCachedProfile();
  Future<ProfileResult> fetchProfile();
  Future<UpdateResult> changeName(String newName);
  Future<UpdateResult> changePhone(String newPhone);
  Future<UpdateResult> changePassword({
    required String currentPassword,
    required String newPassword,
  });
}

class ProfileResult {
  final bool isSuccess;
  final String message;
  final ProfileModel? profile;

  ProfileResult.success(this.profile) : isSuccess = true, message = '';
  ProfileResult.failure(this.message) : isSuccess = false, profile = null;
}

class UpdateResult {
  final bool isSuccess;
  final String message;

  UpdateResult.success({this.message = ''}) : isSuccess = true;
  UpdateResult.failure(this.message) : isSuccess = false;
}
