// view/calorie_tracker/dashboard.dart
// ignore_for_file: depend_on_referenced_packages, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:restaurants_system/models/dashboard_model.dart';
import 'package:restaurants_system/providers/auth_provider.dart';
import 'package:restaurants_system/providers/dashboard_provider.dart';
import 'package:restaurants_system/utils/calorie_logic.dart';
import 'package:restaurants_system/view/calorie_tracker/scan_meal/add_meal_pic.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Dashboard extends ConsumerStatefulWidget {
  const Dashboard({super.key});
  @override
  ConsumerState<Dashboard> createState() => DashboardState();
}

class DashboardState extends ConsumerState<Dashboard> {
  // ── Colors ──────────────────────────────────────────
  static const _green = Color(0xFF4A7A2E);
  static const _orange = Color(0xFFFF6B35);
  static const _bg = Color(0xFFF5F5F0);

  // ── User data ────────────────────────────────────────
  int? age;
  double? h;
  double? w;
  String? gender, goal, activityLevel, userName;
  double dailyCalorieNeeds = 0;
  double protein = 0, carbs = 0, fat = 0;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    final prefs = await SharedPreferences.getInstance();
    final birth = prefs.getString("birthday");
    if (birth != null) {
      final p = birth.split('-');
      age = calculateAge(
        DateTime(int.parse(p[0]), int.parse(p[1]), int.parse(p[2])),
      );
    }
    h = prefs.getDouble("height");
    w = prefs.getDouble("weight");
    gender = prefs.getString("gender");
    goal = prefs.getString("goal");
    activityLevel = prefs.getString("activity_level");

    if (age != null &&
        gender != null &&
        h != null &&
        w != null &&
        activityLevel != null &&
        goal != null) {
      final bmr = calculateBMR(age: age!, gender: gender!, h: h!, w: w!);
      final tdee = determineTDEE(activityLevel: activityLevel!, bmr: bmr);
      dailyCalorieNeeds = calculatingDailyCalorieNeeds(goal: goal!, tdee: tdee);
      fat = calculateDailyFat(weightKg: w!);
      protein = calculateDailyProtein(weightKg: w!, goal: goal!);
      carbs = calculateDailyCarbs(
        calories: dailyCalorieNeeds,
        proteinGrams: protein,
        fatGrams: fat,
      );
    }
    setState(() {});
  }

  // ════════════════════════════════════════════════════
  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    userName = authState.userData?['name'] ?? "here";

    if (age == null) {
      return const Scaffold(
        backgroundColor: _bg,
        body: Center(child: CircularProgressIndicator(color: _green)),
      );
    }

    final dash = ref.watch(dashboardProvider);
    final left = (dailyCalorieNeeds - dash.calories).clamp(
      0.0,
      dailyCalorieNeeds,
    );
    final prog = dailyCalorieNeeds > 0
        ? (dash.calories / dailyCalorieNeeds).clamp(0.0, 1.0)
        : 0.0;

    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildAppBar(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildGreeting(),
                    const SizedBox(height: 16),
                    _buildHeroCard(dash, left, prog),
                    const SizedBox(height: 14),
                    _buildStatsRow(dash, left),
                    const SizedBox(height: 14),
                    _buildMacrosCard(dash),
                    const SizedBox(height: 14),
                    _buildScanCard(),
                    const SizedBox(height: 14),
                    _buildQuickActions(),
                    const SizedBox(height: 90),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── AppBar ───────────────────────────────────────────
  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          InkWell(
            child: Icon(Icons.arrow_back, size: 26, color: Colors.black87),
            onTap: () => Navigator.pop(context),
          ),
          const Spacer(),
          // Date selector
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

  // ── Greeting ─────────────────────────────────────────
  Widget _buildGreeting() {
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
          style: TextStyle(fontSize: 13, color: Colors.grey),
        ),
      ],
    );
  }

  // ── Hero Card ─────────────────────────────────────────
  Widget _buildHeroCard(DashboardModel dash, double left, double prog) {
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
          // Decorative leaves
          Positioned(
            top: -10,
            right: -10,
            child: Opacity(
              opacity: 0.25,
              child: Icon(Icons.eco_rounded, size: 80, color: Colors.white),
            ),
          ),
          Positioned(
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
                  // Calorie Ring
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
                            strokeAlign: 6,
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
                                fontSize: 11,
                                color: Colors.white70,
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
                              "/ ${dailyCalorieNeeds.toInt()} kcal",
                              style: const TextStyle(
                                fontSize: 10,
                                color: Colors.white60,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 18),

                  // Right side
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
                        // Progress bar
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

              // Goal / Left / Progress row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _heroStat(
                    Icons.track_changes_rounded,
                    "Goal",
                    "${dailyCalorieNeeds.toInt()} kcal",
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

  // ── Stats Row ─────────────────────────────────────────
  Widget _buildStatsRow(DashboardModel dash, double left) {
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
          "${w?.toStringAsFixed(0)}kg",
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

  // ── Macros Card ───────────────────────────────────────
  Widget _buildMacrosCard(DashboardModel dash) {
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
          Row(
            children: [
              const Text(
                "Macronutrients",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),
              const Spacer(),
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
            max: protein,
            color: _green,
          ),
          const Divider(height: 20, color: Color(0xFFF5F5F5)),
          _macroRow(
            icon: Icons.breakfast_dining,
            bg: const Color(0xFFFFFDE7),
            label: "Carbs",
            current: dash.carbs,
            max: carbs,
            color: const Color(0xFFF5A623),
          ),
          const Divider(height: 20, color: Color(0xFFF5F5F5)),
          _macroRow(
            icon: Icons.water_drop,
            bg: const Color(0xFFFCE4EC),
            label: "Fat",
            current: dash.fat,
            max: fat,
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
        // Icon
        Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
          child: Center(child: Icon(icon, size: 24, color: color)),
        ),
        const SizedBox(width: 12),
        // Label + values
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
        // Bar
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

  // ── Scan Card ─────────────────────────────────────────
  Widget _buildScanCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A2E),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // Plate image/illustration
          Stack(
            alignment: Alignment.center,
            children: [
              // الصحن
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [_green.withOpacity(0.5), _orange.withOpacity(0.3)],
                  ),
                  border: Border.all(color: Colors.white24, width: 2),
                ),
                child: const Center(
                  child: Text("🍽️", style: TextStyle(fontSize: 40)),
                ),
              ),

              // الزوايا الأربع
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
              const Text(
                "Scan your meal",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                "AI detects calories & nutrients\nfrom your photo instantly",
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.white54,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_)=> AddMealPic()));
                },
                icon: const Icon(Icons.camera_alt_rounded, size: 18),
                label: const Text(
                  "Take Photo",
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _orange,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 11,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 0,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ___ corner __________________________________________
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

  // ── Quick Actions ─────────────────────────────────────
  Widget _buildQuickActions() {
    final actions = [
      _QuickAction(
        Icons.qr_code_scanner_rounded,
        "Scan Label",
        "Nutrition facts",
        const Color(0xFFE8F5E9),
        _green,
      ),
      _QuickAction(
        Icons.search_rounded,
        "Search Food",
        "Find by name",
        const Color(0xFFFFF3E0),
        const Color(0xFFF5A623),
      ),
      _QuickAction(
        Icons.restaurant_menu_rounded,
        "From Menu",
        "Restaurant meal",
        const Color(0xFFFFF0EB),
        _orange,
      ),
      _QuickAction(
        Icons.favorite_rounded,
        "Favorites",
        "Your foods",
        const Color(0xFFF3E5F5),
        const Color(0xFF9B5DE5),
      ),
    ];

    return Column(
      children: actions
          .map(
            (a) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: GestureDetector(
                onTap: () {}, // TODO
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: a.bg,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(a.icon, color: a.color, size: 22),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              a.label,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: Colors.black87,
                              ),
                            ),
                            Text(
                              a.sub,
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey.shade500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.chevron_right_rounded,
                        color: Colors.grey.shade300,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
          .toList(),
    );
  }

}
// ── Helper class ──────────────────────────────────────────
class _QuickAction {
  final IconData icon;
  final String label, sub;
  final Color bg, color;
  const _QuickAction(this.icon, this.label, this.sub, this.bg, this.color);
}
