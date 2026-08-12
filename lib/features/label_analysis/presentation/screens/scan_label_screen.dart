// ignore_for_file: deprecated_member_use

import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:restaurants_system/features/auth/presentation/providers/auth_provider.dart';
import 'package:restaurants_system/features/calorie_dashboard/presentation/providers/dashboard_notifier.dart';
import '../providers/analyze_label_notifier.dart';

class ScanLabelScreen extends ConsumerStatefulWidget {
  const ScanLabelScreen({super.key});
  @override
  ConsumerState<ScanLabelScreen> createState() => _ScanLabelScreenState();
}

class _ScanLabelScreenState extends ConsumerState<ScanLabelScreen>
    with TickerProviderStateMixin {
  static const _purple = Color(0xFF9B5DE5);
  static const _green = Color(0xFF4A7A2E);
  static const _orange = Color(0xFFFF6B35);

  CameraController? _camCtrl;
  bool _cameraReady = false;
  bool _capturing = false;
  bool _flashOn = false;
  final ImagePicker _picker = ImagePicker();

  _ScanState _state = _ScanState.camera;
  String? _imagePath;
  String? _error;

  late AnimationController _scanLineCtrl;
  late Animation<double> _scanLinePos;
  late AnimationController _sheetCtrl;
  late Animation<double> _sheetAnim;

  @override
  void initState() {
    super.initState();
    _initCamera();

    _scanLineCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2800),
    )..repeat(reverse: true);
    _scanLinePos = Tween(
      begin: 0.08,
      end: 0.82,
    ).animate(CurvedAnimation(parent: _scanLineCtrl, curve: Curves.easeInOut));

    _sheetCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _sheetAnim = CurvedAnimation(
      parent: _sheetCtrl,
      curve: Curves.fastLinearToSlowEaseIn,
    );
  }

  Future<void> _initCamera() async {
    final cams = await availableCameras();
    _camCtrl = CameraController(cams.first, ResolutionPreset.medium);
    await _camCtrl!.initialize();
    if (mounted) setState(() => _cameraReady = true);
  }

  Future<void> _toggleFlash() async {
    if (_camCtrl == null) return;
    try {
      _flashOn = !_flashOn;
      await _camCtrl!.setFlashMode(_flashOn ? FlashMode.torch : FlashMode.off);
      setState(() {});
    } catch (e) {
      _showError("Flash not available");
    }
  }

  Future<String?> _getToken() {
    return ref.read(authRepositoryProvider).getCurrentToken();
  }

  Future<void> _pickFromGallery() async {
    try {
      final image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );
      if (image == null) return;

      setState(() {
        _imagePath = image.path;
        _state = _ScanState.analyzing;
      });

      final token = await _getToken();
      if (token == null) {
        _showError("Please login first");
        setState(() => _state = _ScanState.camera);
        return;
      }

      await ref
          .read(analyzeLabelProvider.notifier)
          .analyze(imagePath: image.path, token: token);

      setState(() => _state = _ScanState.results);
      _sheetCtrl.forward();
    } catch (e) {
      _showError("Failed to pick image");
      setState(() => _state = _ScanState.camera);
    }
  }

  @override
  void dispose() {
    _camCtrl?.dispose();
    _scanLineCtrl.dispose();
    _sheetCtrl.dispose();
    super.dispose();
  }

  Future<void> _capture() async {
    if (_capturing || !_cameraReady) return;
    setState(() {
      _capturing = true;
      _state = _ScanState.analyzing;
    });

    try {
      final file = await _camCtrl!.takePicture();
      _imagePath = file.path;

      final token = await _getToken();
      if (token == null) {
        _showError("Please login first");
        setState(() => _state = _ScanState.camera);
        return;
      }

      await ref
          .read(analyzeLabelProvider.notifier)
          .analyze(imagePath: _imagePath!, token: token);

      setState(() => _state = _ScanState.results);
      _sheetCtrl.forward();
    } catch (e) {
      setState(() {
        _error = e.toString();
        _state = _ScanState.camera;
      });
      _showError(_error!);
    } finally {
      setState(() => _capturing = false);
    }
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: Colors.red.shade700,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  void _retake() {
    _sheetCtrl.reverse().then((_) {
      setState(() {
        _state = _ScanState.camera;
        _imagePath = null;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: switch (_state) {
        _ScanState.camera => _buildCamera(),
        _ScanState.analyzing => _buildAnalyzing(),
        _ScanState.results => _buildResults(),
      },
    );
  }

  Widget _buildCamera() {
    return Stack(
      children: [
        if (_cameraReady)
          Positioned.fill(child: CameraPreview(_camCtrl!))
        else
          const Center(
            child: CircularProgressIndicator(color: Color(0xFF9B7FD4)),
          ),
        const Positioned.fill(
          child: CustomPaint(painter: _FrameDimPainter(color: _purple)),
        ),
        Positioned(
          top: MediaQuery.of(context).padding.top + 16,
          left: 0,
          right: 0,
          child: const Text(
            "Frame the nutrition label",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Colors.white70,
            ),
          ),
        ),
        Positioned(
          top: MediaQuery.of(context).padding.top + 12,
          left: 14,
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: Colors.black45,
                borderRadius: BorderRadius.circular(11),
              ),
              child: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Colors.white,
                size: 17,
              ),
            ),
          ),
        ),
        AnimatedBuilder(
          animation: _scanLinePos,
          builder: (_, __) {
            final h = MediaQuery.of(context).size.height;
            final fTop = h * 0.22, fBot = h * 0.72;
            final fH = fBot - fTop;
            return Positioned(
              top: fTop + fH * _scanLinePos.value,
              left: MediaQuery.of(context).size.width * 0.12,
              right: MediaQuery.of(context).size.width * 0.12,
              child: Container(
                height: 2,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Colors.transparent, _purple, Colors.transparent],
                  ),
                  boxShadow: [
                    BoxShadow(color: _purple.withOpacity(0.6), blurRadius: 8),
                  ],
                ),
              ),
            );
          },
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            padding: EdgeInsets.fromLTRB(
              30,
              20,
              30,
              MediaQuery.of(context).padding.bottom + 20,
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, Colors.black.withOpacity(0.85)],
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _camSideBtn(Icons.photo_library_outlined, _pickFromGallery),
                _shutterBtn(),
                _camSideBtn(
                  _flashOn ? Icons.flash_on_rounded : Icons.flash_off_rounded,
                  _toggleFlash,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _camSideBtn(IconData icon, VoidCallback onTap) => GestureDetector(
    onTap: onTap,
    child: Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: Colors.white12,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white24),
      ),
      child: Icon(icon, color: Colors.white, size: 22),
    ),
  );

  Widget _shutterBtn() => GestureDetector(
    onTap: _capture,
    child: Container(
      width: 68,
      height: 68,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: _purple.withOpacity(0.6), width: 3.5),
      ),
      child: Container(
        margin: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: _purple,
          boxShadow: [
            BoxShadow(color: _purple.withOpacity(0.4), blurRadius: 16),
          ],
        ),
        child: _capturing
            ? const Padding(
                padding: EdgeInsets.all(16),
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : const Icon(
                Icons.document_scanner_rounded,
                color: Colors.white,
                size: 28,
              ),
      ),
    ),
  );

  Widget _buildAnalyzing() {
    return Container(
      color: const Color(0xFF0F1117),
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_imagePath != null)
              Container(
                width: 110,
                height: 145,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(color: _purple.withOpacity(0.3), blurRadius: 20),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.file(File(_imagePath!), fit: BoxFit.cover),
                ),
              ),
            const SizedBox(height: 28),
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: _purple.withOpacity(0.2), width: 3),
              ),
              child: const Padding(
                padding: EdgeInsets.all(4),
                child: CircularProgressIndicator(
                  color: _purple,
                  strokeWidth: 3,
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Reading label...",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              "AI is parsing nutritional values",
              style: TextStyle(fontSize: 12, color: Colors.white38),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                3,
                (i) => Container(
                  width: 8,
                  height: 8,
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: [_purple, _orange, _green][i],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResults() {
    final state = ref.watch(analyzeLabelProvider);
    return Stack(
      children: [
        if (_imagePath != null)
          Positioned.fill(
            child: ColorFiltered(
              colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.65),
                BlendMode.darken,
              ),
              child: Image.file(File(_imagePath!), fit: BoxFit.cover),
            ),
          ),
        SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 1),
            end: Offset.zero,
          ).animate(_sheetAnim),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              padding: EdgeInsets.fromLTRB(
                18,
                14,
                18,
                MediaQuery.of(context).padding.bottom + 16,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 36,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 14),
                  const Row(
                    children: [
                      Text(
                        "Label Scanned",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: Colors.black87,
                        ),
                      ),
                      Spacer(),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _macroBox("${state.calories}", "kcal", _orange),
                      const SizedBox(width: 8),
                      _macroBox("${state.protein}g", "Protein", _green),
                      const SizedBox(width: 8),
                      _macroBox(
                        "${state.carbs}g",
                        "Carbs",
                        const Color(0xFFF5A623),
                      ),
                      const SizedBox(width: 8),
                      _macroBox(
                        "${state.fat}g",
                        "Fat",
                        const Color(0xFFE05C5C),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        await ref
                            .read(dashboardProvider.notifier)
                            .addMealAndPersist(
                              calories: state.calories,
                              protein: state.protein,
                              carbs: state.carbs,
                              fat: state.fat,
                            );

                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text("Added successfully"),
                              backgroundColor: _green,
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          );
                          Navigator.pop(context);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _purple,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add_circle_outline_rounded, size: 20),
                          SizedBox(width: 8),
                          Text(
                            "Add to Dashboard",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: _retake,
                    child: const Text(
                      "Not accurate? Retake photo",
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _macroBox(String val, String lbl, Color color) => Expanded(
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Text(
            val,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w900,
              color: color,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            lbl,
            style: const TextStyle(
              fontSize: 9,
              color: Colors.grey,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    ),
  );
}

enum _ScanState { camera, analyzing, results }

class _FrameDimPainter extends CustomPainter {
  final Color color;
  const _FrameDimPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.black.withOpacity(0.55);
    final fL = size.width * 0.10;
    final fR = size.width * 0.90;
    final fT = size.height * 0.22;
    final fB = size.height * 0.72;
    final frame = RRect.fromLTRBR(fL, fT, fR, fB, const Radius.circular(8));

    canvas.drawPath(
      Path()
        ..addRect(Rect.fromLTWH(0, 0, size.width, size.height))
        ..addRRect(frame)
        ..fillType = PathFillType.evenOdd,
      paint,
    );

    final cp = Paint()
      ..color = color
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    const len = 22.0;
    canvas.drawLine(Offset(fL, fT + len), Offset(fL, fT), cp);
    canvas.drawLine(Offset(fL, fT), Offset(fL + len, fT), cp);
    canvas.drawLine(Offset(fR - len, fT), Offset(fR, fT), cp);
    canvas.drawLine(Offset(fR, fT), Offset(fR, fT + len), cp);
    canvas.drawLine(Offset(fL, fB - len), Offset(fL, fB), cp);
    canvas.drawLine(Offset(fL, fB), Offset(fL + len, fB), cp);
    canvas.drawLine(Offset(fR - len, fB), Offset(fR, fB), cp);
    canvas.drawLine(Offset(fR, fB), Offset(fR, fB - len), cp);
  }

  @override
  bool shouldRepaint(_) => false;
}
