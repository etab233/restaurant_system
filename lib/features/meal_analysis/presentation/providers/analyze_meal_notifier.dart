import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurants_system/features/meal_analysis/data/datasources/analyze_meal_remote_data_souce.dart';
import '../../data/repositories/analyze_meal_repository_impl.dart';
import '../../domain/repositories/analyze_meal_repository.dart';
import 'analyze_meal_state.dart';

final analyzeMealRepositoryProvider = Provider<AnalyzeMealRepository>((ref) {
  return AnalyzeMealRepositoryImpl(AnalyzeMealRemoteDataSource());
});

final analyzeMealProvider = NotifierProvider<AnalyzeMealNotifier, AnalyzeMealState>(
  AnalyzeMealNotifier.new,
);

class AnalyzeMealNotifier extends Notifier<AnalyzeMealState> {
  late AnalyzeMealRepository _repository;

  @override
  AnalyzeMealState build() {
    _repository = ref.read(analyzeMealRepositoryProvider);
    return const AnalyzeMealState();
  }

  Future<void> analyze({
    required String imagePath,
    String? description,
    required String token,
  }) async {
    state = const AnalyzeMealState(analyzeStatus: Status.loading, message: "");

    final result = await _repository.analyze(
      imagePath: imagePath,
      description: description,
      token: token,
    );

    state = result.isSuccess
        ? state.copyWith(
            name: result.name,
            description: result.description,
            calories: result.calories,
            protein: result.protein,
            carbs: result.carbs,
            fat: result.fat,
            confidence: result.confidence,
            message: result.message,
            analyzeStatus: Status.success,
          )
        : state.copyWith(analyzeStatus: Status.error, message: result.message);
  }
}