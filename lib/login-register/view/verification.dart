import 'package:flutter/material.dart';
import 'dart:ui';

import 'package:pin_code_fields/pin_code_fields.dart';

class Verification extends StatefulWidget {
  const Verification({super.key});

  @override
  State<Verification> createState() => _VerificationState();
}

class _VerificationState extends State<Verification> {
  final _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // الخلفية
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/background.jpg"),
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),

          // طبقة التغبيش
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Container(
                color: Colors.black.withOpacity(0.1), // تظليل خفيف مع التغبيش
              ),
            ),
          ),

          // المحتوى الرئيسي
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

                  const SizedBox(height: 40),

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
                        Text(
                          "Enter Verification Code",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
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
                        Text(
                          "the verification code has sent to your email",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
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

                        PinCodeTextField(
                          length: 6,
                          appContext: context,
                          controller: _textController,
                          textStyle: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.normal,
                          ),
                          pinTheme: PinTheme(
                            shape: PinCodeFieldShape.box,
                            fieldWidth: 45,
                            selectedColor: Colors.orange,
                            inactiveColor: Colors.black,
                            borderWidth: 1,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          onChanged: (value) {},
                        ),

                        const SizedBox(height: 25),

                        Text(
                          "Don't receive code?",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
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

                        TextButton(
                          onPressed: () {},
                          child: Text(
                            "Resend Code",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              decoration: TextDecoration.underline,
                              decorationColor: Colors.white,
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
