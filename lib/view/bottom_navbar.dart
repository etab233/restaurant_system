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
        color:  Color(Constants.backgroundColor),
        border: BoxBorder.all(color:  Color(Constants.orangeColor), width: 1.5),
        borderRadius: BorderRadius.all(Radius.circular(150)),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8 ,vertical: 8),
        child: GNav(
          gap: 8,
          backgroundColor: Color(Constants.backgroundColor),
          color: Colors.black,
          activeColor: Color(Constants.orangeColor),
          tabBackgroundColor: Color(Constants.orangeColor).withOpacity(0.2),
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          haptic: true, // اهتزاز عند اللمس
          //onTabChange:
          tabs: const [
            GButton(icon: Icons.home, text: 'Home', iconSize: 28,),
            GButton(icon: Icons.shopping_cart, text: 'Cart', iconSize: 28,),
            GButton(icon: Icons.favorite, text: 'Favorite', iconSize: 28,),
            GButton(icon: Icons.person, text: 'Profile', iconSize: 28,),
          ],
        ),
      ),
    );
  }
}
