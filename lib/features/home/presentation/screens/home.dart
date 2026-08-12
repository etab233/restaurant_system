// ignore_for_file: deprecated_member_use
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurants_system/core/location/presentation/screens/location_picker_screen.dart';
import 'package:restaurants_system/features/add_restaurant/presentation/providers/add_restaurant_provider.dart';
import 'package:restaurants_system/features/add_restaurant/presentation/screens/add_restaurant_screen.dart';
import 'package:restaurants_system/features/add_restaurant/presentation/screens/lock_screen.dart';
import 'package:restaurants_system/features/auth/presentation/providers/auth_provider.dart';
import 'package:restaurants_system/features/health_profile/presentation/screens/login_required_screen.dart';
import 'package:restaurants_system/features/health_profile/presentation/screens/welcome_screen.dart';
import 'package:restaurants_system/features/home/presentation/providers/home_provider.dart';
import 'package:restaurants_system/features/home/presentation/widgets/skeleton_data.dart';
import 'package:restaurants_system/features/profile/presentation/screens/profile_screen.dart';
import 'package:restaurants_system/features/restaurant_by_category/presentation/screens/restaurant_by_category_screen.dart';
import 'package:restaurants_system/features/restaurant_menu/presentation/screens/restaurant_menu_screen.dart';
import 'package:restaurants_system/features/home/presentation/widgets/categories/categories_grid.dart';
import 'package:restaurants_system/features/home/presentation/widgets/bubble_widget.dart';
import 'package:restaurants_system/features/auth/presentation/screens/login.dart';
import 'package:restaurants_system/features/auth/presentation/screens/register.dart';
import 'package:restaurants_system/features/home/presentation/widgets/categories/category_card.dart';
import 'package:restaurants_system/features/home/presentation/widgets/restaurant_card.dart';
import 'package:skeletonizer/skeletonizer.dart';

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
      await ref.read(authNotifierProvider.notifier).restoreSession();
      ref.read(homeNotifierProvider.notifier).getHomeData();
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

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    _bubble1Ctrl.dispose();
    _bubble2Ctrl.dispose();
    _bubble3Ctrl.dispose();
    super.dispose();
  }

  /*void _onSearchChanged(String value) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      ref.read(searchProvider.notifier).search(query: value);
    });
  }*/

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);
    final homeState = ref.watch(homeNotifierProvider);
    final resState = ref.watch(addRestaurantProvider.notifier);
    final skeletonHomeState = SkeletonHomeState();

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      drawer: _buildDrawer(authState),

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
                  //onSearchChanged: _onSearchChanged,
                  homeState: skeletonHomeState,
                  userLocation: userLocation,
                ),
              ),
              'false' => _ErrorState(
                onRetry: () =>
                    ref.read(homeNotifierProvider.notifier).getHomeData(),
              ),
              _ => _HomeBody(
                searchController: _searchController,
                //onSearchChanged: _onSearchChanged,
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
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 30),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
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
              /*Text(
                    "Deliver to",
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),*/
              InkWell(
                onTap: () async {
                  final location = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LocationPickerScreen(),
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
                        .read(homeNotifierProvider.notifier)
                        .getHomeData(lat: lat.toString(), lng: lng.toString());
                  }
                },
                child: Row(
                  children: [
                    const Icon(
                      Icons.location_on,
                      color: Colors.white,
                      size: 18,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      userLocation == "Home" ? "Home" : userLocation,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
              const Spacer(),
              // Notification
              const Icon(
                Icons.notifications_none,
                size: 30,
                color: Colors.white,
              ),
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
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
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
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => authState.userData != null
                          ? const ProfilePage()
                          : const LoginRequiredScreen(),
                    ),
                  );
                },
                child: Container(
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
              ),

              drawerItem(
                icon: Icons.settings,
                title: "Settings",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => authState.userData != null
                          ? const ProfilePage()
                          : const LoginRequiredScreen(),
                    ),
                  );
                },
              ),

              drawerItem(
                icon: Icons.restaurant,
                title: "Register Your Restaurant",
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => authState.userData != null
                        ? const AddRestaurant()
                        : const LockScreen(),
                  ),
                ),
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
                    builder: (_) => authState.userData == null
                        ? const LoginRequiredScreen()
                        : const Welcome(),
                  ),
                ),
              ),
              const Spacer(),

              if (authState.userData == null)
                Padding(
                  padding: const EdgeInsetsGeometry.symmetric(
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
                          builder: (_) =>
                              const Login(redirectTo: LoginRedirect.home),
                        ),
                      ),
                      child: const Text(
                        "Log in",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),

              if (authState.userData == null)
                Padding(
                  padding: const EdgeInsetsGeometry.only(
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
                        MaterialPageRoute(builder: (_) => const Register()),
                      ),
                      child: const Text(
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
class _HomeBody extends ConsumerStatefulWidget {
  final TextEditingController searchController;
  //final ValueChanged<String> onSearchChanged;
  final dynamic homeState;
  final String userLocation;

  const _HomeBody({
    required this.searchController,
    //required this.onSearchChanged,
    required this.homeState,
    required this.userLocation,
  });

  @override
  ConsumerState<_HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends ConsumerState<_HomeBody> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: RefreshIndicator(
        onRefresh: () async {
          await ref.read(homeNotifierProvider.notifier).getHomeData();
        },
        child: SingleChildScrollView(
          physics:
              const AlwaysScrollableScrollPhysics(), // حتى لو كان المحتوى في الشاشة قليل يعمل ال refresh
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _CategoriesSection(homeState: widget.homeState),

              const SizedBox(height: 20),
              Text(
                widget.userLocation != "Home"
                    ? "Restaurants Near You:"
                    : "Top Rated Restaurants:",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              ListView.builder(
                shrinkWrap: true,
                physics:
                    const NeverScrollableScrollPhysics(), // لأنو داخل SingleChildScrollView
                itemCount: widget.homeState.restaurants.length,
                itemBuilder: (context, index) {
                  return RestaurantCard(
                    restaurant: widget.homeState.restaurants[index],
                    onTap: () {
                      // انتقل لصفحة تفاصيل المطعم
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RestaurantMenuScreen(
                            restaurantId:
                                widget.homeState.restaurants[index].id,
                            coverImage:
                                widget.homeState.restaurants[index].coverImage,
                            logo: widget.homeState.restaurants[index].logo,
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
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
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RestaurantByCategoryScreen(
                    id: category.id,
                    name: category.name,
                    img: category.image,
                  ),
                ),
              );
            },
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
