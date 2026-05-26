// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurants_system/view/bottom_navbar.dart';

class CurveClipper extends CustomClipper<Path> {
  @override
  getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height * 0.88);

    path.quadraticBezierTo(
      size.width * 0.22, //  X's of first_control point
      size.height * 0.70, //  Y's of first_control point
 
      size.width * 0.48, //  X's of end point
      size.height * 0.82, //  Y's of end point
    );

    path.quadraticBezierTo(
      size.width * 0.68,
      size.height * 0.95,

      size.width * 0.92,
      size.height * 0.82,
    );

    path.quadraticBezierTo(
      size.width * 0.98,
      size.height * 0.78,

      size.width,
      size.height * 0.86,
    );

    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldCliper) {
    return false;
  }
}

class MealDetails extends ConsumerStatefulWidget {
  final String? image;
  final int id;
  const MealDetails({super.key, this.image, required this.id});
  @override
  ConsumerState<MealDetails> createState() => MealDetailsState();
}

class MealDetailsState extends ConsumerState<MealDetails> {
  @override
  Widget build(BuildContext build) {
    return Scaffold(
      bottomNavigationBar: BottomNavBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Hero(
                    tag: "meal_${widget.id}",
                    child: ClipPath(
                      clipper: CurveClipper(),
                      child: (widget.image != null)
                          ? Image.network(
                              widget.image!,
                              width: double.infinity,
                              height: MediaQuery.of(context).size.height*0.30,
                              fit: BoxFit.cover,
                            )
                          : Container(
                              width: double.infinity,
                              height: MediaQuery.of(context).size.height*0.30,
                              color: Colors.grey.shade200,
                              child: Image.asset(
                                "assets/images/meal.jpg",
                                fit: BoxFit.cover,
                              ),
                            ),
                    ),
                  ),

                  Positioned(
                    top: 15,
                    left: 10,
                    child: CircleAvatar(
                      backgroundColor: Colors.grey.shade300,
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.black),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 15,
                    right: 10,
                    child: CircleAvatar(
                      backgroundColor: Colors.grey.shade300,
                      child: IconButton(
                        icon: const Icon(
                          Icons.favorite_border,
                          color: Color(0xFFFF6B35),
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "تشيز برغر",
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 12),

                    // الصف العلوي (الأكثر طلباً + الوقت)
                    Row(
                      children: [
                        // Badge "الأكثر طلباً"
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFE7D6),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Row(
                            children: const [
                              Text(
                                "الأكثر طلباً",
                                style: TextStyle(
                                  color: Color(0xFFFF6B35),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(width: 4),
                              Icon(
                                Icons.star,
                                size: 18,
                                color: Color(0xFFFF6B35),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(width: 12),

                        // الوقت
                        Row(
                          children: const [
                            Icon(
                              Icons.access_time,
                              size: 18,
                              color: Colors.grey,
                            ),
                            SizedBox(width: 4),
                            Text(
                              "15-20 دقيقة",
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // الوصف
                    const Text(
                      "قطعة لحم بقري مشوية مع جبنة شيدر، خس طازج، طماطم، بصل، ومذاقها الخاص من الصوص.",
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
