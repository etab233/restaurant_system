import 'package:flutter_riverpod/flutter_riverpod.dart';

final bottomNavbarProvider = NotifierProvider<BottomNavNotifier, int>(
  BottomNavNotifier.new,
);

class BottomNavNotifier extends Notifier<int> {
  @override
  int build() => 0;

  void setIndex(int index) {
    state = index;
  }
}