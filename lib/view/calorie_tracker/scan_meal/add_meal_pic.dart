// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';
import 'package:restaurants_system/view/calorie_tracker/scan_meal/food_analysis_screen.dart';

class AddMealPic extends ConsumerStatefulWidget {
  const AddMealPic({super.key});
  @override
  ConsumerState<AddMealPic> createState() => AddMealPicState();
}

class AddMealPicState extends ConsumerState<AddMealPic>
    with SingleTickerProviderStateMixin {
  bool capturing = false;
  bool isTorchOn = false;
  final ImagePicker picker = ImagePicker();
  late AnimationController _scanLineController;
  late Animation<double> _scanLineAnimation;
  CameraController? cameraController;

  static const Color _green400 = Color(0xFF4EA86E);

  @override
  void initState() {
    super.initState();
    initCamera();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
    );
    _scanLineController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);
    _scanLineAnimation = CurvedAnimation(
      parent: _scanLineController,
      curve: Curves.easeInOut,
    );
  }

  // _____ fetch available camera in devices _______________________________
  Future<void> initCamera() async {
    final cameras = await availableCameras();
    cameraController = CameraController(cameras[0], ResolutionPreset.low);

    await cameraController!.initialize();
    if (!mounted) return;
    setState(() {});
  }

  // ____ A function to pick a picture ______________________________________
  Future<void> takePhoto() async {
    if (capturing ||
        cameraController == null ||
        !cameraController!.value.isInitialized)
      return;

    setState(() {
      capturing = true;
    });
    final file = await cameraController!.takePicture();

    // ايقاف الكاميرا بعد الالتقاط
    await cameraController?.stopImageStream();
    await cameraController?.dispose();
    cameraController = null;

    if (!mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => FoodAnalysisScreen(imagePath: file.path),
      ),
    );

    setState(() {
      capturing = false;
    });
  }

  // ____ A function to pick a picture from gallery __________________________
  Future<void> pickFromGallery() async {
    if (capturing ||
        cameraController == null ||
        !cameraController!.value.isInitialized)
      return;

    setState(() {
      capturing = true;
    });

    try {
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);

      // إذا المستخدم ما اختار صورة
      if (image == null) {
        setState(() {
          capturing = false;
        });
        return;
      }

      await cameraController?.dispose();
      cameraController = null;

      if (!mounted) return;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => FoodAnalysisScreen(imagePath: image.path),
        ),
      );
    } catch (e) {
      print("Gallery error: $e");
    } finally {
      if (mounted) {
        setState(() {
          capturing = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _scanLineController.dispose();
    cameraController?.dispose();
    cameraController = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final frameSize = size.width * 0.8;
    final frameHeight = MediaQuery.of(context).size.height * 0.55;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          //Camera Feed
          if (cameraController != null &&
              cameraController!.value.isInitialized == true)
            Positioned.fill(child: CameraPreview(cameraController!))
          else
            const Center(
              child: CircularProgressIndicator(color: Color(0xFFFF6B35)),
            ),

          //Dark Overlay with cutout
          Positioned.fill(
            child: CustomPaint(
              painter: OverlayPainter(frameSize: frameSize, screenSize: size),
            ),
          ),

          // ── Scanner Frame Corners ────────────────────────────
          Center(
            child: SizedBox(
              width: frameSize,
              height: frameHeight,
              child: Stack(
                children: [
                  // أركان الإطار
                  ...buildCorners(frameSize),

                  // خط المسح المتحرك
                  AnimatedBuilder(
                    animation: _scanLineAnimation,
                    builder: (_, __) => Positioned(
                      top: 12 + (_scanLineAnimation.value * (frameHeight - 24)),
                      left: 16,
                      right: 16,
                      child: Container(
                        height: 2,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.transparent,
                              _green400.withOpacity(0.9),
                              Colors.transparent,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          Column(
            children: [
              // ── Top Bar ──────────────────────────────────────────
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // زر الرجوع
                      _iconBtn(
                        icon: Icons.arrow_back_ios_new_rounded,
                        onTap: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 25),
              Text(
                "Center your plate in the frame",
                style: TextStyle(
                  color: Colors.white,
                  //fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              Spacer(),
              Padding(
                padding: EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    // زر المعرض
                    _iconBtn(
                      icon: Icons.photo_size_select_actual_rounded,
                      iconColor: Colors.white,
                      onTap: () => pickFromGallery(),
                    ),

                    // زر التقاط الصورة
                    InkWell(
                      onTap: takePhoto,
                      child: Container(
                        width: 85,
                        height: 85,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 10),
                        ),
                        child: Center(
                          child: Container(
                            width: 65,
                            height: 65,
                            decoration: const BoxDecoration(
                              color: Color(0xFFFF6B35),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ),
                    ),

                    // زر الفلاش
                    _iconBtn(
                      icon: isTorchOn
                          ? Icons.flash_on_rounded
                          : Icons.flash_off_rounded,
                      iconColor: isTorchOn ? _green400 : Colors.white,
                      onTap: () {
                        setState(() => isTorchOn = !isTorchOn);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── زر أيقونة ────────────────────────────────────────────────
  Widget _iconBtn({
    required IconData icon,
    required VoidCallback onTap,
    Color iconColor = Colors.white,
  }) => GestureDetector(
    onTap: onTap,
    child: Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        shape: BoxShape.circle,
        //borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.15), width: 0.5),
      ),
      child: Icon(icon, color: iconColor, size: 22),
    ),
  );
}

// ── Overlay Painter — الظل حول إطار المسح ────────────────────
class OverlayPainter extends CustomPainter {
  final double frameSize;
  final Size screenSize;

  const OverlayPainter({required this.frameSize, required this.screenSize});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.black.withOpacity(0.62);
    // إحداثيات مركز الشاشة
    final cx = size.width / 2;
    final cy = size.height / 2;
    //final half = frameSize / 2;
    const r = 12.0;

    final full = Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height));
    final hole = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
            center: Offset(cx, cy),
            width: frameSize,
            height: frameSize,
          ),
          const Radius.circular(r),
        ),
      );

    canvas.drawPath(Path.combine(PathOperation.difference, full, hole), paint);
  }

  // متى يجب أن نعيد الرسم
  @override
  bool shouldRepaint(OverlayPainter old) =>
      old.frameSize != frameSize || old.screenSize != screenSize;
}

// ── أركان الإطار ─────────────────────────────────────────────
List<Widget> buildCorners(double size) {
  const len = 24.0;
  const thick = 3.0;
  const radius = 6.0;

  Widget corner({
    required Alignment alignment,
    required BorderRadius borderRadius,
  }) => Align(
    alignment: alignment,
    child: SizedBox(
      width: len,
      height: len,
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border(
            top: alignment.y < 0
                ? const BorderSide(color: Color(0xFFFF6B35), width: thick)
                : BorderSide.none,
            bottom: alignment.y > 0
                ? const BorderSide(color: Color(0xFFFF6B35), width: thick)
                : BorderSide.none,
            left: alignment.x < 0
                ? const BorderSide(color: Color(0xFFFF6B35), width: thick)
                : BorderSide.none,
            right: alignment.x > 0
                ? const BorderSide(color: Color(0xFFFF6B35), width: thick)
                : BorderSide.none,
          ),
          borderRadius: borderRadius,
        ),
      ),
    ),
  );

  return [
    corner(
      alignment: Alignment.topLeft,
      borderRadius: const BorderRadius.only(topLeft: Radius.circular(radius)),
    ),
    corner(
      alignment: Alignment.topRight,
      borderRadius: const BorderRadius.only(topRight: Radius.circular(radius)),
    ),
    corner(
      alignment: Alignment.bottomLeft,
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(radius),
      ),
    ),
    corner(
      alignment: Alignment.bottomRight,
      borderRadius: const BorderRadius.only(
        bottomRight: Radius.circular(radius),
      ),
    ),
  ];
}
