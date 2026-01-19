import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurants_system/providers/auth-provider.dart';
import 'dart:ui';
import 'forgotPassword.dart';
import 'package:flutter/cupertino.dart';

class LogIn extends ConsumerStatefulWidget {
  const LogIn({super.key});

  @override
  ConsumerState<LogIn> createState() => _LogInState();
}

class _LogInState extends ConsumerState<LogIn> {
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
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.03),
              // النص
              Text(
                "Welcome Back!",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 32,
                  fontFamily: "PlaypenSans",
                  shadows: [
                    Shadow(
                      blurRadius: 5.0,
                      color: const Color.fromARGB(79, 255, 255, 255),
                      offset: Offset(2.0, 2.0),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Explore Delicious Food",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                  fontFamily: "PlaypenSans",
                  shadows: [
                    Shadow(
                      blurRadius: 5.0,
                      color: const Color.fromARGB(79, 255, 255, 255),
                      offset: Offset(5.0, 2.0),
                    ),
                  ],
                ),
              ),
              Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //burger photo
                    Align(
                      alignment: Alignment.centerRight,
                      child: Transform.translate(
                        offset: Offset(30, 40),
                        child: Image.asset(
                          'assets/images/burger.png',
                          width: 250,
                          height: 250,
                        ),
                      ),
                    ),
                    //Email Field
                    TextFormField(
                      controller: _emailController,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: InputDecoration(
                        labelText: "Email",
                        labelStyle: TextStyle(color: Colors.black),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.black, width: 2),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(color: Colors.grey, width: 2),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.red, width: 3),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.red, width: 3),
                        ),
                        errorStyle: TextStyle(
                          fontSize: 14,
                          color: Colors.red,
                          fontStyle: FontStyle.italic,
                        ),
                        prefixIcon: Icon(
                          Icons.email_outlined,
                          size: 27,
                          color: Colors.grey,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Email is required !";
                        }
                        final emailRegex = RegExp(
                          r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
                        );
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
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(color: Colors.grey, width: 2),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.black, width: 2),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.red, width: 3),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.red, width: 3),
                        ),
                        errorStyle: TextStyle(
                          fontSize: 14,
                          color: Colors.red,
                          fontStyle: FontStyle.italic,
                        ),
                        errorMaxLines: 2,
                        suffixIcon: IconButton(
                          icon: _passwordVisible
                              ? Image.asset(
                                  'assets/images/visibility.png',
                                  width: 27,
                                  color: Colors.grey,
                                )
                              : Image.asset(
                                  'assets/images/eyebrow.png',
                                  width: 27,
                                  color: Colors.grey,
                                ),
                          onPressed: () {
                            setState(() {
                              _passwordVisible = !_passwordVisible;
                            });
                          },
                        ),
                        prefixIcon: Icon(
                          Icons.lock_outline,
                          size: 27,
                          color: Colors.grey,
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
              const SizedBox(height: 25),
              Wrap(
                alignment: WrapAlignment.spaceBetween,
                runSpacing: 1,
                children: [
                  TextButton(
                    child: Text(
                      "forgot your password?",
                      style: TextStyle(
                        fontSize: 16,
                        decoration: TextDecoration.underline,
                        decorationColor: Colors.black,
                        color: Colors.black,
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
                        MaterialPageRoute(builder: (_) => ForgotPassword()),
                      );
                    },
                  ),
                  TextButton(
                    child: Text(
                      "Create Account",
                      style: TextStyle(
                        fontSize: 16,
                        decoration: TextDecoration.underline,
                        decorationColor: Colors.black,
                        color: Colors.black,
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
                        MaterialPageRoute(builder: (_) => ForgotPassword()),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 10),

              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
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
                            await Future.delayed(Duration(milliseconds: 500));
                            final newState = ref.read(authProvider);
                            if (newState.message != null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    newState.message!,
                                    style: TextStyle(fontSize: 20),
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
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: authState.isLoading
                      ? CircularProgressIndicator.adaptive()
                      : Text(
                          "Log In",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
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
