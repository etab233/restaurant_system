import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurants_system/providers/auth-provider.dart';
import 'dart:ui';
import './logIn.dart';

class ResetPassword extends ConsumerStatefulWidget {
  const ResetPassword({super.key});

  @override
  ConsumerState<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends ConsumerState<ResetPassword> {
  final _blurIntensity = 5.0;
  final _passwordController = TextEditingController();
  final _passwordConfirmationController = TextEditingController();
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _passwordVisible1 = false;
  bool _passwordVisible2 = false;

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

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
                          "Reset Your Password",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
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
                                autovalidateMode: AutovalidateMode.onUnfocus,
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
                                obscureText: !_passwordVisible1,
                                autovalidateMode: AutovalidateMode.onUnfocus,
                                decoration: InputDecoration(
                                  labelText: 'New Password',
                                  
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
                                      _passwordVisible1 ? Icons.visibility : Icons.visibility_off,
                                      color: _passwordVisible1 ? const Color.fromARGB(255, 0, 0, 0) : Colors.grey,
                                    ),
                                    iconSize: 27,
                                    color: Colors.black,
                                    onPressed: () {
                                      setState(() {
                                        _passwordVisible1 = !_passwordVisible1;
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

                              const SizedBox(height: 25),

                              //password Confirmation Field
                              TextFormField(
                                controller: _passwordConfirmationController,
                                obscureText: !_passwordVisible2,
                                autovalidateMode: AutovalidateMode.onUnfocus,
                                decoration: InputDecoration(
                                  labelText: 'Confirm Password',
                                  
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
                                      _passwordVisible2 ? Icons.visibility : Icons.visibility_off,
                                      color: _passwordVisible2 ? const Color.fromARGB(255, 0, 0, 0) : Colors.grey,
                                    ),
                                    iconSize: 27,
                                    color: Colors.black,
                                    onPressed: () {
                                      setState(() {
                                        _passwordVisible2 = !_passwordVisible2;
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
                                    return "password Confirmation is required !";
                                  }
                                  if (value != _passwordController.text) {
                                    return "passwords don't match";
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

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            // return button
                            ElevatedButton(
                          onPressed:(){
                            showDialog(
                              context: context, 
                              builder: (ctx) => AlertDialog(
                                content: const Text("Are you Sure you want to discart this proccess?"),
                                actions: [
                                  TextButton(
                                    onPressed: (){
                                      Navigator.pop(ctx);
                                    },
                                    child: const Text('No')
                                  ),
                                  TextButton(
                                    onPressed: (){
                                      Navigator.pushReplacement(
                                        context, 
                                        MaterialPageRoute(builder: (_) => LogIn())
                                      );
                                    }, 
                                    child: const Text("Yes")
                                  ),
                                ],
                              ),
                            );
                          },

                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white.withOpacity(0.7),
                            shape: RoundedRectangleBorder(
                              side: BorderSide(color: Colors.orange),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            foregroundColor: Colors.black,
                            elevation: 10,
                            padding: EdgeInsets.symmetric(horizontal: 35),
                          ),
                          child: Text(
                            "Discard",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),

                        // reset button
                        ElevatedButton(
                          onPressed:
                            authState.isLoading
                            ? null
                            :() async{
                              if(_formKey.currentState!.validate()){
                                await ref.read(authProvider.notifier)
                                .reset_password(
                                  _emailController.text, 
                                  _passwordController.text, 
                                  _passwordConfirmationController.text
                                );
                                await Future.delayed(Duration(milliseconds: 500),);
                                final newState = ref.read(authProvider);
                                if(newState.message != null){
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        newState.message!,
                                        style: TextStyle(
                                          fontSize: 20,
                                        ),
                                      ),
                                      backgroundColor: newState.isPasswordSet
                                        ? Colors.green
                                        : Colors.red,
                                      duration: Duration(seconds: 4),
                                        ),
                                      );
                                      if(newState.isPasswordSet){
                                        Future.delayed(Duration(milliseconds: 500));
                                        Navigator.pushReplacement(
                                          context, 
                                          MaterialPageRoute(builder: (_)=> LogIn())
                                        );
                                      }
                                }
                              }
                            },

                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            foregroundColor: Colors.black,
                            elevation: 10,
                            padding: EdgeInsets.symmetric(horizontal: 35),
                          ),
                          child: Text(
                            "Reset",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
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
