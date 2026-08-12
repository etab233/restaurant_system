import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurants_system/core/navigation/main_tabs.dart';
import 'package:restaurants_system/features/health_profile/presentation/screens/welcome_screen.dart';
import 'package:restaurants_system/features/cart/presentation/providers/cart_provider.dart';
import 'package:restaurants_system/features/cart/presentation/screens/restaurant_cart_screen.dart';
import 'package:restaurants_system/features/favorites/presentation/screens/favorites_screen.dart';
import 'package:restaurants_system/features/home/presentation/screens/home.dart';
import 'package:restaurants_system/features/navigation/presentation/providers/bottom_navigation_bar_provider.dart';
import 'package:restaurants_system/features/navigation/presentation/widgets/bottom_nav_bar.dart';
import 'package:restaurants_system/features/order_tracking/presentation/providers/order_track/order_track_provider.dart';
import 'package:restaurants_system/features/order_tracking/presentation/screens/my_orders.dart';

class MainScreen extends ConsumerStatefulWidget {
  final MainTab initialTab;
  const MainScreen({super.key, this.initialTab = MainTab.home});

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  final List<Widget> screens = const [
    Home(),
    CartRestaurantsScreen(),
    Welcome(),
    FavoritesScreen(),
    MyOrders(),
  ];

  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      ref.read(bottomNavbarProvider.notifier).setTab(widget.initialTab);

      // تحميل السلة مباشرة عند فتح MainScreen
      await ref.read(cartNotifierProvider.notifier).index();
    });
    _listenToTabChanges();
  }

  void _listenToTabChanges() {
    ref.listenManual<MainTab>(bottomNavbarProvider, (previous, next) async {
      /*// Cart
      if (previous != MainTab.cart && next == MainTab.cart) {
        await ref.read(cartNotifierProvider.notifier).index();
      }*/

      // Orders
      if (previous != MainTab.order && next == MainTab.order) {
        final notifier = ref.read(orderTrackNotifierProvider.notifier);
        await notifier.startTracking();
        await notifier.refreshOrders();
      }

      // Leave Orders
      if (previous == MainTab.order && next != MainTab.order) {
        await ref.read(orderTrackNotifierProvider.notifier).stopTracking();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentTab = ref.watch(bottomNavbarProvider);

    return Scaffold(
      body: IndexedStack(index: currentTab.index, children: screens),
      bottomNavigationBar:const  BottomNavBar(),
    );
  }
}
