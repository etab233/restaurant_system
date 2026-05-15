import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurants_system/notifier/health_profile_notifier.dart';

final healthProfileProvider =
    NotifierProvider<HealthProfileNotifier, HealthProfileState>(
      HealthProfileNotifier.new,
    );
