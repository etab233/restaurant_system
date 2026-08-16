// ignore_for_file: must_be_immutable

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurants_system/features/auth/presentation/providers/auth_provider.dart';
import 'package:restaurants_system/features/calorie_dashboard/presentation/providers/dashboard_notifier.dart';
import 'package:restaurants_system/features/calorie_dashboard/presentation/screens/dashboard_screen.dart';
import '../providers/analyze_meal_notifier.dart';
import '../providers/analyze_meal_state.dart';

class FoodAnalysisScreen extends ConsumerStatefulWidget {
  final String imagePath;
  String? description;
  FoodAnalysisScreen({super.key, required this.imagePath, this.description});
  @override
  ConsumerState<FoodAnalysisScreen> createState() => _FoodAnalysisScreenState();
}

class _FoodAnalysisScreenState extends ConsumerState<FoodAnalysisScreen>
    with TickerProviderStateMixin {
  bool _isAdding = false;
  bool _added = false;

  static const _green = Color(0xFF4A7A2E);
  static const _orange = Color(0xFFFF6B35);

  late AnimationController _spinController;
  late AnimationController _resultCtrl;

  final List<String> _steps = [
    "Photo received",
    "Dish identified",
    "Calculating nutrients",
    "Preparing results",
  ];
  int _stepDone = 0;

  @override
  void initState() {
    super.initState();
    _spinController = AnimationController(vsync: this, duration: const Duration(seconds: 3))
      ..repeat();
    _resultCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));

    analyze();
  }

  @override
  void dispose() {
    _resultCtrl.dispose();
    _spinController.dispose();
    super.dispose();
  }

  Future<void> analyze() async {
    for (int i = 0; i < _steps.length - 1; i++) {
      await Future.delayed(const Duration(milliseconds: 800));
      if (mounted) setState(() => _stepDone = i + 1);
    }

    final token = await ref.read(authRepositoryProvider).getCurrentToken();
    if (token == null) return;

    final analyzeMealState = ref.read(analyzeMealProvider.notifier);
    try {
      await analyzeMealState.analyze(
        imagePath: widget.imagePath,
        description: widget.description,
        token: token,
      );
      if (mounted) {
        setState(() {
          _stepDone = _steps.length;
        });
        _resultCtrl.forward();
      }
    } catch (e) {
      if (!mounted) return;
    }
  }

  @override
  Widget build(BuildContext context) {
    final analyzeMealState = ref.watch(analyzeMealProvider);

    return Scaffold(
      backgroundColor:
          analyzeMealState.analyzeStatus == Status.loading ||
                  analyzeMealState.analyzeStatus == Status.initial
              ? const Color(0xFF0F1117)
              : const Color(0xFFF5F5F0),
      body: analyzeMealState.analyzeStatus == Status.loading ||
              analyzeMealState.analyzeStatus == Status.initial
          ? _buildAnalyzing()
          : analyzeMealState.analyzeStatus == Status.success
              ? _buildResults(analyzeMealState)
              : _buildError(analyzeMealState.message),
    );
  }

  Widget _buildAnalyzing() => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  RotationTransition(
                    turns: _spinController,
                    child: const SizedBox(
                      width: 149,
                      height: 149,
                      child: CircularProgressIndicator(
                        strokeWidth: 5,
                        valueColor: AlwaysStoppedAnimation(Color(0xFFFF6B35)),
                        backgroundColor: Colors.transparent,
                      ),
                    ),
                  ),
                  ClipOval(
                    child: Image.file(
                      File(widget.imagePath),
                      width: 142,
                      height: 142,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 28),
              const Text(
                "Analyzing your meal...",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Colors.white),
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
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Row(
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        width: 22,
                        height: 22,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: done
                              ? const Color(0xFF4A7A2E)
                              : active
                                  ? const Color(0xFFFF6B35)
                                  : Colors.white12,
                        ),
                        child: done
                            ? const Icon(Icons.done_rounded)
                            : Text(
                                "${i + 1}",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: (done || active) ? Colors.white : Colors.white30,
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

  Widget _buildResults(AnalyzeMealState analyzeMealState) => SafeArea(
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
                    top: 15,
                    left: 15,
                    child: InkWell(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              content: const Text("Discard this meal?"),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text("No"),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(builder: (_) => const DashboardScreen()),
                                    );
                                  },
                                  child: const Text("Yes"),
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
                        child: const Icon(Icons.close, color: Colors.black),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: Column(
                  children: [
                    Text(
                      analyzeMealState.name.isEmpty ? "Unknown meal" : analyzeMealState.name,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Colors.black87),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      analyzeMealState.description,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: analyzeMealState.confidence.toLowerCase() == "high"
                            ? Colors.green.shade100
                            : analyzeMealState.confidence.toLowerCase() == "medium"
                                ? Colors.orange.shade100
                                : Colors.red.shade100,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        "Confidence: ${analyzeMealState.confidence}",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: analyzeMealState.confidence.toLowerCase() == "high"
                              ? Colors.green.shade800
                              : analyzeMealState.confidence.toLowerCase() == "medium"
                                  ? Colors.orange.shade800
                                  : Colors.red.shade800,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF4A7A2E),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Row(
                        children: [
                          Image.asset('assets/images/fire.webp', width: 70, height: 70),
                          const SizedBox(width: 14),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "TOTAL CALORIES",
                                style: TextStyle(fontSize: 14, color: Colors.white70, fontWeight: FontWeight.w700),
                              ),
                              Text(
                                "${analyzeMealState.calories.toInt()}",
                                style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: Colors.white),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 15),
                    GridView.count(
                      crossAxisCount: 3,
                      shrinkWrap: true,
                      mainAxisSpacing: 15,
                      crossAxisSpacing: 15,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        _macroCard(
                          label: "Protein",
                          val: "${analyzeMealState.protein.toInt()} g",
                          color: const Color(0xFF4A7A2E),
                        ),
                        _macroCard(
                          label: "Carbs",
                          val: "${analyzeMealState.carbs.toInt()} g",
                          color: const Color(0xFFF5A623),
                        ),
                        _macroCard(
                          label: "Fat",
                          val: "${analyzeMealState.fat.toInt()} g",
                          color: const Color(0xFFE05C5C),
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: (_isAdding || _added)
                            ? null
                            : () async {
                                setState(() {
                                  _isAdding = true;
                                });

                                try {
                                  await ref.read(dashboardProvider.notifier).addMealAndPersist(
                                        calories: analyzeMealState.calories,
                                        protein: analyzeMealState.protein,
                                        carbs: analyzeMealState.carbs,
                                        fat: analyzeMealState.fat,
                                      );

                                  setState(() {
                                    _added = true;
                                  });
                                } catch (e) {
                                  debugPrint("Add meal error: $e");
                                } finally {
                                  setState(() {
                                    _isAdding = false;
                                  });
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _added ? _green : _orange,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                        child: _isAdding
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                              )
                            : Text(
                                _added ? "✓ Added to dashboard!" : "+ Add to Dashboard",
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Colors.white),
                              ),
                      ),
                    ),
                    const SizedBox(height: 20),
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

  Widget _buildError(String message) => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline_rounded, size: 48, color: Colors.red),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(message),
            ),
            const SizedBox(height: 15),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Try again"),
            ),
          ],
        ),
      );

  Widget _macroCard({required String label, required String val, required Color color}) => Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14)),
        child: Column(
          children: [
            Text(val, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: color)),
            Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey)),
          ],
        ),
      );
}