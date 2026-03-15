import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'verification.dart';
import 'package:restaurants_system/providers/auth_provider.dart';

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
    final authState = ref.watch(authProvider);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, size: 30),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 25),
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
              Icon(Icons.key, size: 55, color: const Color(0xFFFF6347)),

              const SizedBox(height: 20),

              //Email Field
              Form(
                key: _formKey,
                child: //Email Field
                TextFormField(
                  controller: _emailController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: InputDecoration(
                    labelText: "Email",
                    labelStyle: TextStyle(color: Colors.black),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: const Color(0xFFFF6347), width: 2),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(color: Colors.grey, width: 2),
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
              ),
              const SizedBox(height: 20),

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
                                .forgotPassword(_emailController.text);
                            //await Future.delayed(Duration(milliseconds: 500));
                            final newState = ref.read(authProvider);
                            if (newState.message != null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    newState.message!,
                                    style: TextStyle(fontSize: 20),
                                  ),
                                  backgroundColor: newState.isCodeSent
                                      ? Colors.green
                                      : Colors.red,
                                  duration: Duration(seconds: 4),
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

                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF6347),
                    foregroundColor: Colors.white,
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: authState.isLoading
                      ? CircularProgressIndicator()
                      : Text(
                          "Send Email",
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
