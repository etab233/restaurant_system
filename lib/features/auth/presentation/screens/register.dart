// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:restaurants_system/core/utils/validators.dart';
import 'package:restaurants_system/features/auth/presentation/providers/auth_provider.dart';
import 'package:restaurants_system/features/auth/presentation/widgets/auth_button.dart';
import 'package:restaurants_system/features/auth/presentation/widgets/auth_text_field.dart';
import 'login.dart';
import 'verification.dart';
import 'package:restaurants_system/constants.dart';

class Register extends ConsumerStatefulWidget {
  const Register({super.key});

  @override
  ConsumerState<Register> createState() => _RegisterState();
}

class _RegisterState extends ConsumerState<Register> {
  final _confirmPasswordController = TextEditingController();
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  PhoneNumber _phoneNumber = PhoneNumber(isoCode: 'SY');
  bool _passwordVisible1 = false;
  bool _passwordVisible2 = false;
  final _usernameController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _usernameController.dispose();
    _confirmPasswordController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.09),
              // النص
              const Text(
                "Create new account",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Tajawal",
                  shadows: [
                    Shadow(
                      blurRadius: 5.0,
                      color: Color.fromARGB(79, 255, 255, 255),
                      offset: Offset(2.0, 2.0),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              //burger photo
              Align(
                alignment: Alignment.centerRight,
                child: Transform.translate(
                  offset: const Offset(0, 30),
                  child: Image.asset(
                    'assets/images/food.webp',
                    width: 115,
                    height: 115,
                  ),
                ),
              ),

              const SizedBox(height: 8),

              Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Username
                    AuthTextField(
                      controller: _usernameController,
                      labelText: "Name",
                      prefixIcon: Icons.person_outline,
                      validator: (v) => Validators.validateRequired(v, "Name"),
                    ),

                    const SizedBox(height: 25),

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
                      obscureText: !_passwordVisible1,
                      validator: Validators.validatePassword,
                      suffixIcon: IconButton(
                        icon: Image.asset(
                          _passwordVisible1
                              ? 'assets/images/visibility.webp'
                              : 'assets/images/eyebrow.webp',
                          width: 27,
                          color: Colors.grey,
                        ),
                        onPressed: () => setState(
                          () => _passwordVisible1 = !_passwordVisible1,
                        ),
                      ),
                    ),

                    const SizedBox(height: 25),

                    AuthTextField(
                      controller: _confirmPasswordController,
                      labelText: "Confirm password",
                      prefixIcon: Icons.lock_outline,
                      obscureText: !_passwordVisible2,
                      validator: Validators.validatePassword,
                      suffixIcon: IconButton(
                        icon: Image.asset(
                          _passwordVisible2
                              ? 'assets/images/visibility.webp'
                              : 'assets/images/eyebrow.webp',
                          width: 27,
                          color: Colors.grey,
                        ),
                        onPressed: () => setState(
                          () => _passwordVisible2 = !_passwordVisible2,
                        ),
                      ),
                    ),

                    const SizedBox(height: 25),

                    // Phone Number field
                    InternationalPhoneNumberInput(
                      initialValue: _phoneNumber,
                      textFieldController: _phoneNumberController,
                      onInputChanged: (n) => _phoneNumber = n,
                      selectorConfig: const SelectorConfig(
                        selectorType: PhoneInputSelectorType.DROPDOWN,
                        setSelectorButtonAsPrefixIcon: true,
                        showFlags: false,
                      ),
                      countries: const ['SY'],
                      keyboardType: TextInputType.phone,
                      maxLength: 11,
                      formatInput: true,
                      validator: (v) => v!.isEmpty ? "Phone is required" : null,
                      inputDecoration: AuthTextField.buildDecoration(
                        labelText: 'phone number',
                        context: context,
                        suffixIcon: const Icon(Icons.phone, color: Colors.grey),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 35),

              AuthButton(
                label: 'Register',
                isLoading: authState.isLoading,
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    await ref
                        .watch(authNotifierProvider.notifier)
                        .register(
                          _usernameController.text,
                          _emailController.text,
                          _passwordController.text,
                          _confirmPasswordController.text,
                          _phoneNumber.phoneNumber!,
                        );
                    final newState = ref.read(authNotifierProvider);
                    if (newState.message != null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            newState.message!,
                            style: const TextStyle(fontSize: 20),
                          ),
                          backgroundColor: newState.isRegistered
                              ? Colors.green
                              : Colors.red,
                          duration: const Duration(seconds: 1),
                        ),
                      );
                    }
                    await Future.delayed(const Duration(seconds: 1));
                    if (!mounted) return;
                    if (newState.isRegistered) {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (_) => Verification(
                            purpose: "register",
                            email: _emailController.text.trim(),
                          ),
                        ),
                        (route) => false,
                      );
                    }
                  }
                },
              ),
              const SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Have an account?",
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                  TextButton(
                    child: const Text(
                      "back to Login",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                        decorationColor: Color(Constants.orangeColor),
                        color: Color(0xFFFF7A3D),
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
                        MaterialPageRoute(builder: (_) => const Login()),
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
