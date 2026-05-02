// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurants_system/providers/auth_provider.dart';
import 'package:restaurants_system/view/home/home.dart';
import 'package:restaurants_system/constants.dart';

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
    final authState = ref.watch(authProvider);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.05),
              Center(
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
                        color: const Color.fromARGB(79, 255, 255, 255),
                        offset: Offset(5.0, 2.0),
                      ),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Transform.translate(
                  offset: Offset(0, 35),
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
                    TextFormField(
                      controller: _passwordController,
                      obscureText: !_passwordVisible1,
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
                          borderSide: BorderSide(
                            color: Color(Constants.orangeColor),
                            width: 2,
                          ),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.red, width: 3),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: const Color(0xFFFF7A3D), width: 3),
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
                      decoration: InputDecoration(
                        labelText: 'Confirm password',
                        labelStyle: TextStyle(color: Colors.black),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(color: Colors.grey, width: 2),
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
                          borderSide: BorderSide(color: Colors.red, width: 3),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: const Color(0xFFFF7A3D), width: 3),
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
                  ],
                ),
              ),

              const SizedBox(height: 25),

              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: authState.isLoading
                      ? null
                      : () async {
                          if (_formKey.currentState!.validate()) {
                            final message = await ref
                                .read(authProvider.notifier)
                                .setPassword(
                                  _passwordController.text,
                                  _confirmPasswordController.text,
                                  authState.userData!['email'],
                                );

                            final newState = ref.read(authProvider);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  message,
                                  style: TextStyle(fontSize: 20),
                                ),
                                backgroundColor: newState.isPasswordSet
                                    ? Colors.green
                                    : Colors.red,
                                duration: Duration(seconds: 1),
                              ),
                            );
                            Future.delayed(Duration(seconds: 2));
                            if (newState.isPasswordSet) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => Home()),
                              );
                            }
                          }
                        },

                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(Constants.orangeColor),
                    foregroundColor: Colors.white,
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: authState.isLoading
                      ? CircularProgressIndicator.adaptive()
                      : Text(
                          "Reset Password",
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
