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
  }) {
    return _local.saveMacros(
      calories: calories,
      protein: protein,
      carbs: carbs,
      fat: fat,
    );
  }
}
