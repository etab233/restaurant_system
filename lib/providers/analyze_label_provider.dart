import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurants_system/notifier/analyze_label_notifier.dart';

final analyzeLabelProvider =
    NotifierProvider<AnalyzeLabelNotifier, AnalyzeLabelState>(
  () => AnalyzeLabelNotifier(),
);