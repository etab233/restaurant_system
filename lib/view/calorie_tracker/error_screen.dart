import 'package:flutter/material.dart';
import 'package:restaurants_system/view/login-register/login.dart';
import 'package:restaurants_system/view/login-register/register.dart';

class ErrorScreen extends StatelessWidget {
  const ErrorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed:() => Navigator.pop(context), icon: Icon(Icons.arrow_back)),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              // الصورة
              Expanded(
                child: Image.asset(
                  'assets/images/error_screen.jpg',
                  fit: BoxFit.contain,
                ),
              ),
              const Text(
                "Log in to unlock",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "this feature",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF4CAF50)),
                  ),
                  const SizedBox(width: 5,), 
                  Icon(Icons.lock_open_outlined, color:Color(0xFFFF7A3D),)
                ],
              ),
              const SizedBox(height: 10),

              const Text(
                "Sign in to analyze your meals,\ntrack nutrition and get personalized insights.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF7A3D),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => Login(redirectTo: "dashboard",)),
                    );
                  },
                  child: const Text(
                    "Log In",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 15),

              ///  زر إنشاء حساب
              SizedBox(
                width: double.infinity,
                height: 55,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(
                      color: Color(0xFF4CAF50),
                      width: 1.5,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => Register()),
                    );
                  },
                  child: const Text(
                    "Sign Up",
                    style: TextStyle(
                      color: Color(0xFF4CAF50),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}
