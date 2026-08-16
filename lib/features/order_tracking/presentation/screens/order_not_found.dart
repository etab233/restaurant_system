// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:restaurants_system/features/order_tracking/presentation/providers/order_track/order_track_provider.dart';

class OrderNotFound extends ConsumerStatefulWidget {
  const OrderNotFound({super.key});

  @override
  ConsumerState<OrderNotFound> createState() =>
      OrderNotFoundState();
}

class OrderNotFoundState extends ConsumerState<OrderNotFound> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(.08),
                shape: BoxShape.circle,
              ),
              child: Image.asset(
                "assets/images/order_not_found.webp",
                fit: BoxFit.cover,
              ),
            ),

            const SizedBox(height: 32),

            const Text(
              "Nothing to Show",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 12),

            Text(
              "There's nothing available right now. Please check your connection, sign in, or try again later",
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
                  String? token = Hive.box("user_data").get("token");
                  if(token == null) return;
                  ref.read(orderTrackNotifierProvider.notifier).getOrders();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:const Color(0xFFFF6B35),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: const Text(
                  "Refresh",
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
