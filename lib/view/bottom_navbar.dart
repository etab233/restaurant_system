import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class BottomNavBar extends ConsumerStatefulWidget{
  const BottomNavBar({super.key});
  @override
  ConsumerState<BottomNavBar> createState() =>_BottomNavBarState();
} 

class _BottomNavBarState extends ConsumerState<BottomNavBar>{
  @override
  Widget build(BuildContext context){
    return Container(
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.all(Radius.circular(150)),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          child: GNav(
            gap: 8,
            backgroundColor: Colors.black,
            color: Colors.white,
            activeColor: Colors.white,
            tabBackgroundColor: Colors.grey.shade800,
            padding: EdgeInsets.all(15),
            haptic: true, // اهتزاز عند اللمس
            //onTabChange:
            tabs: const [
              GButton(icon: Icons.home, text: 'Home'),
              GButton(icon: Icons.shopping_cart, text: 'Cart'),
              GButton(icon: Icons.favorite, text: 'Favorite'),
              GButton(icon: Icons.person, text: 'Profile'),
            ],
          ),
        ),
      );
  }
}