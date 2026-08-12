// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurants_system/constants.dart';
import 'package:restaurants_system/core/navigation/main_tabs.dart';
import 'package:restaurants_system/core/utils/validators.dart';
import 'package:restaurants_system/features/add_restaurant/presentation/screens/add_restaurant_screen.dart';
import 'package:restaurants_system/features/auth/presentation/providers/auth_provider.dart';
import 'package:restaurants_system/features/auth/presentation/widgets/auth_button.dart';
import 'package:restaurants_system/features/auth/presentation/widgets/auth_text_field.dart';
import 'package:restaurants_system/features/health_profile/presentation/screens/welcome_screen.dart';
import 'package:restaurants_system/features/navigation/presentation/screens/main_screen.dart';
import 'forgot_password.dart';
import 'register.dart';

enum LoginRedirect { cart, welcome, dashboard, home, addRestaurant }

class Login extends ConsumerStatefulWidget {
  final LoginRedirect? redirectTo;
  const Login({super.key, this.redirectTo});

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
    final authState = ref.watch(authNotifierProvider);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.09),
              const Align(
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
                        color: Color.fromARGB(79, 255, 255, 255),
                        offset: Offset(2.0, 2.0),
                      ),
                    ],
                  ),
                ),
              ),
              const Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "Fresh • Tasty • Fast",
                  style: TextStyle(
                    color: Color(0xFFFF7A3D),
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    fontFamily: "Tajawal",
                    shadows: [
                      Shadow(
                        blurRadius: 5.0,
                        color: Color.fromARGB(79, 255, 255, 255),
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
                    AuthTextField(
                      controller: _emailController,
                      labelText: "Email",
                      prefixIcon: Icons.email_outlined,
                      validator: Validators.validateEmail,
                    ),
                    const SizedBox(height: 25),
                    AuthTextField(
                      controller: _passwordController,
                      labelText: "Password",
                      prefixIcon: Icons.lock_outline,
                      obscureText: !_passwordVisible,
                      validator: Validators.validatePassword,
                      suffixIcon: IconButton(
                        icon: Image.asset(
                          _passwordVisible
                              ? 'assets/images/visibility.png'
                              : 'assets/images/eyebrow.png',
                          width: 27,
                          color: Colors.grey,
                        ),
                        onPressed: () => setState(
                          () => _passwordVisible = !_passwordVisible,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),

              Align(
                alignment: Alignment.topRight,
                child: TextButton(
                  child: const Text(
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
                      MaterialPageRoute(builder: (_) => const ForgotPassword()),
                    );
                  },
                ),
              ),
              const SizedBox(height: 35),

              AuthButton(
                label: "Login",
                isLoading: authState.isLoading,
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    await ref
                        .read(authNotifierProvider.notifier)
                        .login(_emailController.text, _passwordController.text);
                    if (!mounted) return;
                    final newState = ref.read(authNotifierProvider);
                    if (newState.message != null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          padding: const EdgeInsets.all(13),
                          margin: const EdgeInsets.all(9),
                          behavior: SnackBarBehavior.floating,
                          content: Text(
                            newState.message!,
                            style: const TextStyle(fontSize: 20),
                          ),
                          backgroundColor: newState.isLoggedIn
                              ? Colors.green
                              : Colors.red,
                          duration: const Duration(seconds: 4),
                        ),
                      );
                    }
                    if (!mounted) return;
                    // إذا تم تسجيل الدخول بنجاح
                    final myState = ref.read(authNotifierProvider);
                    if (myState.isLoggedIn) {
                      switch (widget.redirectTo) {
                        case LoginRedirect.home:
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const MainScreen(),
                            ),
                            (route) => false,
                          );
                          break;
                        case LoginRedirect.welcome:
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const Welcome(),
                            ),
                            (route) => false,
                          );
                          break;
                        case LoginRedirect.addRestaurant:
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AddRestaurant(),
                            ),
                            (route) => false,
                          );
                          break;
                        case LoginRedirect.cart:
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const MainScreen(initialTab: MainTab.cart),
                            ),
                            (route) => false,
                          );
                          break;
                        default:
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const MainScreen(),
                            ),
                            (route) => false,
                          );
                      }
                    }
                  }
                },
              ),
              const SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
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
                    child: const Text(
                      "Sign Up",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                        decorationColor: Color(0xFFFF7A3D),
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
                        MaterialPageRoute(builder: (_) => const Register()),
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
