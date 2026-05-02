int calculateAge(DateTime birthDate) {
  final today = DateTime.now();
  int age = today.year - birthDate.year;
  if (today.month < birthDate.month ||
      (today.month == birthDate.month && today.day < birthDate.day)) {
    age--;
  }
  return age;
}

double calculateBMR({
  required double w,
  required double h,
  required String gender,
  required int age,
}) {
  if(gender == "Male"){
    return ((10*w)+(6.25*h)-(5*age)+5);
  }
  return ((10*w)+(6.25*h)-(5*age)-161);
}

double determineTDEE({required double bmr, required String activityLevel}){
  switch(activityLevel){
    case "Sedentary": return 1.2*bmr;
    case "Lightly Active": return 1.375*bmr;
    case "Moderately Active": return 1.55*bmr;
    case "Very Active": return 1.725*bmr;
    case "Super Active": return 1.9*bmr;
    default : return 1.2*bmr;
  }
}

double calculatingDailyCalorieNeeds({required String goal, required double tdee}){
  switch(goal){
    case "Lose Weight": return tdee -500;
    case "Maintain": return tdee;
    case "Gain Weight": return tdee+300;
    default: return tdee;
  }
}

double calculateDailyProtein({
  required double weightKg,
  required String goal, // lose, maintain, gain
}) {
  double proteinPerKg;

  switch (goal) {
    case "Lose Weight":
      proteinPerKg = 2.0; // أعلى للحفاظ على العضلات
      break;
    case "Gain Weight":
      proteinPerKg = 1.8;
      break;
    default:
      proteinPerKg = 1.6;
  }

  return weightKg * proteinPerKg;
}

double calculateDailyFat({
  required double weightKg,
}) {
  return weightKg * 0.9;
}

double calculateDailyCarbs({
  required double calories,
  required double proteinGrams,
  required double fatGrams,
}) {
  double proteinCalories = proteinGrams * 4;
  double fatCalories = fatGrams * 9;

  double remainingCalories = calories - (proteinCalories + fatCalories);

  return remainingCalories / 4;
}