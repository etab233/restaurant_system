class HealthProfileState {
  final String? birthDate;
  final double heightCm;
  final double weightKg;
  final String gender;
  final String activityLevel;
  final String goal;

  const HealthProfileState({
    this.birthDate,
    this.gender = "",
    this.heightCm = 0.0,
    this.weightKg = 0.0,
    this.goal = "",
    this.activityLevel = "",
  });

  HealthProfileState copyWith({
    String? birthDate,
    double? heightCm,
    double? weightKg,
    String? gender,
    String? activityLevel,
    String? goal,
  }) {
    return HealthProfileState(
      birthDate: birthDate ?? this.birthDate,
      heightCm: heightCm ?? this.heightCm,
      weightKg: weightKg ?? this.weightKg,
      gender: gender ?? this.gender,
      goal: goal ?? this.goal,
      activityLevel: activityLevel ?? this.activityLevel,
    );
  }
}