import 'package:hive/hive.dart';
import 'package:restaurants_system/features/profile/data/models/profile_model.dart';

class ProfileLocalDataSource {
  Box get _box => Hive.box("user_data");

  ProfileModel? getCachedProfile() {
    final raw = _box.get("userData");

    if (raw == null) return null;

    Map<String, dynamic> userData;

    userData = Map<String, dynamic>.from(raw);

    return ProfileModel.fromJson(userData);
  }

  Future<void> saveProfile(ProfileModel profile) async {
    await _box.put("userData", profile.toJson());
  }
}
