// ignore_for_file: depend_on_referenced_packages, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:restaurants_system/core/navigation/main_tabs.dart';
import 'package:restaurants_system/features/auth/presentation/providers/auth_provider.dart';
import 'package:restaurants_system/features/calorie_dashboard/presentation/screens/utils/calorie_targets.dart';
import 'package:restaurants_system/features/health_profile/presentation/providers/health_profile_notifier.dart';
import 'package:restaurants_system/features/label_analysis/presentation/screens/scan_label_screen.dart';
import 'package:restaurants_system/features/meal_analysis/presentation/screens/add_meal_pic_screen.dart';
import 'package:restaurants_system/features/navigation/presentation/screens/main_screen.dart';
import '../../data/models/dashboard_model.dart';
import '../providers/dashboard_notifier.dart';

const _green = Color(0xFF4A7A2E);
const _orange = Color(0xFFFF6B35);
const _bg = Color(0xFFF5F5F0);

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider);
    final healthState = ref.watch(healthProfileProvider);
    final dash = ref.watch(dashboardProvider);

    final userName = authState.userData?['name'] ?? "here";
    final targets = CalorieTargets.fromHealthProfile(healthState);

    final left = (targets.dailyCalorieNeeds - dash.calories).clamp(
      0.0,
      targets.dailyCalorieNeeds,
    );
    final prog = targets.dailyCalorieNeeds > 0
        ? (dash.calories / targets.dailyCalorieNeeds).clamp(0.0, 1.0)
        : 0.0;

    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildAppBar(context),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildGreeting(userName),
                    const SizedBox(height: 16),
                    _buildHeroCard(dash, left, prog, targets),
                    const SizedBox(height: 14),
                    _buildStatsRow(dash, left, targets),
                    const SizedBox(height: 14),
                    _buildMacrosCard(dash, targets),
                    const SizedBox(height: 14),
                    _buildScanCard(
                      img: "assets/images/pizza.png",
                      title: "Scan your meal",
                      description:
                          "Snap your meal and get instant\ncalorie & macro analysis",
                      accentColor: const Color(0xFF8FBD5A),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const AddMealPicScreen(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 14),
                    _buildScanCard(
                      img: "assets/images/nutrition_table.jpg",
                      title: "Read Nutrition table",
                      description:
                          "AI reads nutrition facts and\ntracks macros automatically",
                      accentColor: const Color(0xFF9B7FD4),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ScanLabelScreen(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 14),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          InkWell(
            child: const Icon(
              Icons.arrow_back,
              size: 26,
              color: Colors.black87,
            ),
            onTap: () => Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (_) => const MainScreen(initialTab: MainTab.home),
              ),
              (route) => false,
            ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.calendar_today_outlined,
                  size: 15,
                  color: Colors.black54,
                ),
                const SizedBox(width: 6),
                Text(
                  DateFormat('EEE, MMM dd').format(DateTime.now()),
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  size: 18,
                  color: Colors.black54,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGreeting(String userName) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              "Hey $userName! ",
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: Colors.black87,
              ),
            ),
            const Icon(
              Icons.waving_hand_rounded,
              size: 22,
              color: Color(0xFFF1C27D),
            ),
          ],
        ),
        const Text(
          "Here's your nutrition overview",
          style: TextStyle(fontSize: 13, color: Colors.black87),
        ),
      ],
    );
  }

  Widget _buildHeroCard(
    DashboardModel dash,
    double left,
    double prog,
    CalorieTargets targets,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF3D6B24), Color(0xFF6AA84F)],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4A7A2E).withOpacity(0.35),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          const Positioned(
            top: -10,
            right: -10,
            child: Opacity(
              opacity: 0.25,
              child: Icon(Icons.eco_rounded, size: 80, color: Colors.white),
            ),
          ),
          const Positioned(
            top: 30,
            right: 30,
            child: Opacity(
              opacity: 0.15,
              child: Icon(Icons.eco_rounded, size: 50, color: Colors.white),
            ),
          ),
          Column(
            children: [
              Row(
                children: [
                  SizedBox(
                    width: 120,
                    height: 120,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        TweenAnimationBuilder<double>(
                          tween: Tween(begin: 0, end: prog),
                          duration: const Duration(milliseconds: 1400),
                          curve: Curves.easeOut,
                          builder: (_, val, __) => CircularProgressIndicator(
                            value: val,
                            strokeWidth: 10,
                            strokeAlign: 7.2,
                            backgroundColor: Colors.white24,
                            valueColor: AlwaysStoppedAnimation(
                              Color.lerp(
                                const Color(0xFFFFBE0B),
                                _orange,
                                val,
                              )!,
                            ),
                            strokeCap: StrokeCap.round,
                          ),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              "Calories",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              dash.calories.toStringAsFixed(0),
                              style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              "/ ${targets.dailyCalorieNeeds.toInt()} kcal",
                              style: const TextStyle(
                                fontSize: 13,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 18),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "You're doing great! ",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "${left.toStringAsFixed(0)} kcal left to reach your goal",
                          style: const TextStyle(
                            fontSize: 11,
                            color: Colors.white70,
                          ),
                        ),
                        const SizedBox(height: 12),
                        TweenAnimationBuilder<double>(
                          tween: Tween(begin: 0, end: prog),
                          duration: const Duration(milliseconds: 1400),
                          curve: Curves.easeOut,
                          builder: (_, val, __) => ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: LinearProgressIndicator(
                              value: val,
                              minHeight: 10,
                              backgroundColor: Colors.white24,
                              valueColor: AlwaysStoppedAnimation(
                                Color.lerp(
                                  const Color(0xFFFFBE0B),
                                  _orange,
                                  val,
                                )!,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            "${(prog * 100).toStringAsFixed(0)}%",
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Divider(color: Colors.white24, height: 1),
              const SizedBox(height: 14),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _heroStat(
                    Icons.track_changes_rounded,
                    "Goal",
                    "${targets.dailyCalorieNeeds.toInt()} kcal",
                  ),
                  Container(width: 1, height: 36, color: Colors.white24),
                  _heroStat(
                    Icons.local_fire_department_rounded,
                    "Left",
                    "${left.toStringAsFixed(0)} kcal",
                    color: _orange,
                  ),
                  Container(width: 1, height: 36, color: Colors.white24),
                  _heroStat(
                    Icons.trending_up_rounded,
                    "Progress",
                    "${(prog * 100).toStringAsFixed(0)}%",
                    color: const Color(0xFFFFBE0B),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _heroStat(
    IconData icon,
    String label,
    String value, {
    Color color = Colors.white,
  }) {
    return Column(
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(fontSize: 11, color: color.withOpacity(0.8)),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w800,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildStatsRow(
    DashboardModel dash,
    double left,
    CalorieTargets targets,
  ) {
    return Row(
      children: [
        _statCard(
          Icons.local_fire_department_rounded,
          _orange,
          left.toStringAsFixed(0),
          "Left kcal",
          _orange,
          const Color(0xFFFFF0EB),
        ),
        const SizedBox(width: 8),
        _statCard(
          Icons.fitness_center_outlined,
          _green,
          "${dash.protein.toStringAsFixed(0)}g",
          "Protein",
          _green,
          const Color(0xFFE8F5E9),
        ),
        const SizedBox(width: 8),
        _statCard(
          Icons.monitor_weight_rounded,
          const Color(0xFF9B5DE5),
          "${targets.weightKg?.toStringAsFixed(0) ?? '--'}kg",
          "Weight",
          const Color(0xFF9B5DE5),
          const Color(0xFFF3E5F5),
        ),
      ],
    );
  }

  Widget _statCard(
    IconData icon,
    Color iconColor,
    String val,
    String label,
    Color valColor,
    Color bg,
  ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: bg,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(child: Icon(icon, color: iconColor, size: 22)),
            ),
            const SizedBox(height: 7),
            Text(
              val,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: valColor,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMacrosCard(DashboardModel dash, CalorieTargets targets) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          const Row(
            children: [
              Text(
                "Macronutrients",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),
              Spacer(),
              Text(
                "View details",
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              Icon(Icons.chevron_right, size: 16, color: Colors.grey),
            ],
          ),
          const SizedBox(height: 16),
          _macroRow(
            icon: Icons.egg,
            bg: const Color(0xFFE8F5E9),
            label: "Protein",
            current: dash.protein,
            max: targets.protein,
            color: _green,
          ),
          const Divider(height: 20, color: Color(0xFFF5F5F5)),
          _macroRow(
            icon: Icons.breakfast_dining,
            bg: const Color(0xFFFFFDE7),
            label: "Carbs",
            current: dash.carbs,
            max: targets.carbs,
            color: const Color(0xFFF5A623),
          ),
          const Divider(height: 20, color: Color(0xFFF5F5F5)),
          _macroRow(
            icon: Icons.water_drop,
            bg: const Color(0xFFFCE4EC),
            label: "Fat",
            current: dash.fat,
            max: targets.fat,
            color: const Color(0xFFE05C5C),
          ),
        ],
      ),
    );
  }

  Widget _macroRow({
    required IconData icon,
    required Color bg,
    required String label,
    required double current,
    required double max,
    required Color color,
  }) {
    final pct = max > 0 ? (current / max).clamp(0.0, 1.0) : 0.0;
    final pctP = (pct * 100).toStringAsFixed(0);

    return Row(
      children: [
        Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
          child: Center(child: Icon(icon, size: 24, color: color)),
        ),
        const SizedBox(width: 12),
        SizedBox(
          width: 70,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),
              Text(
                "${current.toStringAsFixed(0)}g / ${max.toStringAsFixed(0)}g",
                style: TextStyle(fontSize: 10, color: Colors.grey.shade500),
              ),
            ],
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: pct),
            duration: const Duration(milliseconds: 1200),
            curve: Curves.easeOut,
            builder: (_, val, __) => ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: val,
                minHeight: 10,
                backgroundColor: Colors.grey.shade100,
                valueColor: AlwaysStoppedAnimation(color),
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          "$pctP%",
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildScanCard({
    required String img,
    required String title,
    required String description,
    required Color accentColor,
    required VoidCallback onPressed,
  }) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: const AssetImage("assets/images/leaves.jpg"),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Colors.grey.withOpacity(0.4),
            BlendMode.darken,
          ),
        ),
        color: const Color(0xFF1A1A2E),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              CircleAvatar(radius: 45, backgroundImage: AssetImage(img)),
              Positioned(top: 0, left: 0, child: _corner()),
              Positioned(top: 0, right: 0, child: _corner(isRight: true)),
              Positioned(bottom: 0, left: 0, child: _corner(isBottom: true)),
              Positioned(
                bottom: 0,
                right: 0,
                child: _corner(isRight: true, isBottom: true),
              ),
            ],
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                description,
                style: const TextStyle(
                  fontSize: 11,
                  color: Colors.black87,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFFB7C58D), Color(0xFF8FA86B)],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF8FA86B).withOpacity(0.35),
                      blurRadius: 14,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: onPressed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 13,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.18),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.camera_alt_rounded,
                          size: 16,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        "Take Photo",
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.2,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Icon(Icons.arrow_forward_rounded, size: 18),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _corner({bool isRight = false, bool isBottom = false}) {
    return Container(
      width: 18,
      height: 18,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(3),
        border: Border(
          top: isBottom
              ? BorderSide.none
              : const BorderSide(color: Colors.white, width: 2),
          left: isRight
              ? BorderSide.none
              : const BorderSide(color: Colors.white, width: 2),
          right: isRight
              ? const BorderSide(color: Colors.white, width: 2)
              : BorderSide.none,
          bottom: isBottom
              ? const BorderSide(color: Colors.white, width: 2)
              : BorderSide.none,
        ),
      ),
    );
  }
}
