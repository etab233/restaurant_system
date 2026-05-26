// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:restaurants_system/models/category_model.dart';
import 'package:restaurants_system/models/restaurant_model.dart';
import 'package:restaurants_system/view/home/home.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurants_system/view/main_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ),
  );

  Hive.registerAdapter(RestaurantModelAdapter());
  Hive.registerAdapter(RestaurantHoursAdapter());
  Hive.registerAdapter(RestaurantLocationAdapter());
  Hive.registerAdapter(CategoryAdapter());

  await Hive.openBox<RestaurantModel>("restaurantsBox");
  await Hive.openBox<Category>("categoriesBox");
  await Hive.openBox('locationBox');

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.light;

  void _toggleTheme() {
    setState(() {
      _themeMode = _themeMode == ThemeMode.light
          ? ThemeMode.dark
          : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Restaurants System',
      home: MainScreen(),
      theme: ThemeData(
        colorScheme: ColorScheme(
          brightness: Brightness.light,

          primary: const Color(0xFFFF6B35),
          onPrimary: Colors.white,

          secondary: const Color(0xFFFFA07A),
          onSecondary: Colors.black,

          background: const Color(0xFFF8F8F8),
          onBackground: Colors.black,

          surface: Colors.white,
          onSurface: Colors.black87,

          error: Colors.red,
          onError: Colors.white,

          shadow: Colors.black.withOpacity(0.06),
        ),
      ),

      darkTheme: ThemeData(
        colorScheme: ColorScheme(
          brightness: Brightness.dark,

          primary: const Color(0xFFFF6B35),
          onPrimary: Colors.white,

          secondary: const Color(0xFFFFA07A),
          onSecondary: Colors.black,

          background: const Color(0xFF121212),
          onBackground: Colors.white,

          surface: const Color(
            0xFF1E1E1E,
          ), // لون الخلفيات الداخلية( التي تكون فوق الخلفية الأساسية)
          onSurface: Colors.white70, // النصوص و الأيقونات فوق الخلفيات الداخلية

          error: Colors.red,
          onError: Colors.white,

          shadow: Colors.black.withOpacity(0.4),
        ),
      ),

      themeMode: _themeMode,
      debugShowCheckedModeBanner: false,
    );
  }
}
