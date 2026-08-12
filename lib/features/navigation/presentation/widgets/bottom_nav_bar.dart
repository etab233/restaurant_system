// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:restaurants_system/core/navigation/main_tabs.dart';
import 'package:restaurants_system/features/cart/presentation/providers/cart_provider.dart';
import 'package:restaurants_system/features/navigation/presentation/providers/bottom_navigation_bar_provider.dart';
import 'package:restaurants_system/features/navigation/presentation/widgets/nav_item.dart';

class BottomNavBar extends ConsumerWidget {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;
    final currentTab = ref.watch(bottomNavbarProvider);
    final notifier = ref.read(bottomNavbarProvider.notifier);
    final cartState = ref.watch(cartNotifierProvider);

    final cartCount = cartState.items.length;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: colors.surface,
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 12),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            NavItem(
              icon: const Icon(Icons.home),
              label: 'Home',
              isSelected: currentTab == MainTab.home,
              activeColor: colors.primary,
              onTap: () => notifier.setTab(MainTab.home),
            ),
            NavItem(
              icon: const Icon(Icons.shopping_cart),
              label: 'Cart',
              isSelected: currentTab == MainTab.cart,
              activeColor: colors.primary,
              onTap: () => notifier.setTab(MainTab.cart),
              badgeCount: cartCount,
            ),

            NavItem(
              icon: const FaIcon(FontAwesomeIcons.seedling),
              label: 'Nutrition',
              isSelected: currentTab == MainTab.nutrition,
              activeColor: colors.primary,
              onTap: () => notifier.setTab(MainTab.nutrition),
            ),

            NavItem(
              icon: const Icon(Icons.favorite),
              label: 'Favorite',
              isSelected: currentTab == MainTab.favorite,
              activeColor: colors.primary,
              onTap: () => notifier.setTab(MainTab.favorite),
            ),
            NavItem(
              //icon: Icon(Icons.receipt_long_rounded),
              icon: const FaIcon(FontAwesomeIcons.bagShopping),
              label: 'Order',
              isSelected: currentTab == MainTab.order,
              activeColor: colors.primary,
              onTap: () => notifier.setTab(MainTab.order),
            ),
          ],
        ),
      ),
    );
  }
}
