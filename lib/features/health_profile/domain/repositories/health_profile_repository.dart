abstract class HealthProfileRepository {
  Future<HealthAccountResult> checkHealthAccount();
  Future<SaveProfileResult> saveUserData({
    required String birthDate,
    required double heightCm,
    required double weightKg,
    required String gender,
    required String activityLevel,
    required String goal,
  });
}

class HealthAccountResult {
  final bool hasAccount;
  final String? birthDate;
  final String? gender;
  final double? heightCm;
  final double? weightKg;
  final String? activityLevel;
  final String? goal;

  HealthAccountResult({
    required this.hasAccount,
    this.birthDate,
    this.gender,
    this.heightCm,
    this.weightKg,
    this.activityLevel,
    this.goal,
  });
}

class SaveProfileResult {
  final bool isSuccess;
  final String? errorMessage;

  SaveProfileResult.success() : isSuccess = true, errorMessage = null;
  SaveProfileResult.failure(this.errorMessage) : isSuccess = false;
}