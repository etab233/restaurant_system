// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'hive_setup.dart';

class AppInitializer extends StatefulWidget {
  final Widget Function() appBuilder;

  const AppInitializer({super.key, required this.appBuilder});

  @override
  State<AppInitializer> createState() => _AppInitializerState();
}

class _AppInitializerState extends State<AppInitializer> {
  late final Future<void> _initFuture;

  bool _customSplashFinished = false;

  @override
  void initState() {
    super.initState();

    _initFuture = setupHive();
  }

  void _finishCustomSplash() {
    if (!mounted) return;

    setState(() {
      _customSplashFinished = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _initFuture,
      builder: (context, snapshot) {
        // خطأ في Hive
        if (snapshot.hasError) {
          return _SplashErrorScreen(error: snapshot.error.toString());
        }

        // Custom Splash
        if (!_customSplashFinished) {
          return _SplashScreen(onFinished: _finishCustomSplash);
        }

        // Custom Splash خلصت لكن Hive لسا
        if (snapshot.connectionState != ConnectionState.done) {
          return _SplashScreen(onFinished: _finishCustomSplash);
        }

        // كل شيء جاهز
        return widget.appBuilder();
      },
    );
  }
}

class _SplashScreen extends StatefulWidget {
  final VoidCallback onFinished;
  const _SplashScreen({required this.onFinished});

  @override
  State<_SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<_SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _steamController;
  late final AnimationController _logoController;
  late final AnimationController _textController;

  late final Animation<double> _logoScale;
  late final Animation<double> _logoFade;

  late final Animation<Offset> _textSlide;
  late final Animation<double> _textFade;

  @override
  void initState() {
    super.initState();

    // =========================
    // STEAM
    // =========================
    _steamController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat();

    // =========================
    // LOGO
    // =========================
    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _logoScale = CurvedAnimation(
      parent: _logoController,
      curve: Curves.elasticOut,
    );

    _logoFade = CurvedAnimation(parent: _logoController, curve: Curves.easeIn);

    // =========================
    // TEXT
    // =========================
    _textController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _textSlide = Tween<Offset>(begin: const Offset(0, 0.35), end: Offset.zero)
        .animate(
          CurvedAnimation(parent: _textController, curve: Curves.easeOutCubic),
        );

    _textFade = CurvedAnimation(parent: _textController, curve: Curves.easeIn);

    // Start logo
    _logoController.forward();

    // Start text slightly later
    Future.delayed(const Duration(milliseconds: 350), () {
      if (mounted) {
        _textController.forward();
      }
    });

    // Finish splash after 3 seconds
    Future.delayed(const Duration(milliseconds: 3000), () {
      if (mounted) {
        widget.onFinished();
      }
    });
  }

  @override
  void dispose() {
    _steamController.dispose();
    _logoController.dispose();
    _textController.dispose();
    super.dispose();
  }

  Widget _steamLine({required double delay, required double height}) {
    final progress = (_steamController.value + delay) % 1.0;

    // يبدأ شفاف
    // يظهر
    // ثم يختفي
    double opacity;

    if (progress < 0.15) {
      opacity = progress / 0.15;
    } else if (progress > 0.65) {
      opacity = (1 - progress) / 0.35;
    } else {
      opacity = 1;
    }

    // حركة للأعلى
    final offsetY = -55 * progress;

    // حركة جانبية بسيطة
    final offsetX = 8 * (progress < 0.5 ? progress : 1 - progress);

    return Transform.translate(
      offset: Offset(offsetX, offsetY),
      child: Opacity(
        opacity: opacity.clamp(0.0, 1.0),
        child: Container(
          width: 4,
          height: height,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.75),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFFF6B35), Color(0xFFE85A2A)],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // =========================
              // LOGO + STEAM
              // =========================
              SizedBox(
                width: 150,
                height: 170,
                child: Stack(
                  alignment: Alignment.center,
                  clipBehavior: Clip.none,
                  children: [
                    // STEAM
                    Positioned(
                      top: 0,
                      child: AnimatedBuilder(
                        animation: _steamController,
                        builder: (context, child) {
                          return SizedBox(
                            width: 90,
                            height: 70,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                _steamLine(delay: 0.0, height: 22),
                                _steamLine(delay: 0.33, height: 28),
                                _steamLine(delay: 0.66, height: 24),
                              ],
                            ),
                          );
                        },
                      ),
                    ),

                    // LOGO
                    Positioned(
                      bottom: 5,
                      child: ScaleTransition(
                        scale: _logoScale,
                        child: FadeTransition(
                          opacity: _logoFade,
                          child: Container(
                            width: 92,
                            height: 92,
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 20,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: Image.asset(
                              "assets/icon/app_icon.png",
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 8),

              // =========================
              // TEXT
              // =========================
              SlideTransition(
                position: _textSlide,
                child: FadeTransition(
                  opacity: _textFade,
                  child: const Column(
                    children: [
                      Text(
                        "NutriLink",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.3,
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        "Fresh • Healthy • Tasty",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
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

class _SplashErrorScreen extends StatelessWidget {
  final String error;
  const _SplashErrorScreen({required this.error});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline_rounded,
                size: 48,
                color: Colors.red,
              ),
              const SizedBox(height: 12),
              const Text(
                "حدث خطأ أثناء تشغيل التطبيق",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),
              Text(
                error,
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
