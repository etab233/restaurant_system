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
import 'package:restaurants_system/view/home/home.dart';

class MainScreen extends ConsumerStatefulWidget{
  const MainScreen({super.key});
  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}
class _MainScreenState extends ConsumerState<MainScreen>{

  final List<Widget> screens = [
    Home(),
    //CartScreen(),
    //FavoriteScreen(),
    //ProfileScreen(),
  ];
  @override  
  Widget build(BuildContext context){
    int currentIndex = ref.watch(bottomNavbarProvider); 
    return Scaffold(
      body: screens[currentIndex],
      bottomNavigationBar: BottomNavBar(),
    );
  }
}