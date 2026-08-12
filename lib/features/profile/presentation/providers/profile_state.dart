import 'package:restaurants_system/features/profile/data/models/profile_model.dart';

class ProfileState {
  final ProfileModel? profile;
  final String status; // 'loading', 'success', 'error'
  final String message;
  final bool isUpdatingName;
  final bool isUpdatingPassword;
  final bool isUpdatingPhone;

  ProfileState({
    this.profile,
    this.status = '',
    this.message = '',
    this.isUpdatingName = false,
    this.isUpdatingPassword = false,
    this.isUpdatingPhone = false,
  });

  ProfileState copyWith({
    ProfileModel? profile,
    String? status,
    String? message,
    bool? isUpdatingName,
    bool? isUpdatingPassword,
    bool? isUpdatingPhone,
  }) {
    return ProfileState(
      profile: profile ?? this.profile,
      status: status ?? this.status,
      message: message ?? this.message,
      isUpdatingName: isUpdatingName ?? this.isUpdatingName,
      isUpdatingPassword: isUpdatingPassword ?? this.isUpdatingPassword,
      isUpdatingPhone: isUpdatingPhone ?? this.isUpdatingPhone,
    );
  }
}