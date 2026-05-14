import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurants_system/notifier/analyze_meal_notifier.dart';

final analyzeMealProvider =
    NotifierProvider<AnalyzeMealNotifier, AnalyzeMealState>(
  () => AnalyzeMealNotifier(),
);