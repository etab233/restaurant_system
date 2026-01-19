import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:ui';
import 'logIn.dart';
import 'verification.dart';
import 'package:restaurants_system/providers/auth-provider.dart';

class ForgotPassword extends ConsumerStatefulWidget {
  const ForgotPassword({super.key});

  @override
  ConsumerState<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends ConsumerState<ForgotPassword> {
  final _blurIntensity = 5.0;
  final _emailController   = TextEditingController();
  final _formKey = GlobalKey<FormState>();

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
                          offset:Offset (2.0,2.0),
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
                    child:Column(
                      children: [
                        const Text(
                          "Forgot Password?",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 34,
                            fontFamily: "Nunito",
                            shadows: [
                              Shadow(
                                blurRadius: 5.0,
                                color: Color.fromARGB(79, 255, 255, 255),
                                offset:Offset (2.0,2.0),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10,),
                        Icon(
                          Icons.key,
                          size: 35,
                          color: Colors.orange,
                        ),

                        const SizedBox(height: 20,),
                        
                        //Email Field
                      Form(
                        key: _formKey,
                        child:TextFormField(
                          controller: _emailController,
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
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.7),
                          prefixIcon: Icon(
                            Icons.email,
                            size: 27,
                            color: Colors.black,
                          ),
                        ),
                          validator: (value) {
                            if (value == null || value.isEmpty){
                              return "Email is required !";}
                            if (!value.contains('@')){
                              return "Enter a valid Email";}
                            return null;
                          },
                      ),),
                      const SizedBox(height: 20,),

                        ElevatedButton(
                          onPressed: authState.isLoading
                            ? null
                            : () async{
                              if(_formKey.currentState != null &&_formKey.currentState!.validate()){
                                await ref.read(authProvider.notifier).forgot_password(_emailController.text);
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
                                      backgroundColor: newState.isCodeSent
                                              ? Colors.green
                                              : Colors.red,
                                          duration: Duration(seconds: 4),
                                    )
                                  );
                                }
                                Future.delayed(Duration(seconds: 2));
                                if(newState.isCodeSent){
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (_)=> Verification())
                                  );
                                }
                              }
                            },

                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            foregroundColor: Colors.black,
                            elevation: 10,
                            padding: EdgeInsets.symmetric(horizontal: 70,),
                          ),
                          child: Text(
                            "Submit",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ),

                        const SizedBox(height: 20,),

                        TextButton(
                              child: Text(
                                "back to log in",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline,
                                  decorationColor: Colors.white,
                                  color: Colors.white,
                                  shadows: [
                                    Shadow(
                                    blurRadius: 5.0,
                                    color: Color.fromARGB(79, 255, 255, 255),
                                    offset:Offset (2.0,2.0),
                                    ),
                                  ],
                                ),
                              ),
                              onPressed: (){
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => LogIn(),
                                  ),
                                );
                              },
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