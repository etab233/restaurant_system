// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurants_system/providers/health_profile.dart';
import 'package:restaurants_system/view/calorie_tracker/form/birthday_screen.dart';

class GenderScreen extends ConsumerStatefulWidget {
  const GenderScreen({super.key});

  @override
  ConsumerState<GenderScreen> createState() => _GenderScreenState();
}

class _GenderScreenState extends ConsumerState<GenderScreen> {
  String? selectedGender;

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
              onPressed: () async{
                if (selectedGender == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Please select your gender"),
                    ),
                  );
                  return;
                }

                ref.read(healthProfileProvider.notifier).setGender(selectedGender!);

                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_)=>BirthdayScreen())
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6AA84F),
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text("Next",style: TextStyle(fontSize: 18)),
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
                      value: 0.25,
                      color: Color(0xFF6AA84F),
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Text("1/4"),
                ],
              ),

              const SizedBox(height: 40),

              const Text(
                "Select your gender",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 30),

              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedGender = "Female";
                        });
                      },
                      child: Container(
                        height: 150,
                        decoration: BoxDecoration(
                          color: selectedGender == "Female"
                              ? Colors.pinkAccent
                              : Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Center(
                          child: Text(
                            "Female",
                            style: TextStyle(
                              color: selectedGender == "Female"
                                  ? Colors.white
                                  : Colors.black,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedGender = "Male";
                        });
                      },
                      child: Container(
                        height: 150,
                        decoration: BoxDecoration(
                          color: selectedGender == "Male"
                              ? Colors.blue
                              : Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Center(
                          child: Text(
                            "Male",
                            style: TextStyle(
                              color: selectedGender == "Male"
                                  ? Colors.white
                                  : Colors.black,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
 