// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurants_system/features/calorie_dashboard/presentation/screens/dashboard_screen.dart';
import 'package:restaurants_system/features/health_profile/presentation/providers/health_profile_notifier.dart';

class ActivityGoalScreen extends ConsumerStatefulWidget {
  const ActivityGoalScreen({super.key});

  @override
  ConsumerState<ActivityGoalScreen> createState() => _ActivityGoalScreenState();
}

class _ActivityGoalScreenState extends ConsumerState<ActivityGoalScreen> {
  String? activityLevel;
  String? goal;
  String? birthday;
  String? gender;
  double? height;
  double? weight;
  String? token;

  final activityList = [
    "Sedentary",
    "Lightly Active",
    "Moderately Active",
    "Very Active",
    "Super Active",
  ];

  final goalList = ["Lose Weight", "Maintain", "Gain Weight"];

  void fetchData() {
    birthday = ref.read(healthProfileProvider).birthDate;
    gender = ref.read(healthProfileProvider).gender;
    height = ref.read(healthProfileProvider).heightCm;
    weight = ref.read(healthProfileProvider).weightKg;
  }

  @override
  void initState() {
    super.initState();
    fetchData();
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
              onPressed: () async {
                if (activityLevel == null || goal == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Please complete all fields")),
                  );
                  return;
                }
                ref
                    .read(healthProfileProvider.notifier)
                    .setActivityAndGoal(
                      activityLevel: activityLevel!,
                      goal: goal!,
                    );

                // Save data an go to Dashboard screen
                await ref
                    .read(healthProfileProvider.notifier)
                    .saveUserData(
                      birthDate: birthday!,
                      heightCm: height!,
                      weightKg: weight!,
                      gender: gender!,
                      activityLevel: activityLevel!,
                      goal: goal!,
                    );
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const DashboardScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor:const  Color(0xFF6AA84F),
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text("Finish", style: TextStyle(fontSize: 18)),
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
                      value: 1.0,
                      color: Color(0xFF6AA84F),
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Text("4/4"),
                ],
              ),

              const SizedBox(height: 40),

              const Text(
                "Your activity level",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 20),

              DropdownButtonFormField<String>(
                value: activityLevel,
                items: activityList.map((e) {
                  return DropdownMenuItem(value: e, child: Text(e));
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    activityLevel = value;
                  });
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),

              const SizedBox(height: 40),

              const Text(
                "Your goal",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 20),

              Wrap(
                spacing: 12, // المسافة الأفقية
                runSpacing: 12, // المسافة العمودية بينهم
                children: List.generate(3, (index) {
                  return ChoiceChip(
                    label: Text(goalList[index]),
                    selected: goal == goalList[index],
                    selectedColor:const  Color(0xFF6AA84F),

                    labelStyle: TextStyle(
                      color: goal == goalList[index]
                          ? Colors.white
                          : Colors.black,
                    ),
                    onSelected: (value) {
                      setState(() {
                        goal = value ? goalList[index] : null;
                      });
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
