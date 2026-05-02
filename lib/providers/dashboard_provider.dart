import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurants_system/models/dashboard_model.dart';
import 'package:restaurants_system/notifier/dashboard_notifier.dart' show DashboardNotifier;

final dashboardProvider =
    NotifierProvider<DashboardNotifier, DashboardModel>(
  DashboardNotifier.new,
);
