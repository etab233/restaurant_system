/*
MainScreen
 ├── HomeScreen
 ├── CartScreen
 ├── FavoriteScreen
 └── ProfileScreen
 */
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurants_system/providers/bottom_navbar_provider.dart';
import 'package:restaurants_system/view/bottom_navbar.dart';
import 'package:restaurants_system/view/cart/cart_restaurants_screen.dart';
import 'package:restaurants_system/view/favorites.dart';
import 'package:restaurants_system/view/home/home.dart';

class MainScreen extends ConsumerStatefulWidget {
  final int initialIndex;
  const MainScreen({super.key, this.initialIndex =0});
  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  final List<Widget> screens = [
    Home(),
    CartRestaurantsScreen(),
    Favorites(),
    //ProfileScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    int currentIndex = ref.watch(bottomNavbarProvider);
    return Scaffold(
      body: IndexedStack(index: currentIndex, children: screens),
      bottomNavigationBar: BottomNavBar(),
    );
  }
}
