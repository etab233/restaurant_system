import '../datasources/analyze_label_remote_data_source.dart';
import '../../domain/repositories/analyze_label_repository.dart';

class AnalyzeLabelRepositoryImpl implements AnalyzeLabelRepository {
  final AnalyzeLabelRemoteDataSource _remote;

  AnalyzeLabelRepositoryImpl(this._remote);

  double _extractNumber(String value) {
    final number = RegExp(r'[\d.]+').firstMatch(value);
    if (number != null) return double.parse(number.group(0)!);
    return 0;
  }

  @override
  Future<AnalyzeLabelResult> analyze({
    required String imagePath,
    required String token,
  }) async {
    try {
      final response = await _remote.analyze(
        imagePath: imagePath,
        token: token,
      );

      if (response.containsKey("error")) {
        return AnalyzeLabelResult.failure(response['error']);
      }

      return AnalyzeLabelResult.success(
        calories: _extractNumber(response['calories']),
        protein: _extractNumber(response['protein']),
        fat: _extractNumber(response['fat']),
        carbs: _extractNumber(response['carbs']),
      );
    } catch (e) {
      return AnalyzeLabelResult.failure(
        "Something went wrong. Please try again.",
      );
    }
  }
}
