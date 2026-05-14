// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurants_system/providers/health_profile.dart';
import 'package:restaurants_system/view/calorie_tracker/dashboard/dashboard_main_screen.dart';
import 'package:restaurants_system/view/calorie_tracker/form/gender.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Welcome extends ConsumerStatefulWidget {
  const Welcome({super.key});

  @override
  ConsumerState<Welcome> createState() => WelcomeState();
}

class WelcomeState extends ConsumerState<Welcome>
    with TickerProviderStateMixin {

  
  late AnimationController switchController;
  late Animation<double>   switchAnimation;

  
  late AnimationController _leafController;
  late AnimationController _glowController;
  late Animation<double>   _leafFloat;
  late Animation<double>   _glowPulse;

  bool    hasAccount = false;
  String? token;

  
  Future<void> check() async {
    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString("token");
    if (token == null) { hasAccount = false; return; }
    final result = await ref
        .read(healthProfileProvider.notifier)
        .hasHealthAccount(token: token);
    hasAccount = result;
  }

  @override
  void initState() {
    super.initState();

    switchController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
      animationBehavior: AnimationBehavior.preserve,
    );
    switchController.addStatusListener((status) async {
      if (status == AnimationStatus.completed) {
        await check();
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => hasAccount ? Dashboard() : GenderScreen(),
          ),
        );
      }
    });
    switchAnimation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: switchController, curve: Curves.easeInOut),
    );

    // ── إضافة: أوراق عائمة ─────────────────────────
    _leafController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    )..repeat(reverse: true);
    _leafFloat = Tween(begin: 0.0, end: -12.0).animate(
      CurvedAnimation(parent: _leafController, curve: Curves.easeInOut),
    );

    // ── إضافة: توهج السويتش ────────────────────────
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);
    _glowPulse = Tween(begin: 0.3, end: 0.8).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) switchController.forward();
    });
  }

  @override
  void dispose() {
    switchController.dispose();
    _leafController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sw = MediaQuery.of(context).size.width;
    final sh = MediaQuery.of(context).size.height;

    return AnimatedBuilder(
      animation: switchController,
      builder: (context, _) {
        final val = switchAnimation.value;

        return Scaffold(
          body: Stack(
            children: [
              Positioned.fill(
                child: Opacity(
                  opacity: 1 - val,
                  child: Image.asset(
                    "assets/images/unhealthy.jpg",
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned.fill(
                child: Opacity(
                  opacity: val,
                  child: Image.asset(
                    "assets/images/healthy.jpg",
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              // ── طبقة تعتيم ناعمة ───────────────────
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0.25),
                        Colors.black.withOpacity(0.55),
                        Colors.black.withOpacity(0.25),
                      ],
                    ),
                  ),
                ),
              ),

              // ── أوراق زينة (تظهر مع التقدم) ────────
              AnimatedBuilder(
                animation: _leafFloat,
                builder: (_, __) => Stack(
                  children: [
                    Positioned(
                      top: sh * 0.08 + _leafFloat.value,
                      right: sw * 0.07,
                      child: Opacity(
                        opacity: val * 0.85,
                        child: const Icon(Icons.eco_rounded, size: 80, color: Colors.white),
                      ),
                    ),
                    Positioned(
                      top: sh * 0.12 - _leafFloat.value * 0.6,
                      left: sw * 0.06,
                      child: Opacity(
                        opacity: val * 0.7,
                        child: const Icon(Icons.eco_rounded, size: 80, color: Colors.white),
                      ),
                    ),
                    Positioned(
                      bottom: sh * 0.12 + _leafFloat.value * 0.5,
                      right: sw * 0.1,
                      child: Opacity(
                        opacity: val * 0.6,
                        child: const Icon(Icons.eco_rounded, size: 80, color: Colors.white), 
                      ),
                    ),
                  ],
                ),
              ),

              // ── المحتوى المركزي ─────────────────────
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    // ── "Switch to" ─────────────────────
                    Padding(
                      padding: EdgeInsets.only(left: sw * 0.05),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Switch to",
                            style: TextStyle(
                              color: Color.lerp(
                                Colors.white70,
                                const Color(0xFFA8D878),
                                val,
                              ),
                              fontSize: 26,
                              fontFamily: "Cormorant Garamond",
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.w700,
                              shadows: [
                                Shadow(
                                  color: Colors.black.withOpacity(0.4),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 2),

                          _buildSwitch(sw, sh, val),

                          const SizedBox(height: 10),

                          Text(
                            "A Healthy Life",
                            style: TextStyle(
                              color: Color.lerp(
                                Colors.white60,
                                const Color(0xFF7DB84A),
                                val,
                              ),
                              fontSize: 28,
                              fontFamily: "Cormorant Garamond",
                              fontWeight: FontWeight.w900,
                              letterSpacing: 0.5,
                              shadows: [
                                Shadow(
                                  color: Colors.black.withOpacity(0.5),
                                  blurRadius: 10,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // ── tagline تظهر مع التقدم ──────────
                    if (val > 0.6)
                      Padding(
                        padding: EdgeInsets.only(
                          left: sw * 0.05, top: 14),
                        child: Opacity(
                          opacity: ((val - 0.6) / 0.4).clamp(0.0, 1.0),
                          child: Text(
                            "Always been wishing for\nhealthy proteins. ✨",
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.75),
                              fontSize: 13,
                              fontFamily: "Cormorant Garamond",
                              fontStyle: FontStyle.italic,
                              height: 1.6,
                              shadows: [
                                Shadow(
                                  color: Colors.black.withOpacity(0.5),
                                  blurRadius: 6,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSwitch(double sw, double sh, double val) {
    final trackW = sw * 0.62;
    final trackH = sh * 0.1;
    final thumbR  = trackH * 0.46;

    return AnimatedBuilder(
      animation: _glowPulse,
      builder: (_, __) {
        return Container(
          width: trackW,
          height: trackH,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(trackH / 2),

            // لون المسار يتغير مع التقدم
            gradient: LinearGradient(
              colors: [
                Color.lerp(
                  const Color(0xFF6B6FA0),
                  const Color(0xFF2D5A1A),
                  val,
                )!,
                Color.lerp(
                  const Color(0xFF989FD5),
                  const Color(0xFF5A9A30),
                  val,
                )!,
              ],
            ),

            border: Border.all(
              color: Color.lerp(
                Colors.white.withOpacity(0.4),
                const Color(0xFF7DB84A).withOpacity(0.8),
                val,
              )!,
              width: 2,
            ),

            boxShadow: [
              // توهج أخضر يزداد مع التقدم
              BoxShadow(
                color: Color.lerp(
                  Colors.transparent,
                  const Color(0xFF4A7A2E).withOpacity(_glowPulse.value),
                  val,
                )!,
                blurRadius: 24,
                spreadRadius: 2,
              ),
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // OFF label
              Positioned(
                right: trackH * 0.22,
                child: Opacity(
                  opacity: (1 - val * 2).clamp(0.0, 1.0),
                  child: Text(
                    "OFF",
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.6),
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
              ),

              // ON label
              Positioned(
                left: trackH * 0.22,
                child: Opacity(
                  opacity: ((val - 0.5) * 2).clamp(0.0, 1.0),
                  child: const Text(
                    "ON",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
              ),

              Align(
                alignment: Alignment.lerp(
                  Alignment.centerLeft,
                  Alignment.centerRight,
                  switchAnimation.value,
                )!,
                child: Container(
                  margin: EdgeInsets.all(trackH * 0.07),
                  width:  thumbR * 2,
                  height: thumbR * 2,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Color.lerp(
                          Colors.black38,
                          const Color(0xFF4A7A2E).withOpacity(0.5),
                          val,
                        )!,
                        blurRadius: 14,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      "assets/images/fruit.png",
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}