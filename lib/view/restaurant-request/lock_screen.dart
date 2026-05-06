// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:restaurants_system/view/login-register/login.dart';
import 'package:restaurants_system/view/login-register/register.dart';

class LockScreen extends StatelessWidget {
  const LockScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Stack(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 200,
                  child: Image.asset(
                    "assets/images/restaurant_logo.jpg",
                    fit: BoxFit.contain,
                  ),
                ),
                Positioned(
                  top: 15,
                  left: 15,
                  child: CircleAvatar(
                    backgroundColor: Colors.grey.shade300,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.black),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ),
              ],
            ),
            const Text(
              "Add your restaurant",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const Text(
              "this feature is locked. \n Create an account or login to add \n and manage your restaurant.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Stack(
                children: [
                  // 1. Form layer (the actual restaurant information form)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      border: BoxBorder.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Restaurant Information',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        const TextField(
                          decoration: InputDecoration(
                            labelText: 'Restaurant Name',
                            prefixIcon: Icon(Icons.restaurant),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        const TextField(
                          decoration: InputDecoration(
                            labelText: 'Phone number',
                            prefixIcon: Icon(Icons.phone),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        const TextField(
                          decoration: InputDecoration(
                            labelText: 'Address',
                            prefixIcon: Icon(Icons.location_on),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // 2. Semi‑transparent overlay (opacity 0.85)
                  Container(
                    color: Colors.white.withOpacity(0.85),
                    width: double.infinity,
                    height: double.infinity,
                  ),
                  // 3. Lock + text overlay (centered)
                  Center(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.3),
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.white,
                            child: Icon(
                              Icons.lock_outline,
                              size: 50,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Sign in to continue',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Your data will be safe and \n available on all your devices.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade700,
                            ),
                          ),
                          const SizedBox(height: 50),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: SizedBox(
                width: double.infinity,
                height: 55,

                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => Login(redirectTo: "restaurant_request"),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFFF7A3D),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Row(
                        children: [
                          Icon(
                            Icons.person_outline,
                            color: Colors.white,
                            size: 24,
                          ),
                          SizedBox(width: 10),
                          Text(
                            "Log In",
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                        ],
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.white,
                        size: 18,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: SizedBox(
                width: double.infinity,
                height: 55,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => Register()),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.grey),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: const [
                          Icon(
                            Icons.person_add_alt_1_outlined,
                            color: Colors.black,
                            size: 24,
                          ),
                          SizedBox(width: 10),
                          Text(
                            "Create New Account",
                            style: TextStyle(fontSize: 16, color: Colors.black),
                          ),
                        ],
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.grey,
                        size: 18,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.verified_user_outlined,
                  size: 18,
                  color: Colors.green,
                ),
                SizedBox(width: 8),
                Text(
                  "We keep your information secure and private.",
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
