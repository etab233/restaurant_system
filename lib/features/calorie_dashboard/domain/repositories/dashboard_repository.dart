import '../../data/datasources/dashboard_local_data_source.dart';

abstract class DashboardRepository {
  Future<String?> getCurrentToken();

  CachedMacros getSavedMacros();

  Future<void> saveMacros({
    required double calories,
    required double protein,
    required double carbs,
    required double fat,
    required double fiber,
    required double sugars,
    required double sodium,
    required double potassium,
    required double calcium,
    required double vitaminC,
    required double iron,
    required double vitaminA,
  });
}