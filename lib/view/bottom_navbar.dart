import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:restaurants_system/constants.dart';

class BottomNavBar extends ConsumerStatefulWidget {
  const BottomNavBar({super.key});
  @override
  ConsumerState<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends ConsumerState<BottomNavBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFFFF6B00).withOpacity(0.15),
        //border: BoxBorder.all(color:  Colors.grey, width: 1.5),
        borderRadius: BorderRadius.all(Radius.circular(30)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: GNav(
          gap: 8,
          //backgroundColor: Color(Constants.backgroundColor),
          color: Colors.black87,
          activeColor: Color(Constants.orangeColor),
          tabBackgroundColor: Color(Constants.orangeColor).withOpacity(0.2),
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          haptic: true, // اهتزاز عند اللمس
          //onTabChange:
          tabs: const [
            GButton(icon: Icons.home, text: 'Home', iconSize: 28),
            GButton(icon: Icons.shopping_cart, text: 'Cart', iconSize: 28),
            GButton(icon: Icons.favorite, text: 'Favorite', iconSize: 28),
            GButton(icon: Icons.person, text: 'Profile', iconSize: 28),
          ],
        ),
      ),
    );
  }
}
