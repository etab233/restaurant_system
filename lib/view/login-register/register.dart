// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:restaurants_system/providers/auth_provider.dart';
import 'login.dart';
import 'verification.dart';
import 'dart:ui';
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
    final authState = ref.watch(authProvider);
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.09),
              // النص
              Text(
                "Create new account",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Tajawal",
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
              //burger photo
              Align(
                alignment: Alignment.centerRight,
                child: Transform.translate(
                  offset: Offset(0, 30),
                  child: Image.asset(
                    'assets/images/food.png',
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
                    TextFormField(
                      controller: _usernameController,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      style: TextStyle(color: Colors.black, fontSize: 16),
                      decoration: InputDecoration(
                        labelText: "Name",
                        filled: true,
                        fillColor: Colors.white,
                        labelStyle: TextStyle(color: Colors.black),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: Color(Constants.orangeColor),
                            width: 2.5,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(color: Colors.grey, width: 2),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.red, width: 3),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: const Color(0xFFFF7A3D),
                            width: 3,
                          ),
                        ),
                        errorStyle: TextStyle(
                          fontSize: 14,
                          color: Colors.red,
                          fontStyle: FontStyle.italic,
                        ),
                        prefixIcon: Icon(
                          Icons.person_outline,
                          size: 27,
                          color: Colors.grey,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Name is required !";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 25),
                    //Email Field
                    ClipRRect(
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                        child: TextFormField(
                          controller: _emailController,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          style: TextStyle(color: Colors.black, fontSize: 16),
                          decoration: InputDecoration(
                            labelText: "Email",
                            filled: true,
                            fillColor: Colors.white,
                            labelStyle: TextStyle(color: Colors.black),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                color: Color(Constants.orangeColor),
                                width: 2.5,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(
                                color: Colors.grey,
                                width: 2,
                              ),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                color: Colors.red,
                                width: 3,
                              ),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                color: const Color(0xFFFF7A3D),
                                width: 3,
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
                      ),
                    ),
                    const SizedBox(height: 25),

                    //password Field
                    TextFormField(
                      controller: _passwordController,
                      obscureText: !_passwordVisible1,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      style: TextStyle(color: Colors.black, fontSize: 16),
                      decoration: InputDecoration(
                        labelText: 'Password',
                        filled: true,
                        fillColor: Colors.white,
                        labelStyle: TextStyle(color: Colors.black),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(color: Colors.grey, width: 2),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: Color(Constants.orangeColor),
                            width: 2.5,
                          ),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.red, width: 3),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: const Color(0xFFFF7A3D),
                            width: 3,
                          ),
                        ),
                        errorStyle: TextStyle(
                          fontSize: 14,
                          color: Colors.red,
                          fontStyle: FontStyle.italic,
                        ),
                        errorMaxLines: 2,
                        suffixIcon: IconButton(
                          icon: _passwordVisible1
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
                              _passwordVisible1 = !_passwordVisible1;
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
                    const SizedBox(height: 25),
                    //ConfirmPassword Field
                    TextFormField(
                      controller: _confirmPasswordController,
                      obscureText: !_passwordVisible2,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      style: TextStyle(color: Colors.black, fontSize: 16),
                      decoration: InputDecoration(
                        labelText: 'Confirm password',
                        filled: true,
                        fillColor: Colors.white,
                        labelStyle: TextStyle(color: Colors.black),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(color: Colors.grey, width: 2),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: Color(Constants.orangeColor),
                            width: 2.5,
                          ),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.red, width: 3),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: const Color(0xFFFF7A3D),
                            width: 3,
                          ),
                        ),
                        errorStyle: TextStyle(
                          fontSize: 14,
                          color: Colors.red,
                          fontStyle: FontStyle.italic,
                        ),
                        errorMaxLines: 2,
                        suffixIcon: IconButton(
                          icon: _passwordVisible2
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
                              _passwordVisible2 = !_passwordVisible2;
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
                      inputDecoration: InputDecoration(
                        labelText: 'phone number',
                        filled: true,
                        fillColor: Colors.white,
                        labelStyle: TextStyle(color: Colors.black),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(color: Colors.grey, width: 2),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: Color(Constants.orangeColor),
                            width: 2.5,
                          ),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.red, width: 3),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: const Color(0xFFFF7A3D),
                            width: 3,
                          ),
                        ),
                        errorStyle: TextStyle(
                          fontSize: 14,
                          color: Colors.red,
                          fontStyle: FontStyle.italic,
                        ),
                        errorMaxLines: 2,
                        suffixIcon: Icon(Icons.phone, color: Colors.grey,),
                        
                      ),
                    ),
                  ],
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
                                .watch(authProvider.notifier)
                                .register(
                                  _usernameController.text,
                                  _emailController.text,
                                  _passwordController.text,
                                  _confirmPasswordController.text,
                                  _phoneNumber.phoneNumber!
                                );
                            final newState = ref.read(authProvider);
                            if (newState.message != null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    newState.message!,
                                    style: TextStyle(fontSize: 20),
                                  ),
                                  backgroundColor: newState.isRegistered
                                      ? Colors.green
                                      : Colors.red,
                                  duration: Duration(seconds: 1),
                                ),
                              );
                            }
                            await Future.delayed(Duration(seconds: 1));
                            if (!mounted) return;
                            if (newState.isRegistered) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => Verification(
                                    purpose: "register",
                                    email: _emailController.text.trim(),
                                  ),
                                ),
                              );
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
                      ? CircularProgressIndicator()
                      : Text(
                          "Register",
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
                    "Have an account?",
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                  TextButton(
                    child: Text(
                      "back to Login",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                        decorationColor: Color(Constants.orangeColor),
                        color: const Color(0xFFFF7A3D),
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
                          builder: (_) => Login(redirectTo: ""),
                        ),
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
