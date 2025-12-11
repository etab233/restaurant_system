import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurants_system/providers/auth-provider.dart';
import 'package:flutter/animation.dart';
import 'dart:ui';
import 'register.dart';
import 'forgotPassword.dart';

class LogIn extends ConsumerStatefulWidget {
  const LogIn({super.key});

  @override
  ConsumerState<LogIn> createState() => _LogInState();
}

class _LogInState extends ConsumerState<LogIn> {
  final _blurIntensity = 5.0;
  final _passwordController = TextEditingController();
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _passwordVisible = false;

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    // إذا تم تسجيل الدخول بنجاح
    if (authState.isLoggedIn) {}
    return Scaffold(
      body: Stack(
        children: [
          // 1. الخلفية الأصلية
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/background.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),

          // 2. طبقة التغبيش الكاملة
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: _blurIntensity,
                sigmaY: _blurIntensity,
              ),
              child: Container(
                color: Colors.black.withOpacity(0.1), // تظليل خفيف مع التغبيش
              ),
            ),
          ),

          // 3. المحتوى الرئيسي
          Positioned.fill(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.07),
                  // النص
                  Text(
                    "Your next meal starts here",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontFamily: "Nunito",
                      shadows: [
                        Shadow(
                          blurRadius: 5.0,
                          color: const Color.fromARGB(79, 255, 255, 255),
                          offset: Offset(2.0, 2.0),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 40),
                  // الحاوية
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white.withOpacity(0.2)),
                    ),
                    child: Column(
                      children: [
                        const Text(
                          "Welcome Back",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 34,
                            fontFamily: "Nunito",
                            shadows: [
                              Shadow(
                                blurRadius: 5.0,
                                color: Color.fromARGB(79, 255, 255, 255),
                                offset: Offset(2.0, 2.0),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        Form(
                          key: _formKey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              //Email Field
                              TextFormField(
                                controller: _emailController,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                decoration: InputDecoration(
                                  labelText: "Email",
                                  labelStyle: TextStyle(color: Colors.black),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    borderSide: BorderSide(
                                      color: Colors.orange,
                                      width: 2,
                                    ),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: BorderSide(
                                      color: Colors.black,
                                      width: 2,
                                    ),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    borderSide: BorderSide(color: Colors.red, width: 3)
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    borderSide: BorderSide(color: Colors.red, width: 3)
                                  ),
                                  errorStyle: TextStyle(
                                    fontSize: 14,
                                    color: const Color.fromARGB(255, 0, 0, 0),
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FontStyle.italic,
                                  ),
                                  filled: true,
                                  fillColor: Colors.white.withOpacity(0.7),
                                  prefixIcon: Icon(
                                    Icons.email,
                                    size: 27,
                                    color: Colors.black,
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Email is required !";
                                  }
                                  final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
                                  if (!emailRegex.hasMatch(value)) {
                                    return "Enter a valid email address";
                                  }
                                  return null;
                                },
                              ),

                              const SizedBox(height: 25),

                              //password Field
                              TextFormField(
                                controller: _passwordController,
                                obscureText: !_passwordVisible,
                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                decoration: InputDecoration(
                                  labelText: 'Password',
                                  
                                  labelStyle: TextStyle(color: Colors.black),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    borderSide: BorderSide(
                                      color: Colors.orange,
                                      width: 2,
                                    ),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    borderSide: BorderSide(color: Colors.red, width: 3)
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    borderSide: BorderSide(color: Colors.red, width: 3)
                                  ),
                                  errorStyle: TextStyle(
                                    fontSize: 14,
                                    color: const Color.fromARGB(255, 0, 0, 0),
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FontStyle.italic,
                                  ),
                                  errorMaxLines: 2,
                                  suffixIcon: AnimatedSwitcher(
                                    duration: Duration(microseconds: 300),
                                    child: IconButton(
                                    icon: Icon(
                                      _passwordVisible ? Icons.visibility : Icons.visibility_off,
                                      color: _passwordVisible ? const Color.fromARGB(255, 0, 0, 0) : Colors.grey,
                                    ),
                                    iconSize: 27,
                                    color: Colors.black,
                                    onPressed: () {
                                      setState(() {
                                        _passwordVisible = !_passwordVisible;
                                      });
                                    },
                                  ),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: BorderSide(
                                      color: Colors.black,
                                      width: 2,
                                    ),
                                  ),
                                  filled: true,
                                  fillColor: Colors.white.withOpacity(0.7),
                                  prefixIcon: Icon(
                                    Icons.lock,
                                    size: 27,
                                    color: Colors.black,
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "password is required !";
                                  }
                                  if (value.length < 8) {
                                    return "8 characters at least !";
                                  }
                                  // محارف كبيرة و صغيرة و أ{قام و رموز}
                                  String pattern =
                                      r'^(?=.*[a-z])(?=.*[0-9])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&]).+$';
                                  final regExp = RegExp(pattern);

                                  if (!regExp.hasMatch(value)) {
                                    return "Password must contain uppercase, lowercase, number & special character";
                                  }
                                  return null;
                                },
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              child: Text(
                                "forgot your password?",
                                style: TextStyle(
                                  fontSize: 16,
                                  decoration: TextDecoration.underline,
                                  decorationColor: Colors.white,
                                  color: Colors.white,
                                  shadows: [
                                    Shadow(
                                      blurRadius: 5.0,
                                      color: Color.fromARGB(79, 255, 255, 255),
                                      offset: Offset(2.0, 2.0),
                                    ),
                                  ],
                                ),
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => ForgotPassword(),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),

                        ElevatedButton(
                          onPressed: authState.isLoading
                              ? null
                              : () async {
                                  if (_formKey.currentState!.validate()) {
                                    await ref
                                        .read(authProvider.notifier)
                                        .login(
                                          _emailController.text,
                                          _passwordController.text,
                                        );
                                    await Future.delayed(Duration(milliseconds: 500),);
                                    final newState = ref.read(authProvider);
                                    if (newState.message != null) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            newState.message!,
                                            style: TextStyle(
                                              fontSize: 20,
                                            ),
                                          ),
                                          backgroundColor: newState.isLoggedIn
                                              ? Colors.green
                                              : Colors.red,
                                          duration: Duration(seconds: 4),
                                        ),
                                      );
                                    }
                                  }
                                },

                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            foregroundColor: Colors.black,
                            elevation: 10,
                            padding: EdgeInsets.symmetric(horizontal: 50),
                          ),
                          child: Text(
                            "Log In",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Don't have an accout?",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                shadows: [
                                  Shadow(
                                    blurRadius: 5.0,
                                    color: Color.fromARGB(79, 255, 255, 255),
                                    offset: Offset(2.0, 2.0),
                                  ),
                                ],
                              ),
                            ),

                            TextButton(
                              child: Text(
                                "Sign In",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline,
                                  decorationColor: Colors.white,
                                  color: Colors.white,
                                  shadows: [
                                    Shadow(
                                      blurRadius: 5.0,
                                      color: Color.fromARGB(79, 255, 255, 255),
                                      offset: Offset(2.0, 2.0),
                                    ),
                                  ],
                                ),
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (_) => Register()),
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
