import 'package:flutter/material.dart';
import 'login-register/view/welcome.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(const ProviderScope(child:MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Restaurants System',
      home: Welcome(),
      debugShowCheckedModeBanner: false,
    );
  }
}