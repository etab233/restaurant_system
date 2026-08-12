// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurants_system/core/utils/validators.dart';
import 'package:restaurants_system/features/auth/presentation/providers/auth_provider.dart';
import 'package:restaurants_system/features/auth/presentation/widgets/auth_button.dart';
import 'package:restaurants_system/features/auth/presentation/widgets/auth_text_field.dart';
import 'verification.dart';

class ForgotPassword extends ConsumerStatefulWidget {
  const ForgotPassword({super.key});

  @override
  ConsumerState<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends ConsumerState<ForgotPassword> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, size: 30),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.05),
              const Text(
                "Forgot Password?",
                style: TextStyle(
                  color: Colors.black,
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
              const SizedBox(height: 10),
              const Icon(Icons.key, size: 55, color: Color(0xFFFF7A3D)),

              const SizedBox(height: 20),

              //Email Field
              Form(
                key: _formKey,
                child: AuthTextField(
                  controller: _emailController,
                  labelText: "Email",
                  prefixIcon: Icons.email_outlined,
                  validator: Validators.validateEmail,
                ),
              ),
              const SizedBox(height: 20),

              AuthButton(
                label: "Send Email",
                isLoading: authState.isLoading,
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    await ref
                        .read(authNotifierProvider.notifier)
                        .forgotPassword(_emailController.text);
                    //await Future.delayed(Duration(milliseconds: 500));
                    final newState = ref.read(authNotifierProvider);
                    if (newState.message != null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            newState.message!,
                            style: const TextStyle(fontSize: 20),
                          ),
                          backgroundColor: newState.isCodeSent
                              ? Colors.green
                              : Colors.red,
                          duration: const Duration(seconds: 4),
                        ),
                      );
                    }
                    if (newState.isCodeSent) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => Verification(
                            purpose: "reset_password",
                            email: _emailController.text.trim(),
                          ),
                        ),
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
