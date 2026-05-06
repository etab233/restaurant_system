// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurants_system/constants.dart';
import 'package:restaurants_system/providers/auth_provider.dart';
import 'package:restaurants_system/view/calorie_tracker/dashboard/dashboard_main_screen.dart';
import 'package:restaurants_system/view/restaurant-request/restaurant_request.dart';
import 'forgot_password.dart';
import 'register.dart';
import '../home/home.dart';

class Login extends ConsumerStatefulWidget {
  final String redirectTo;
  const Login({super.key, required this.redirectTo});

  @override
  ConsumerState<Login> createState() => _LoginState();
}

class _LoginState extends ConsumerState<Login> {
  final _passwordController = TextEditingController();
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _passwordVisible = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.09),
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "Welcome Back !",
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 34,
                    fontFamily: "Tajawal",
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        blurRadius: 5.0,
                        color: const Color.fromARGB(79, 255, 255, 255),
                        offset: Offset(2.0, 2.0),
                      ),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "Fresh • Tasty • Fast",
                  style: TextStyle(
                    color: const Color(0xFFFF7A3D),
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    fontFamily: "Tajawal",
                    shadows: [
                      Shadow(
                        blurRadius: 5.0,
                        color: const Color.fromARGB(79, 255, 255, 255),
                        offset: Offset(5.0, 2.0),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.bottomRight,
                child: Image.asset(
                  'assets/images/burger.png',
                  width: 130,
                  height: 130,
                ),
              ),
              Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //Email Field
                    TextFormField(
                      controller: _emailController,
                      style: TextStyle(color: Colors.black, fontSize: 16),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: InputDecoration(
                        labelText: "Email",
                        filled: true,
                        fillColor: Colors.white,
                        labelStyle: TextStyle(color: Colors.black),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: Color(Constants.orangeColor),
                            width: 2,
                          ),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.red, width: 2),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(
                            color: Colors.grey,
                            width: 1.5,
                          ),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: colors.outline,
                            width: 2,
                          ),
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
                      style: TextStyle(color: Colors.black, fontSize: 16),
                      decoration: InputDecoration(
                        labelText: 'Password',
                        filled: true,
                        fillColor: Colors.white,
                        labelStyle: TextStyle(color: Colors.black),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(
                            color: Colors.grey,
                            width: 1.5,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: Color(Constants.orangeColor),
                            width: 2,
                          ),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.red, width: 2),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.red, width: 2),
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
              const SizedBox(height: 8),

              Align(
                alignment: Alignment.topRight,
                child: TextButton(
                  child: Text(
                    "forgot your password?",
                    style: TextStyle(
                      fontSize: 18,
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
              ),
              const SizedBox(height: 35),

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
                            if (!mounted) return;
                            final newState = ref.read(authProvider);
                            if (newState.message != null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  padding: EdgeInsets.all(15),
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
                            if (!mounted) return;
                            // إذا تم تسجيل الدخول بنجاح
                            final myState = ref.read(authProvider);
                            if (myState.isLoggedIn) {
                              switch (widget.redirectTo) {
                                case "home":
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Home(),
                                    ),
                                  );
                                  break;
                                case "dashboard":
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Dashboard(),
                                    ),
                                  );
                                  break;
                                case "restaurant_request":
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => RestaurantRequest(),
                                    ),
                                  );
                                  break;
                                default:
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Home(),
                                    ),
                                  );
                              }
                            }
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF7A3D),
                    foregroundColor: Colors.white,
                    elevation: 5,
                    shadowColor: Colors.grey,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
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
              const SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "New user?",
                    style: TextStyle(
                      fontSize: 18,
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
                  TextButton(
                    child: Text(
                      "Sign Up",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                        decorationColor: const Color(0xFFFF7A3D),
                        color: Color(Constants.orangeColor),
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
      ),
    );
  }
}
