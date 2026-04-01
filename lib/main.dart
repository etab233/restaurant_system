import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurants_system/view/login-register/welcome.dart';
import 'package:restaurants_system/view/restaurant_page.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Restaurants System',
      home: Welcome(),
      debugShowCheckedModeBanner: false,
    );
  }
}
