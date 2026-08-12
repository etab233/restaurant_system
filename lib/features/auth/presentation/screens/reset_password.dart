// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurants_system/core/utils/validators.dart';
import 'package:restaurants_system/features/auth/presentation/providers/auth_provider.dart';
import 'package:restaurants_system/features/auth/presentation/widgets/auth_button.dart';
import 'package:restaurants_system/features/auth/presentation/widgets/auth_text_field.dart';
import 'package:restaurants_system/features/home/presentation/screens/home.dart';

class ResetPassword extends ConsumerStatefulWidget {
  const ResetPassword({super.key});

  @override
  ConsumerState<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends ConsumerState<ResetPassword> {
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _passwordVisible1 = false;
  bool _passwordVisible2 = false;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.05),
              const Center(
                child: Text(
                  "Set Your Password",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 34,
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
              Align(
                alignment: Alignment.centerRight,
                child: Transform.translate(
                  offset: const Offset(0, 35),
                  child: Image.asset(
                    'assets/images/set_password.png',
                    width: 180,
                    height: 180,
                  ),
                ),
              ),
              Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //password Field
                    AuthTextField(
                      controller: _passwordController,
                      labelText: "Password",
                      prefixIcon: Icons.lock_outline,
                      obscureText: !_passwordVisible1,
                      validator: Validators.validatePassword,
                      suffixIcon: IconButton(
                        icon: Image.asset(
                          _passwordVisible1
                              ? 'assets/images/visibility.png'
                              : 'assets/images/eyebrow.png',
                          width: 27,
                          color: Colors.grey,
                        ),
                        onPressed: () => setState(
                          () => _passwordVisible1 = !_passwordVisible1,
                        ),
                      ),
                    ),

                    const SizedBox(height: 25),

                    //ConfirmPassword Field
                    AuthTextField(
                      controller: _confirmPasswordController,
                      labelText: "Confirm password",
                      prefixIcon: Icons.lock_outline,
                      obscureText: !_passwordVisible2,
                      validator: Validators.validatePassword,
                      suffixIcon: IconButton(
                        icon: Image.asset(
                          _passwordVisible2
                              ? 'assets/images/visibility.png'
                              : 'assets/images/eyebrow.png',
                          width: 27,
                          color: Colors.grey,
                        ),
                        onPressed: () => setState(
                          () => _passwordVisible2 = !_passwordVisible2,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              AuthButton(
                label: "Set Password",
                isLoading: authState.isLoading,
                onPressed: authState.isLoading
                    ? null
                    : () async {
                        if (_formKey.currentState!.validate()) {
                          final message = await ref
                              .read(authNotifierProvider.notifier)
                              .resetPassword(
                                _passwordController.text,
                                _confirmPasswordController.text,
                                authState.userData!['email'],
                              );

                          final newState = ref.read(authNotifierProvider);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                message,
                                style: const TextStyle(fontSize: 20),
                              ),
                              backgroundColor: newState.isPasswordSet
                                  ? Colors.green
                                  : Colors.red,
                              duration: const Duration(seconds: 1),
                            ),
                          );
                          Future.delayed(const Duration(seconds: 2));
                          if (newState.isPasswordSet) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const Home()),
                            );
                          }
                        }
                      },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
