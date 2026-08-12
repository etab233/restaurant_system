import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/analyze_label_remote_data_source.dart';
import '../../data/repositories/analyze_label_repository_impl.dart';
import '../../domain/repositories/analyze_label_repository.dart';
import 'analyze_label_state.dart';

final analyzeLabelRepositoryProvider = Provider<AnalyzeLabelRepository>((ref) {
  return AnalyzeLabelRepositoryImpl(AnalyzeLabelRemoteDataSource());
});

final analyzeLabelProvider = NotifierProvider<AnalyzeLabelNotifier, AnalyzeLabelState>(
  AnalyzeLabelNotifier.new,
);

class AnalyzeLabelNotifier extends Notifier<AnalyzeLabelState> {
  late AnalyzeLabelRepository _repository;

  @override
  AnalyzeLabelState build() {
    _repository = ref.read(analyzeLabelRepositoryProvider);
    return const AnalyzeLabelState();
  }

  Future<void> analyze({required String imagePath, required String token}) async {
    final result = await _repository.analyze(imagePath: imagePath, token: token);

    state = result.isSuccess
        ? state.copyWith(
            calories: result.calories,
            protein: result.protein,
            fat: result.fat,
            carbs: result.carbs,
            success: true,
            message: result.message,
          )
        : state.copyWith(success: false, message: result.message);
  }
}