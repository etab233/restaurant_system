// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurants_system/providers/health_profile.dart';
import 'package:restaurants_system/view/calorie_tracker/form/activity_goal_screen.dart';

class BodyInfoScreen extends ConsumerStatefulWidget {
  const BodyInfoScreen({super.key});

  @override
  ConsumerState<BodyInfoScreen> createState() => _BodyInfoScreenState();
}

class _BodyInfoScreenState extends ConsumerState<BodyInfoScreen> {
  final TextEditingController heightController = TextEditingController();
  final TextEditingController weightController = TextEditingController();

  @override
  void dispose() {
    heightController.dispose();
    weightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
          child: SizedBox(
            height: 55,
            child: ElevatedButton(
              onPressed: () {
                final h = double.tryParse(heightController.text);
                final w = double.tryParse(weightController.text);

                if (h == null || w == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Enter valid numbers")),
                  );
                  return;
                }

                if (h < 50 || h > 250) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Enter realistic height")),
                  );
                  return;
                }

                if (w < 30 || w > 200) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Enter realistic weight")),
                  );
                  return;
                }

                ref
                    .read(healthProfileProvider.notifier)
                    .setBodyInfo(heightCm: h, weightKg: w);

                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => ActivityGoalScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6AA84F),
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text("Next", style: TextStyle(fontSize: 18)),
            ),
          ),
        ),
      ),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back),
                  ),
                  const Expanded(
                    child: LinearProgressIndicator(
                      value: 0.75,
                      color: Color(0xFF6AA84F),
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Text("3/4"),
                ],
              ),

              const SizedBox(height: 40),

              const Text(
                "Your body information",
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 30),

              /// Height
              TextField(
                controller: heightController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Height",
                  suffixText: "cm",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Color(0xFF6AA84F),
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              /// Weight
              TextField(
                controller: weightController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Weight",
                  suffixText: "kg",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Color(0xFF6AA84F),
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
