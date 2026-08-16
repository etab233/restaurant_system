// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'login.dart';

class Welcome extends StatefulWidget{
  const Welcome({super.key});

  @override
  State<Welcome> createState() => WelcomeState();
}

class WelcomeState extends State<Welcome>{

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 2), (){
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_)=> const Login())
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
          children: [
            Container(
              decoration:const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/background.webp"),
                  fit: BoxFit.cover,
                ),
              ),
              child: null,
            ),
            Align(
              alignment: Alignment.center,
              child: TweenAnimationBuilder(
                tween: Tween<double>(begin: 0.0, end: 1.0) ,
                duration: const Duration(seconds: 2),
                builder: (BuildContext context, double value, Widget? child ) {
                  final screenHieght= MediaQuery.of(context).size.height;
                  final targetOffset= -(screenHieght*0.40); // يرتفع إلى 40 بالمئة 
                  return Opacity(
                    opacity: value,
                    child: Transform.translate(
                      offset: Offset(0, targetOffset *value),
                      child: child,
                    ),
                  );
                 },
                 child:const  Text(
                  " Your next meal starts here ",
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Nunito',
                    fontSize: 28,
                    shadows: [
                      Shadow(
                      blurRadius: 5.0,
                      color:  Color.fromARGB(79, 255, 255, 255),
                      offset:Offset (2.0,2.0),
                    ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
    );
  }
}