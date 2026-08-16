// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurants_system/core/navigation/main_tabs.dart';
import 'package:restaurants_system/features/auth/presentation/screens/login.dart';
import 'package:restaurants_system/features/navigation/presentation/providers/bottom_navigation_bar_provider.dart';

class LoginRequiredCartView extends ConsumerStatefulWidget {
  const LoginRequiredCartView({super.key});

  @override
  ConsumerState<LoginRequiredCartView> createState() =>
      LoginRequiredCartViewState();
}

class LoginRequiredCartViewState extends ConsumerState<LoginRequiredCartView> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Cart Illustration
            Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(.08),
                shape: BoxShape.circle,
              ),
              child: Image.asset(
                "assets/images/locked_cart.webp",
                fit: BoxFit.cover,
              ),
            ),

            const SizedBox(height: 32),

            const Text(
              "Your cart is waiting",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 12),

            Text(
              "Sign in to view your carts, save favorite meals and track your orders.",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 15,
                height: 1.5,
              ),
            ),

            const SizedBox(height: 32),

            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const Login(redirectTo: LoginRedirect.cart,),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:const  Color(0xFFFF6B35),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: const Text(
                  "Login",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ),
            ),

            const SizedBox(height: 12),

            SizedBox(
              width: double.infinity,
              height: 56,
              child: OutlinedButton(
                onPressed: () {
                  ref.read(bottomNavbarProvider.notifier).setTab(MainTab.home);
                },
                style: OutlinedButton.styleFrom(
                  side:const  BorderSide(color: Colors.grey),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: const Text(
                  "Browse Restaurants",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
