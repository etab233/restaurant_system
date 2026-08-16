import '../datasources/dashboard_local_data_source.dart';
import '../../domain/repositories/dashboard_repository.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  final DashboardLocalDataSource _local;

  DashboardRepositoryImpl(this._local);

  @override
  Future<String?> getCurrentToken() => _local.getToken();

  @override
  CachedMacros getSavedMacros() => _local.getSavedMacros();

  @override
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
  }) {
    return _local.saveMacros(
      calories: calories,
      protein: protein,
      carbs: carbs,
      fat: fat,
      fiber: fiber,
      sugars: sugars,
      sodium: sodium,
      potassium: potassium,
      calcium: calcium,
      vitaminC: vitaminC,
      iron: iron,
      vitaminA: vitaminA,
    );
  }
}