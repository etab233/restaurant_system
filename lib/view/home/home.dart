// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurants_system/notifier/home_notifier.dart';
import 'package:restaurants_system/providers/auth_provider.dart';
import 'package:restaurants_system/providers/home_provider.dart';
import 'package:restaurants_system/providers/restaurant_request_provider.dart';
import 'package:restaurants_system/providers/search_provider.dart';
import 'package:restaurants_system/view/bottom_navbar.dart';
import 'package:restaurants_system/view/calorie_tracker/error_screen.dart'
    show ErrorScreen;
import 'package:restaurants_system/view/calorie_tracker/welcome.dart';
import 'package:restaurants_system/view/categories/categories_grid.dart';
import 'package:restaurants_system/view/home/bubble_widget.dart';
import 'package:restaurants_system/view/login-register/login.dart';
import 'package:restaurants_system/view/login-register/register.dart';
import 'package:restaurants_system/view/restaurant-request/lock_screen.dart';
import 'package:restaurants_system/view/restaurant-request/restaurant_request.dart';
import 'package:restaurants_system/view/categories/category_card.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:restaurants_system/view/restaurant_card.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:restaurants_system/view/home/customer_location.dart';

class Home extends ConsumerStatefulWidget {
  final ThemeMode? themeMode;
  final VoidCallback? toggleTheme;

  const Home({super.key, this.themeMode, this.toggleTheme});

  @override
  ConsumerState<Home> createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> with TickerProviderStateMixin {
  final _searchController = TextEditingController();
  Timer? _debounce;
  String userLocation = "Home";

  // bubble controller
  late AnimationController _bubble1Ctrl;
  late AnimationController _bubble2Ctrl;
  late AnimationController _bubble3Ctrl;

  Animation<double>? _bubble1Anim;
  Animation<double>? _bubble2Anim;
  Animation<double>? _bubble3Anim;

  @override
  void initState() {
    super.initState();
    _initBubbles();
    Future.microtask(() async {
      await initAuth(ref);
      ref.read(homeProvider.notifier).getHomeData();
    });
  }

  void _initBubbles() {
    _bubble1Ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2100),
    )..repeat(reverse: true);

    _bubble2Ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat(reverse: true);

    _bubble3Ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);

    _bubble1Anim = Tween(begin: 0.0, end: -20.0).animate(
      CurvedAnimation(parent: _bubble1Ctrl, curve: Curves.easeInOutCubic),
    );

    _bubble2Anim = Tween(begin: 0.0, end: -10.0).animate(
      CurvedAnimation(parent: _bubble2Ctrl, curve: Curves.easeInOutCubic),
    );

    _bubble3Anim = Tween(begin: 0.0, end: -15.0).animate(
      CurvedAnimation(parent: _bubble3Ctrl, curve: Curves.easeInOutCubic),
    );
  }

  Future<void> initAuth(WidgetRef ref) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token != null) {
      ref.read(authProvider.notifier).restoreSession(token);
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    _bubble1Ctrl.dispose();
    _bubble2Ctrl.dispose();
    _bubble3Ctrl.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      ref.read(searchProvider.notifier).search(query: value);
    });
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final homeState = ref.watch(homeProvider);
    final resState = ref.watch(restaurantRequestProvider.notifier);
    final skeletonHomeState = SkeletonHomeState();

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      drawer: _buildDrawer(authState),
      bottomNavigationBar: const BottomNavBar(),

      body: Column(
        children: [
          _buildAppBar(resState),

          const SizedBox(height: 30),
          Expanded(
            child: switch (homeState.status) {
              'loading' => Skeletonizer(
                enabled: true,
                child: _HomeBody(
                  searchController: _searchController,
                  onSearchChanged: _onSearchChanged,
                  homeState: skeletonHomeState,
                  userLocation: userLocation,
                ),
              ),
              'false' => _ErrorState(
                onRetry: () => ref.read(homeProvider.notifier).getHomeData(),
              ),
              _ => _HomeBody(
                searchController: _searchController,
                onSearchChanged: _onSearchChanged,
                homeState: homeState,
                userLocation: userLocation,
              ),
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(resState) {
    final colors = Theme.of(context).colorScheme;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          height: 130,
          width: double.infinity,
          decoration: BoxDecoration(
            color: colors.primary,
            borderRadius: const BorderRadius.vertical(
              bottom: Radius.circular(25),
            ),
            boxShadow: [
              BoxShadow(
                color: colors.primary.withOpacity(0.4),
                blurRadius: 25,
                spreadRadius: 2,
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 40),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              //Drawer
              Builder(
                builder: (ctx) => IconButton(
                  onPressed: () => Scaffold.of(ctx).openDrawer(),
                  icon: const Icon(Icons.menu, size: 30, color: Colors.white),
                ),
              ),

              const SizedBox(width: 10),
              // Location
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Deliver to",
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  InkWell(
                    onTap: () async {
                      final location = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CustomerLocation(),
                        ),
                      );

                      if (location != null) {
                        final lat = location["lat"];
                        final lng = location["lng"];
                        final address = location["address"];

                        setState(() {
                          String locationString = address.toString();
                          List<String> parts = locationString
                              .split(',')
                              .map((e) => e.trim())
                              .toList();

                          userLocation = parts.first;
                        });

                        ref
                            .read(homeProvider.notifier)
                            .getHomeData(
                              lat: lat.toString(),
                              lng: lng.toString(),
                            );
                      }
                    },
                    child: Row(
                      children: [
                        Icon(Icons.location_on, color: Colors.white, size: 18),
                        SizedBox(width: 4),
                        Text(
                          userLocation == "Home" ? "Home" : userLocation,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Spacer(),
              // Notification
              Icon(Icons.notifications_none, size: 30, color: Colors.white),
            ],
          ),
        ),

        // bubbles
        if (_bubble1Anim != null)
          FloatingBubble(
            animation: _bubble1Anim!,
            size: 80,
            color: const Color.fromARGB(255, 245, 242, 241).withOpacity(0.18),
            top: 0,
            left: 150,
          ),

        // bubbles
        if (_bubble2Anim != null)
          FloatingBubble(
            animation: _bubble2Anim!,
            size: 55,
            color: const Color.fromARGB(255, 245, 242, 241).withOpacity(0.18),
            top: 20,
            left: 270,
          ),

        // bubbles
        if (_bubble3Anim != null)
          FloatingBubble(
            animation: _bubble3Anim!,
            size: 70,
            color: const Color.fromARGB(255, 245, 242, 241).withOpacity(0.18),
            top: -15,
            left: 15,
          ),

        // Search bar (floating)
        Positioned(
          bottom: -25,
          left: 16,
          right: 16,
          child: Container(
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search for restaurants",
                border: InputBorder.none,
                prefixIcon: Icon(Icons.search, color: colors.onSurface),
                contentPadding: EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget drawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    final colors = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: colors.shadow.withOpacity(0.08),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Icon(icon, color: colors.primary),
              const SizedBox(width: 12),
              Text(
                title,
                style: TextStyle(
                  color: colors.onSurface,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Drawer ──────────────────────────────────────────────
  Widget _buildDrawer(authState) {
    final colors = Theme.of(context).colorScheme;
    return TweenAnimationBuilder(
      tween: Tween(begin: 0.7, end: 1.0),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset((1 - value) * -200, 0),
          child: Opacity(opacity: value, child: child),
        );
      },
      child: Drawer(
        elevation: 10,
        width: MediaQuery.of(context).size.width * 0.75,
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Container(
                width: double.infinity,
                height: 135,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [colors.primary, colors.primary.withOpacity(0.8)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(25),
                  ),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 23,
                      backgroundColor: Colors.white,
                      child: Icon(Icons.person, color: colors.primary),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        authState.userData == null
                            ? "Welcome Guest"
                            : "Welcome ${authState.userData?['name']}",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              drawerItem(icon: Icons.settings, title: "Settings", onTap: () {}),

              drawerItem(
                icon: Icons.restaurant,
                title: "Restaurant request",
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        authState.userData != null ? RestaurantRequest() : LockScreen(),
                  ),
                ),
              ),

              drawerItem(
                icon: Icons.delivery_dining,
                title: "Delivery request",
                onTap: () {},
              ),
              //  Theme toggle
              drawerItem(
                icon: widget.themeMode == ThemeMode.light
                    ? Icons.dark_mode
                    : Icons.light_mode,
                title: widget.themeMode == ThemeMode.light
                    ? "Dark mode"
                    : "Light mode",
                onTap: () {
                  widget.toggleTheme?.call();
                  Navigator.pop(context);
                },
              ),
              drawerItem(
                icon: Icons.insights_outlined,
                title: "Calorie tracker",
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => authState.userData == null ? ErrorScreen() : Welcome(),
                  ),
                ),
              ),
              Spacer(),

              if (authState.userData == null)
                Padding(
                  padding: EdgeInsetsGeometry.symmetric(
                    vertical: 10,
                    horizontal: 20,
                  ),
                  child: SizedBox(
                    height: 50,
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colors.primary,
                        foregroundColor: colors.onPrimary,
                      ),
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => Login(redirectTo: "home"),
                        ),
                      ),
                      child: Text(
                        "Log in",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),

              if (authState.userData == null)
                Padding(
                  padding: EdgeInsetsGeometry.only(
                    bottom: 20,
                    right: 20,
                    left: 20,
                  ),
                  child: SizedBox(
                    height: 50,
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 10,
                        foregroundColor: colors.primary,
                        backgroundColor: Colors.black,
                      ),
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => Register()),
                      ),
                      child: Text(
                        "Sing Up",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
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

// ── Body ─────────────────────────────────────────────────────
class _HomeBody extends StatelessWidget {
  final TextEditingController searchController;
  final ValueChanged<String> onSearchChanged;
  final dynamic homeState;
  final String userLocation;

  const _HomeBody({
    required this.searchController,
    required this.onSearchChanged,
    required this.homeState,
    required this.userLocation,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _CategoriesSection(homeState: homeState),

            const SizedBox(height: 20),
            Text(
              userLocation != "Home"
                  ? "Restaurants Near You:"
                  : "Top Rated Restaurants:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            ListView.builder(
              shrinkWrap: true,
              physics:
                  const NeverScrollableScrollPhysics(), // لأنو داخل SingleChildScrollView
              itemCount: homeState.restaurants.length,
              itemBuilder: (context, index) {
                return RestaurantCard(
                  restaurant: homeState.restaurants[index],
                  onTap: () {
                    // لاحقاً: انتقل لصفحة تفاصيل المطعم
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

// ── Categories Section ───────────────────────────────────────
class _CategoriesSection extends StatelessWidget {
  final dynamic homeState;

  const _CategoriesSection({required this.homeState});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Column(
      children: [
        Row(
          children: [
            Text(
              "Categories:",
              style: TextStyle(
                fontSize: 18,
                color: colors.onSurface,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            TextButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CategoriesList()),
              ),
              child: Row(
                children: [
                  Text(
                    "All Categories",
                    style: TextStyle(color: colors.primary),
                  ),
                  Icon(Icons.chevron_right_rounded, color: colors.primary),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        _CategoriesRow(homeState: homeState),
      ],
    );
  }
}

// ── Categories Row ───────────────────────────────────────────
class _CategoriesRow extends StatelessWidget {
  final dynamic homeState;

  const _CategoriesRow({required this.homeState});

  @override
  Widget build(BuildContext context) {
    final count = homeState.categories.length.clamp(0, 8) as int;

    return SizedBox(
      height: 120,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: count,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          if (index == 7) return _MoreButton();
          final category = homeState.categories[index];
          return CategoryIconCard(
            name: category.name,
            imgUrl: category.image,
            onTap: () {},
          );
        },
      ),
    );
  }
}

// ── More Button ──────────────────────────────────────────────
class _MoreButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const CategoriesList()),
      ),
      child: Container(
        width: 76,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.grey.shade100, width: 1.5),
        ),
        clipBehavior:
            Clip.antiAlias, // قص الحدود الخارجة عن المحتوى بطريقة مرنة
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Container(
                height: 65,
                width: 65,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: colors.surface,
                  border: Border.all(color: colors.outline.withOpacity(0.4)),
                ),
                child: Icon(
                  Icons.grid_view_rounded,
                  size: 36,
                  color: colors.primary,
                ),
              ),
            ),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Center(
                child: Text(
                  "More",
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: colors.onSurface,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Error State ──────────────────────────────────────────────
class _ErrorState extends StatelessWidget {
  final VoidCallback onRetry;

  const _ErrorState({required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.wifi_off_rounded, size: 48, color: colors.error),
          const SizedBox(height: 12),
          Text(
            "Failed to load data",
            style: TextStyle(
              color: colors.onSurface.withOpacity(0.7),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: onRetry,
            style: ElevatedButton.styleFrom(
              backgroundColor: colors.primary,
              foregroundColor: colors.onPrimary,
            ),
            child: const Text("Retry"),
          ),
        ],
      ),
    );
  }
}
