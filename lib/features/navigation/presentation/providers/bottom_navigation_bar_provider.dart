import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurants_system/core/navigation/main_tabs.dart';

class BottomNavNotifier extends Notifier<MainTab> {
  @override
  MainTab build() {
    return MainTab.home;
  }

  void setTab(MainTab tab) {
    state = tab;
  }
}

final bottomNavbarProvider = NotifierProvider<BottomNavNotifier, MainTab>(
  BottomNavNotifier.new,
);
