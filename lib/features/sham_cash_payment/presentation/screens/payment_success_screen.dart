// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:restaurants_system/core/navigation/main_tabs.dart';
import 'package:restaurants_system/features/navigation/presentation/screens/main_screen.dart';
import 'package:restaurants_system/features/restaurant_menu/presentation/screens/restaurant_menu_screen.dart';

/// شاشة "تم استلام عملية الدفع بنجاح"
class PaymentSuccessScreen extends StatelessWidget {
  final int restaurantId;

  const PaymentSuccessScreen({super.key, required this.restaurantId});

  static const Color _primaryOrange = Color(0xFFFF6B35);
  static const Color _bgColor = Color(0xFFF5F5F5);
  static const Color _darkGreen = Color(0xFF1B7A4C);
  static const Color _textDark = Color(0xFF1F2333);
  static const Color _textMuted = Color(0xFF6B7280);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgColor,
      body: SafeArea(
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // ===== الشيك الأخضر مع الكونفيتي =====
                _SuccessCheckWithConfetti(),
                const SizedBox(height: 26),

                // ===== العنوان =====
                const Text(
                  "تم استلام عملية الدفع بنجاح",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: _darkGreen,
                  ),
                ),

                const SizedBox(height: 26),

                // ===== كارد "نتمنى لك وجبة شهية" =====
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF7EE),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Flexible(
                                  child: Text(
                                    "نتمنى لك",
                                    textAlign: TextAlign.right,
                                    style: TextStyle(
                                      fontSize: 16.5,
                                      fontWeight: FontWeight.w800,
                                      color: _primaryOrange,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              "وجبة شهية وصحة وهنا",
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                fontSize: 16.5,
                                fontWeight: FontWeight.w800,
                                color: _primaryOrange,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              "يسعدنا اختيارك لتطبيقنا، ونتمنى أن تستمتع بطلبك",
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                fontSize: 12.5,
                                height: 1.6,
                                color: _textMuted,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 12),
                      _FoodCoverIcon(),
                    ],
                  ),
                ),
                const SizedBox(height: 28),

                // ===== عنوان "ماذا يمكنك فعله الآن؟" =====
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 1,
                        color: _primaryOrange.withOpacity(0.35),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      width: 5,
                      height: 5,
                      decoration: const BoxDecoration(
                        color: _primaryOrange,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      "ماذا يمكنك فعله الآن؟",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: _textDark,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      width: 5,
                      height: 5,
                      decoration: const BoxDecoration(
                        color: _primaryOrange,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Container(
                        height: 1,
                        color: _primaryOrange.withOpacity(0.35),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),

                // ===== كارد: مراجعة حالة الطلب =====
                _ActionCard(
                  iconBgColor: const Color(0xFFDFF3E4),
                  chevronBgColor: const Color(0xFFDFF3E4),
                  chevronColor: _darkGreen,
                  icon: Icons.inventory_2_rounded,
                  iconColor: _darkGreen,
                  showBadge: true,
                  title: "مراجعة حالة الطلب",
                  titleColor: _darkGreen,
                  description: "يمكنك متابعة حالة طلبك من صفحة \"طلباتي\".",
                  onTap: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            const MainScreen(initialTab: MainTab.order),
                      ),
                      (route) => false,
                    );
                  },
                ),
                const SizedBox(height: 14),

                // ===== كارد: التواصل مع المطعم =====
                _ActionCard(
                  iconBgColor: const Color(0xFFFFE7DB),
                  chevronBgColor: const Color(0xFFFFE7DB),
                  chevronColor: _primaryOrange,
                  icon: Icons.call_rounded,
                  iconColor: _primaryOrange,
                  showBadge: false,
                  title: "التواصل مع المطعم",
                  titleColor: _darkGreen,
                  description:
                      "إذا احتجت إلى التواصل مع المطعم يمكنك الاتصال برقم الديليفري الموجود في صفحة المطعم.",
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            RestaurantMenuScreen(restaurantId: restaurantId),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 18),

                // ===== ملاحظة =====
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF8DE),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: const BoxDecoration(
                          color: Color(0xFFFCE98A),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.lightbulb_rounded,
                          color: Color(0xFFB8860B),
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "ملاحظة",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w800,
                                color: _textDark,
                              ),
                            ),
                            SizedBox(height: 6),
                            Text(
                              "قد تستغرق مراجعة عملية الدفع بضع دقائق",
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                fontSize: 13,
                                height: 1.5,
                                color: _textMuted,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 22),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// كارد الإجراء (مراجعة الطلب / التواصل مع المطعم)
class _ActionCard extends StatelessWidget {
  final Color iconBgColor;
  final Color chevronBgColor;
  final Color chevronColor;
  final IconData icon;
  final Color iconColor;
  final bool showBadge;
  final String title;
  final Color titleColor;
  final String description;
  final VoidCallback? onTap;

  const _ActionCard({
    required this.iconBgColor,
    required this.chevronBgColor,
    required this.chevronColor,
    required this.icon,
    required this.iconColor,
    required this.showBadge,
    required this.title,
    required this.titleColor,
    required this.description,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 14,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: chevronBgColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.chevron_left_rounded,
                  color: chevronColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      title,
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: titleColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      textAlign: TextAlign.right,
                      style: const TextStyle(
                        fontSize: 12.5,
                        height: 1.5,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: iconBgColor,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(icon, color: iconColor, size: 22),
                  ),
                  if (showBadge)
                    Positioned(
                      bottom: -2,
                      left: -2,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.check_circle_rounded,
                          color: Color(0xFF1B7A4C),
                          size: 14,
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// أيقونة غطاء الطبق
class _FoodCoverIcon extends StatelessWidget {
  const _FoodCoverIcon();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 76,
      height: 76,
      child: CustomPaint(painter: _FoodCoverPainter()),
    );
  }
}

class _FoodCoverPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint domePaint = Paint()..color = const Color(0xFFFF7A45);
    final Paint plateShadow = Paint()..color = const Color(0xFFFFD7BC);
    final Paint knobPaint = Paint()..color = const Color(0xFFC85A2E);
    final Paint heartPaint = Paint()..color = Colors.white;

    final double w = size.width;
    final double h = size.height;

    // ظل القاعدة
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(w / 2, h * 0.88),
        width: w * 0.75,
        height: h * 0.12,
      ),
      plateShadow,
    );

    // جسم الطبق (نصف دائرة)
    final Path dome = Path()
      ..moveTo(w * 0.12, h * 0.72)
      ..quadraticBezierTo(w * 0.5, h * -0.05, w * 0.88, h * 0.72)
      ..close();
    canvas.drawPath(dome, domePaint);

    // قاعدة الطبق
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.08, h * 0.70, w * 0.84, h * 0.10),
        const Radius.circular(4),
      ),
      Paint()..color = const Color(0xFFE8590C),
    );

    // المقبض
    canvas.drawCircle(Offset(w / 2, h * 0.18), w * 0.05, knobPaint);
    canvas.drawRect(Rect.fromLTWH(w / 2 - 2, h * 0.20, 4, h * 0.08), knobPaint);

    // قلب صغير في المنتصف
    final Path heart = Path();
    final double hx = w / 2;
    final double hy = h * 0.55;
    final double s = w * 0.09;
    heart.moveTo(hx, hy + s * 0.7);
    heart.cubicTo(
      hx - s * 1.4,
      hy - s * 0.4,
      hx - s * 0.4,
      hy - s * 1.3,
      hx,
      hy - s * 0.4,
    );
    heart.cubicTo(
      hx + s * 0.4,
      hy - s * 1.3,
      hx + s * 1.4,
      hy - s * 0.4,
      hx,
      hy + s * 0.7,
    );
    heart.close();
    canvas.drawPath(heart, heartPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// الشيك الأخضر مع نقاط الكونفيتي المتحركة حوله
class _SuccessCheckWithConfetti extends StatefulWidget {
  @override
  State<_SuccessCheckWithConfetti> createState() =>
      _SuccessCheckWithConfettiState();
}

class _SuccessCheckWithConfettiState extends State<_SuccessCheckWithConfetti>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      height: 170,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // نقاط الكونفيتي
          ..._buildConfettiDots(),
          // الدائرة الخضراء + العلامة
          ScaleTransition(
            scale: CurvedAnimation(
              parent: _controller,
              curve: Curves.elasticOut,
            ),
            child: Container(
              width: 118,
              height: 118,
              decoration: const BoxDecoration(
                color: Color(0xFFD9F2DD),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_rounded,
                color: Color(0xFF2E9E4F),
                size: 60,
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildConfettiDots() {
    final List<_ConfettiSpec> specs = [
      _ConfettiSpec(const Offset(28, 30), 8, const Color(0xFFFFB020), true),
      _ConfettiSpec(const Offset(58, 12), 6, const Color(0xFF2E9E4F), false),
      _ConfettiSpec(const Offset(20, 70), 6, const Color(0xFFFF6B35), false),
      _ConfettiSpec(const Offset(45, 95), 5, const Color(0xFF2E9E4F), false),
      _ConfettiSpec(const Offset(90, 20), 5, const Color(0xFFFFB020), true),
      _ConfettiSpec(const Offset(170, 35), 8, const Color(0xFFFFB020), true),
      _ConfettiSpec(const Offset(150, 15), 6, const Color(0xFF2E9E4F), false),
      _ConfettiSpec(const Offset(180, 75), 6, const Color(0xFFFF6B35), false),
      _ConfettiSpec(const Offset(155, 100), 5, const Color(0xFF2E9E4F), false),
      _ConfettiSpec(const Offset(110, 15), 5, const Color(0xFFFFB020), true),
    ];

    return specs
        .map(
          (s) => Positioned(
            left: s.offset.dx,
            top: s.offset.dy,
            child: FadeTransition(
              opacity: _controller,
              child: s.isStar
                  ? _StarDot(size: s.size, color: s.color)
                  : Container(
                      width: s.size,
                      height: s.size,
                      decoration: BoxDecoration(
                        color: s.color,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
            ),
          ),
        )
        .toList();
  }
}

class _ConfettiSpec {
  final Offset offset;
  final double size;
  final Color color;
  final bool isStar;
  _ConfettiSpec(this.offset, this.size, this.color, this.isStar);
}

class _StarDot extends StatelessWidget {
  final double size;
  final Color color;
  const _StarDot({required this.size, required this.color});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size * 1.6, size * 1.6),
      painter: _StarPainter(color: color),
    );
  }
}

class _StarPainter extends CustomPainter {
  final Color color;
  _StarPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()..color = color;
    final Path path = Path();
    final double w = size.width;
    final double h = size.height;
    // شكل نجمة بسيطة (4 أطراف - sparkle)
    path.moveTo(w / 2, 0);
    path.quadraticBezierTo(w / 2, h / 2, w, h / 2);
    path.quadraticBezierTo(w / 2, h / 2, w / 2, h);
    path.quadraticBezierTo(w / 2, h / 2, 0, h / 2);
    path.quadraticBezierTo(w / 2, h / 2, w / 2, 0);
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
