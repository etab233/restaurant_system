import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/dashboard_local_data_source.dart';
import '../../data/models/dashboard_model.dart';
import '../../data/repositories/dashboard_repository_impl.dart';
import '../../domain/repositories/dashboard_repository.dart';

final dashboardRepositoryProvider = Provider<DashboardRepository>((ref) {
  return DashboardRepositoryImpl(DashboardLocalDataSource());
});

final dashboardProvider = NotifierProvider<DashboardNotifier, DashboardModel>(
  DashboardNotifier.new,
);

class DashboardNotifier extends Notifier<DashboardModel> {
  late DashboardRepository _repository;

  @override
  DashboardModel build() {
    _repository = ref.read(dashboardRepositoryProvider);

    // تحميل القيم المحفوظة تلقائيًا عند أول إنشاء للـ provider
    // بدل ما تحتاج الشاشة تستدعيها يدويًا بـ initState
    final cached = _repository.getSavedMacros();
    return DashboardModel(
      calories: cached.calories,
      protein: cached.protein,
      carbs: cached.carbs,
      fat: cached.fat,
      fiber: cached.fiber,
      sugars: cached.sugars,
      sodium: cached.sodium,
      potassium: cached.potassium,
      calcium: cached.calcium,
      vitaminC: cached.vitaminC,
      iron: cached.iron,
      vitaminA: cached.vitaminA,
    );
  }

  void addMeal({
    required double calories,
    required double protein,
    required double carbs,
    required double fat,
    double fiber = 0,
    double sugars = 0,
    double sodium = 0,
    double potassium = 0,
    double calcium = 0,
    double vitaminC = 0,
    double iron = 0,
    double vitaminA = 0,
  }) {
    state = state.copyWith(
      calories: state.calories + calories,
      protein: state.protein + protein,
      carbs: state.carbs + carbs,
      fat: state.fat + fat,
      fiber: state.fiber + fiber,
      sugars: state.sugars + sugars,
      sodium: state.sodium + sodium,
      potassium: state.potassium + potassium,
      calcium: state.calcium + calcium,
      vitaminC: state.vitaminC + vitaminC,
      iron: state.iron + iron,
      vitaminA: state.vitaminA + vitaminA,
    );
  }

  void removeMeal(int index) {
    if (index < 0 || index >= state.meals.length) return;
    final updated = [...state.meals]..removeAt(index);
    state = state.copyWith(meals: updated);
  }

  Future<void> addMealAndPersist({
    required double calories,
    required double protein,
    required double carbs,
    required double fat,
    double fiber = 0,
    double sugars = 0,
    double sodium = 0,
    double potassium = 0,
    double calcium = 0,
    double vitaminC = 0,
    double iron = 0,
    double vitaminA = 0,
  }) async {
    addMeal(calories: calories, protein: protein, carbs: carbs, fat: fat);
    await _repository.saveMacros(
      calories: state.calories,
      protein: state.protein,
      carbs: state.carbs,
      fat: state.fat,
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