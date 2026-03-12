import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurants_system/providers/auth_provider.dart';
import 'reset_password.dart';
import '../home.dart';

class Verification extends ConsumerStatefulWidget {
  final String purpose;
  final String email;
  const Verification({super.key, required this.purpose, required this.email});

  @override
  ConsumerState<Verification> createState() => _VerificationState();
}

class _VerificationState extends ConsumerState<Verification> {
  final _textController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back, size: 30),
        ),
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.03),
              Text(
                "Enter Verification Code",
                style: TextStyle(
                  color: Colors.black,
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
                  color: Colors.black,
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
                  selectedColor: Colors.red,
                  inactiveColor: Colors.black,
                  borderWidth: 1,
                  borderRadius: BorderRadius.circular(8),
                ),
                onCompleted: (value) async {
                  try {
                    await ref
                        .read(authProvider.notifier)
                        .verifyOtp(widget.email,value , widget.purpose);
                    await Future.delayed(const Duration(milliseconds: 200));
                    if (!mounted) return;
                    final newState = ref.read(authProvider);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          newState.message!,
                          style: TextStyle(fontSize: 20),
                        ),
                        backgroundColor: newState.isVerify
                            ? Colors.green
                            : Colors.red,
                        duration: Duration(seconds: 3),
                      ),
                    );
                    if (newState.isVerify && newState.isCodeSent) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => ResetPassword()),
                      );
                    } else if (newState.isVerify && newState.isRegistered) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => Home()),
                      );
                    }
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Error: $e"),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
              ),

              const SizedBox(height: 35),
              TextButton(
                onPressed: () async {
                  final newState = ref.read(authProvider);
                  await ref
                      .read(authProvider.notifier)
                      .forgotPassword(newState.userData!['email']);
                  await Future.delayed(Duration(milliseconds: 500));
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
                },
                child: Text(
                  "Resend Code",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                    decoration: TextDecoration.underline,
                    decorationColor: Colors.black,
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
      ),
    );
  }
}
