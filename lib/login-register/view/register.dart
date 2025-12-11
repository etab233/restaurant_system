import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:ui';
import 'logIn.dart';
import 'package:restaurants_system/providers/auth-provider.dart';

class Register extends ConsumerStatefulWidget {
  const Register({super.key});
  @override
  ConsumerState<Register> createState() => _RegisterState();
}

class _RegisterState extends ConsumerState<Register> {

  final _nameController =   TextEditingController();
  final _emailController=   TextEditingController();
  final _passwordController= TextEditingController();
  final _passwordConfirmationController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _passwordVisible1=false;
  bool _passwordVisible2=false;

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    return Scaffold(
      body: Stack(
        children: [
          // الخلفية
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

          // طبقة التغبيش
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 5,
                sigmaY: 5,
              ),
              child: Container(
                color: Colors.black.withOpacity(0.1), 
              ),
            ),
          ),

          // محتوى الواجهة الأساسي
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

                  SizedBox(height: 30),

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
                          "Create new account",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 33,
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

                        const SizedBox(height: 20,),

                        Form(
                          key: _formKey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Name Field
                              TextFormField(
                                controller: _nameController,
                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                decoration: InputDecoration(
                                  labelText: "User Name",
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
                                  errorStyle: TextStyle(
                                    fontSize: 14,
                                    color: const Color.fromARGB(255, 0, 0, 0),
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FontStyle.italic,
                                  ),
                                  filled: true,
                                  fillColor: Colors.white.withOpacity(0.7),
                                  prefixIcon: Icon(
                                    Icons.person,
                                    size: 27,
                                    color: Colors.black,
                                  ),
                                ),
                                validator: (value) {
                                    if (value == null || value.isEmpty){
                                      return "User Name is required !";
                                    }
                                    if(RegExp(r'^[0-9]').hasMatch(value.trim())){
                                      return "shouldn't start with number";
                                    }
                                    if (value.length < 2) {
                                      return "at least 2 characters";
                                    }
                                    if (value.length > 50) {
                                      return "can't exceed 50 characters";
                                    }
                                    return null;
                                  },
                              ),

                              const SizedBox(height: 20),

                              // Email Field
                              TextFormField(
                                controller: _emailController,
                                autovalidateMode: AutovalidateMode.onUserInteraction,
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
                                    if (value == null || value.isEmpty){
                                      return "Email is required !";
                                    }
                                    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
                                    if (!emailRegex.hasMatch(value)) {
                                      return "Enter a valid email address";
                                    }
                                    return null;
                                  },
                              ),

                              const SizedBox(height: 20),

                              // Password Field 
                              TextFormField(
                                controller: _passwordController,
                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                obscureText: !_passwordVisible1,
                                decoration: InputDecoration(
                                  labelText: 'Password',
                                  labelStyle: TextStyle(color: Colors.black),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    borderSide: BorderSide(
                                      color: Colors.orange,
                                      width: 2,
                                    ),
                                  ),
                                  errorStyle: TextStyle(
                                    fontSize: 14,
                                    color: const Color.fromARGB(255, 0, 0, 0),
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FontStyle.italic,
                                  ),
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
                                  errorMaxLines: 2,
                                  fillColor: Colors.white.withOpacity(0.7),
                                  prefixIcon: Icon(
                                    Icons.lock,
                                    size: 27,
                                    color: Colors.black,
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty){
                                    return "password is required !";}
                                  if (value.length < 8){
                                    return "8 characters at least !";}
                                  // محارف كبيرة و صغيرة و أ{قام و رموز}
                                  String pattern =
                                      r'^(?=.*[a-z])(?=.*[0-9])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&]).+$';
                                  final regExp = RegExp(pattern);

                                  if (!regExp.hasMatch(value)) {
                                    return "must contain uppercase, lowercase, number & special character";
                                  }
                                  return null;
                                },
                              ),
                              
                              const SizedBox(height: 20),

                              // password confirmation
                              TextFormField(
                                controller: _passwordConfirmationController,
                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                obscureText: !_passwordVisible2,
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
                                  errorStyle: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FontStyle.italic,
                                  ),
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
                                  if (value == null || value.isEmpty){
                                    return "password is required !";}
                                  if (_passwordController.text != _passwordConfirmationController.text){
                                    return "passwords don't much";
                                  }
                                  return null;
                                }, 
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20,),

                        ElevatedButton(
                          onPressed:
                            authState.isLoading
                            ? null
                            : () async{
                              if(_formKey.currentState!.validate()){
                                await ref.read(authProvider.notifier).register(
                                  _nameController.text,
                                  _emailController.text,
                                  _passwordController.text,
                                  _passwordConfirmationController.text,
                                );
                                await Future.delayed(Duration(milliseconds: 100),);
                                final newState = ref.read(authProvider);
                                if (newState.message != null) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            newState.message!,
                                            style: TextStyle(
                                              fontSize: 20,
                                            ),
                                          ),
                                          backgroundColor: newState.isRegistered
                                              ? Colors.green
                                              : Colors.red,
                                          duration: Duration(seconds: 4),
                                        ),
                                      );
                                      if (newState.isRegistered){
                                        /*Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(builder: (_) {});
                                        );*/
                                      }
                                    }
                              }
                            },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            foregroundColor: Colors.black,
                            elevation: 10,
                            padding: EdgeInsets.symmetric(horizontal: 60,),
                          ),
                          child: Text(
                            "Register",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                                "Already have an account",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  shadows: [
                                    Shadow(
                                    blurRadius: 5.0,
                                    color: Color.fromARGB(79, 255, 255, 255),
                                    offset:Offset (2.0,2.0),
                                    ),
                                  ],
                                ),
                              ),
                             
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
                        )
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
