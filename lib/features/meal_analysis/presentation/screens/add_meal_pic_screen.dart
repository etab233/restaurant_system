// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';
import 'package:restaurants_system/features/meal_analysis/presentation/screens/add_description_screen.dart';

class AddMealPicScreen extends ConsumerStatefulWidget {
  const AddMealPicScreen({super.key});
  @override
  ConsumerState<AddMealPicScreen> createState() => _AddMealPicScreenState();
}

class _AddMealPicScreenState extends ConsumerState<AddMealPicScreen>
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

  Future<void> initCamera() async {
    final cameras = await availableCameras();
    cameraController = CameraController(cameras[0], ResolutionPreset.medium);
    await cameraController!.initialize();
    if (!mounted) return;
    setState(() {});
  }

  Future<void> takePhoto() async {
    if (capturing ||
        cameraController == null ||
        !cameraController!.value.isInitialized) {
      return;
    }

    try {
      setState(() {
        capturing = true;
      });
      final file = await cameraController!.takePicture();

      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => AddDescriptionScreen(imagePath: file.path),
        ),
      );
    } catch (e) {
      debugPrint("Camera error: $e");
    } finally {
      if (mounted) {
        setState(() {
          capturing = false;
        });
      }
    }
  }

  Future<void> pickFromGallery() async {
    if (capturing ||
        cameraController == null ||
        !cameraController!.value.isInitialized) {
      return;
    }

    setState(() {
      capturing = true;
    });

    try {
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);

      if (image == null) {
        setState(() {
          capturing = false;
        });
        return;
      }

      if (!mounted) return;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => AddDescriptionScreen(imagePath: image.path),
        ),
      );
    } catch (e) {
      debugPrint("Gallery error: $e");
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
          if (cameraController != null &&
              cameraController!.value.isInitialized == true)
            Positioned.fill(child: CameraPreview(cameraController!))
          else
            const Center(
              child: CircularProgressIndicator(color: Color(0xFFFF6B35)),
            ),
          Center(
            child: SizedBox(
              width: frameSize,
              height: frameHeight,
              child: Stack(
                children: [
                  ...buildCorners(frameSize),
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
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _iconBtn(
                        icon: Icons.arrow_back_ios_new_rounded,
                        onTap: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 25),
              const Text(
                "Center your plate in the frame",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _iconBtn(
                      icon: Icons.photo_size_select_actual_rounded,
                      iconColor: Colors.white,
                      onTap: () => pickFromGallery(),
                    ),
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
        border: Border.all(color: Colors.white.withOpacity(0.15), width: 0.5),
      ),
      child: Icon(icon, color: iconColor, size: 22),
    ),
  );
}

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
      borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(radius)),
    ),
    corner(
      alignment: Alignment.bottomRight,
      borderRadius: const BorderRadius.only(bottomRight: Radius.circular(radius)),
    ),
  ];
}