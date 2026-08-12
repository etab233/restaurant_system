import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurants_system/features/meal_details/data/models/meal_nutrition_model.dart';
import 'package:restaurants_system/features/meal_details/presentation/providers/meal_nutrition_notifier.dart';

class NutritionSection extends ConsumerStatefulWidget {
  final bool isNutritionallyAnalyzed;
  final int restaurantId;
  final int menuItemId;

  const NutritionSection({
    super.key,
    required this.isNutritionallyAnalyzed,
    required this.restaurantId,
    required this.menuItemId,
  });

  @override
  ConsumerState<NutritionSection> createState() => _NutritionSectionState();
}

class _NutritionSectionState extends ConsumerState<NutritionSection> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(nutritionProvider.notifier)
          .fetchNutrition(
            menuItemId: widget.menuItemId,
            restaurantId: widget.restaurantId,
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(nutritionProvider);

    if (!widget.isNutritionallyAnalyzed || state.errorMessage != null) {
      return SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
        ).copyWith(top: 25, bottom: 30),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 35),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: const BoxDecoration(
                  color: Color(0xFFF1F7EC),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.analytics_outlined,
                  size: 36,
                  color: Color(0xFF4A7A2E),
                ),
              ),
              const SizedBox(height: 18),
              const Text(
                "Nutrition analysis unavailable",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1A1A1A),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "This meal doesn't have a nutrition analysis yet.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  height: 1.5,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8F8F6),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.info_outline_rounded,
                      size: 17,
                      color: Colors.grey.shade600,
                    ),
                    const SizedBox(width: 7),
                    Text(
                      "Analysis will appear when available",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (state.isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Color(0xFFFF6B35)),
      );
    }

    final nutrition = state.nutrition;
    if (nutrition == null) return const SizedBox.shrink();

    // حساب النسبة المئوية لكل ماكرو من إجمالي سعرات الماكروز)
    // بروتين وكارب = 4 سعرة/غرام، دهون = 9 سعرة/غرام.
    final proteinKcal = nutrition.protein.value * 4;
    final carbsKcal = nutrition.carbs.value * 4;
    final fatKcal = nutrition.fat.value * 9;
    final totalMacroKcal = (proteinKcal + carbsKcal + fatKcal) == 0
        ? 1
        : proteinKcal + carbsKcal + fatKcal;
    final proteinPct = proteinKcal / totalMacroKcal * 100;
    final carbsPct = carbsKcal / totalMacroKcal * 100;
    final fatPct = fatKcal / totalMacroKcal * 100;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
      ).copyWith(top: 10, bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ===== بطاقة السعرات الرئيسية =====
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: const Color(0xFF4A7A2E),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.local_fire_department_rounded,
                  color: Colors.white,
                  size: 32,
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "TOTAL CALORIES",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white70,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      "${nutrition.energy.value.toInt()} ${nutrition.energy.unit}",
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Text(
                  "per ${nutrition.totalGrams.toInt()}g",
                  style: const TextStyle(fontSize: 13, color: Colors.white70),
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),

          // ===== حلقة توزيع الماكروز =====
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 76,
                  height: 76,
                  child: CustomPaint(
                    painter: _MacroDonutPainter(
                      proteinPct: proteinPct,
                      carbsPct: carbsPct,
                      fatPct: fatPct,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    children: [
                      _macroLegendRow(
                        label: "Protein",
                        value: nutrition.protein,
                        color: const Color(0xFF4A7A2E),
                      ),
                      const SizedBox(height: 8),
                      _macroLegendRow(
                        label: "Carbs",
                        value: nutrition.carbs,
                        color: const Color(0xFFF5A623),
                      ),
                      const SizedBox(height: 8),
                      _macroLegendRow(
                        label: "Fat",
                        value: nutrition.fat,
                        color: const Color(0xFFE05C5C),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 18),

          Padding(
            padding: const EdgeInsets.only(right: 2, bottom: 8),
            child: Text(
              "Details",
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: Colors.grey.shade600,
              ),
            ),
          ),

          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade200),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Column(
              children: [
                _nutrientRow(
                  icon: Icons.grass_rounded,
                  label: "Fiber",
                  value: nutrition.fiber,
                  showDivider: true,
                ),
                _nutrientRow(
                  icon: Icons.cookie_outlined,
                  label: "Sugars",
                  value: nutrition.sugars,
                  showDivider: true,
                ),
                _nutrientRow(
                  icon: Icons.water_drop_outlined,
                  label: "Sodium",
                  value: nutrition.sodium,
                  showDivider: false,
                ),
              ],
            ),
          ),

          const SizedBox(height: 18),

          Padding(
            padding: const EdgeInsets.only(right: 2, bottom: 8),
            child: Text(
              "Vitamins and minerals",
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: Colors.grey.shade600,
              ),
            ),
          ),

          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 2.1,
            children: [
              _microCard(
                icon: Icons.bolt_rounded,
                label: "Potassium",
                value: nutrition.potassium,
              ),
              _microCard(
                icon: Icons.fitness_center_rounded,
                label: "Calcium",
                value: nutrition.calcium,
              ),
              _microCard(
                icon: Icons.favorite_border_rounded,
                label: "Iron",
                value: nutrition.iron,
              ),
              _microCard(
                icon: Icons.local_florist_outlined,
                label: "Vitamin C",
                value: nutrition.vitaminC,
              ),
              _microCard(
                icon: Icons.visibility_outlined,
                label: "Vitamin A",
                value: nutrition.vitaminA,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _macroLegendRow({
    required String label,
    required NutritionValue value,
    required Color color,
  }) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(fontSize: 13, color: Color(0xFF1A1A1A)),
          ),
        ),
        Text(
          "${value.value.toInt()}${value.unit}",
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1A1A1A),
          ),
        ),
      ],
    );
  }

  Widget _nutrientRow({
    required IconData icon,
    required String label,
    required NutritionValue value,
    required bool showDivider,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: showDivider
          ? BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.grey.shade100),
              ),
            )
          : null,
      child: Row(
        children: [
          Icon(icon, size: 17, color: Colors.grey.shade500),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontSize: 14, color: Color(0xFF1A1A1A)),
            ),
          ),
          Text(
            "${value.value.toStringAsFixed(1)} ${value.unit}",
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1A1A1A),
            ),
          ),
        ],
      ),
    );
  }

  Widget _microCard({
    required IconData icon,
    required String label,
    required NutritionValue value,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Icon(icon, size: 15, color: Colors.grey.shade500),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  label,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            "${value.value.toStringAsFixed(1)} ${value.unit}",
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: Color(0xFF1A1A1A),
            ),
          ),
        ],
      ),
    );
  }
}

// ===================================================================
// Painter: حلقة Donut توري توزيع الماكروز (بروتين / كارب / دهون)
// كنسبة من إجمالي سعرات الماكروز
// ===================================================================
class _MacroDonutPainter extends CustomPainter {
  final double proteinPct;
  final double carbsPct;
  final double fatPct;

  _MacroDonutPainter({
    required this.proteinPct,
    required this.carbsPct,
    required this.fatPct,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 6;
    const strokeWidth = 10.0;
    final rect = Rect.fromCircle(center: center, radius: radius);

    final track = Paint()
      ..color = Colors.grey.shade200
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    canvas.drawCircle(center, radius, track);

    double start = -math.pi / 2;
    void drawArc(double pct, Color color) {
      if (pct <= 0) return;
      final sweep = 2 * math.pi * (pct / 100);
      final paint = Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;
      canvas.drawArc(rect, start, sweep, false, paint);
      start += sweep;
    }

    drawArc(proteinPct, const Color(0xFF4A7A2E));
    drawArc(carbsPct, const Color(0xFFF5A623));
    drawArc(fatPct, const Color(0xFFE05C5C));
  }

  @override
  bool shouldRepaint(covariant _MacroDonutPainter oldDelegate) {
    return oldDelegate.proteinPct != proteinPct ||
        oldDelegate.carbsPct != carbsPct ||
        oldDelegate.fatPct != fatPct;
  }
}
