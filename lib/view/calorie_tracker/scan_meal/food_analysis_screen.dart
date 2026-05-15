// ─────────────────────────────────────────────────────────────
// This screen is built around 3 main states:
//
// 1) _buildAnalyzing:
//    Shown when the image is successfully sent to the server
//    and the app is waiting for a response (loading state)
//
// 2) _buildError:
//    Shown when an error occurs during the upload
//    or if the request to the server fails
//
// 3) _buildResults:
//    Shown when the server responds successfully
//    and returns the analysis results
// ─────────────────────────────────────────────────────────────

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurants_system/models/food_item.dart';
import 'package:restaurants_system/services/api/analyze_meal_services.dart';
import 'package:restaurants_system/view/calorie_tracker/dashboard/dashboard_main_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FoodAnalysisScreen extends ConsumerStatefulWidget {
  final String imagePath;
  const FoodAnalysisScreen({super.key, required this.imagePath});
  @override
  ConsumerState<FoodAnalysisScreen> createState() => FoodAnalysisScreenState();
}

class FoodAnalysisScreenState extends ConsumerState<FoodAnalysisScreen>
    with TickerProviderStateMixin {
  bool _loading = true;
  bool _added = false;
  String? _error;
  FoodItem? _result;

  // colors
  static const _green = Color(0xFF4A7A2E);
  static const _orange = Color(0xFFFF6B35);

  // Animations
  late AnimationController _spinController;
  late AnimationController _resultCtrl;

  final List _steps = [
    "Photo received",
    "Dish identified",
    "Calculating nutrients",
    "Preparing results",
  ];
  int _stepDone = 0;

  @override
  initState() {
    super.initState();
    _spinController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    )..repeat();

    _resultCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    analyze();
  }

  @override
  void dispose() {
    _resultCtrl.dispose();
    _spinController.dispose();
    super.dispose();
  }

  Future<void> analyze() async {
    // Simulate step progress
    for (int i = 0; i < _steps.length - 1; i++) {
      await Future.delayed(const Duration(milliseconds: 800));
      if (mounted) setState(() => _stepDone = i + 1);
    }

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");
    try {
      final result = await AnalyzeMealServices().analyze(
        imagePath: widget.imagePath,
        token: token!,
      );
      if (mounted) {
        setState(() {
          _result = result;
          _loading = false;
          _stepDone = _steps.length;
        });
        _resultCtrl.forward();
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _loading = false;
      });
      debugPrint(_error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _loading
          ? const Color(0xFF0F1117)
          : const Color(0xFFF5F5F0),
      body: _loading
          ? _buildAnalyzing()
          : _error != null
          ? _buildError()
          : _buildResults(),
    );
  }

  Widget _buildAnalyzing() => SafeArea(
    child: Padding(
      padding: const EdgeInsets.all(30),
      child: Column(
        children: [
          // food pic + spinner
          Stack(
            children: [
              Container(
                width: 130,
                height: 130,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: FileImage(File(widget.imagePath)),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              AnimatedBuilder(
                animation: _spinController,
                builder: (_, __) => Transform.rotate(
                  angle: _spinController.value * 6.28,
                  child: Container(
                    width: 148,
                    height: 148,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.transparent, width: 3),
                      gradient: SweepGradient(
                        colors: [Color(0xFFFF6B35), Colors.transparent],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 28),
          const Text(
            "Analyzing your meal...",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            "AI is identifying nutrients",
            style: TextStyle(fontSize: 16, color: Colors.white38),
          ),

          const SizedBox(height: 28),

          ...List.generate(_steps.length, (i) {
            final done = i < _stepDone;
            final active = i == _stepDone && i < _steps.length;

            return Padding(
              padding: EdgeInsets.symmetric(vertical: 5),
              child: Row(
                children: [
                  AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: done
                          ? Color(0xFF4A7A2E)
                          : active
                          ? Color(0xFFFF6B35)
                          : Colors.white12,
                    ),
                    child: done
                        ? Icon(Icons.done_rounded)
                        : Text(
                            "${i + 1}",
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                              color: (done || active)
                                  ? Colors.white
                                  : Colors.white30,
                            ),
                          ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    _steps[i],
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: done
                          ? Colors.white
                          : active
                          ? Colors.white70
                          : Colors.white24,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    ),
  );

  Widget _buildResults() => SafeArea(
    child: SingleChildScrollView(
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                height: 220,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: FileImage(File(widget.imagePath)),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                child: InkWell(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          content: Text(
                            "Are you sure you want to discard this meal?",
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text("No"),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => Dashboard(),
                                  ),
                                );
                              },
                              child: Text("Yes"),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Icon(Icons.close, color: Colors.black),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            _result!.description!,
            style: const TextStyle(fontSize: 12, color: Colors.white70),
          ),
          const SizedBox(height: 14),

          // Calories Hero
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Color(0xFF4A7A2E),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/fire.png',
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
                const SizedBox(width: 14),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "TOTAL CALORIES",
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.white70,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      "${_result!.calories}",
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          // Macros grid
          GridView.count(
            crossAxisCount: 3,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            children: [
              macroCard(
                label: "Protein",
                val: "${_result!.protein!} g",
                color: const Color(0xFF4A7A2E),
                bg: const Color(0xFFE8F5E9),
              ),
              macroCard(
                label: "Carbs",
                val: "${_result!.carbs!} g",
                color: const Color(0xFFF5A623),
                bg: const Color(0xFFFFFDE7),
              ),
              macroCard(
                label: "Fat",
                val: "${_result!.fat!} g",
                color: const Color(0xFFE05C5C),
                bg: const Color(0xFFFCE4EC),
              ),
            ],
          ),

          // Add button
          Container(
            padding: EdgeInsets.fromLTRB(
              16,
              12,
              16,
              MediaQuery.of(context).padding.bottom + 12,
            ),
            color: const Color(0xFFF5F5F0),
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _added ? _green : _orange,
                      disabledBackgroundColor: _green,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      _added ? "✓ Added to dashboard!" : "+ Add to Dashboard",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Text(
                    "Not right? Retake photo",
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );

  Widget _buildError() => Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.error_outline_rounded, size: 48, color: Colors.red),
        const SizedBox(height: 12),
        const Text("Couldn't analyze the photo"),
        const SizedBox(height: 12),
        ElevatedButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Try again"),
        ),
      ],
    ),
  );
}

Widget macroCard({
  required String label,
  required String val,
  required Color color,
  required Color bg,
}) => Expanded(
  child: Container(
    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
    ),
    child: Column(
      children: [
        Text(
          val,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w800,
            color: color,
          ),
        ),
        Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey)),
      ],
    ),
  ),
);
