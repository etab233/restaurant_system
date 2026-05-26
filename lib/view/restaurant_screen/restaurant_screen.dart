// ignore_for_file: deprecated_member_use, depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:marquee/marquee.dart';
import 'package:restaurants_system/notifier/restaurant_notifier.dart';
import 'package:restaurants_system/providers/restaurant_provider.dart';
import 'package:restaurants_system/view/restaurant_screen/meal_details.dart';
import 'package:skeletonizer/skeletonizer.dart';

class RestaurantScreen extends ConsumerStatefulWidget {
  final int restaurantId;
  final String coverImage;
  final String logo;
  const RestaurantScreen({
    super.key,
    required this.restaurantId,
    required this.coverImage,
    required this.logo,
  });

  @override
  ConsumerState<RestaurantScreen> createState() => _RestaurantScreenState();
}

class _RestaurantScreenState extends ConsumerState<RestaurantScreen>
    with TickerProviderStateMixin {
  final Color primaryColor = const Color(0xFFFF6B35);

  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  TabController? _tabController;

  final Map<int, GlobalKey> categorykeys = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(restaurantProvider.notifier).viewRestaurant(widget.restaurantId);
    });
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_tabController == null) return;
    for (int i = 0; i < categorykeys.length; i++) {
      final keyContext = categorykeys[i]?.currentContext;
      if (keyContext != null) {
        final box = keyContext.findRenderObject() as RenderBox;
        final y = box.localToGlobal(Offset.zero).dy;

        if (y <= 180 && y >= 0) {
          if (_tabController!.length > i) {
            _tabController!.animateTo(i);
            break;
          }
        }
      }
    }
  }

  @override
  void dispose() {
    _tabController?.dispose();
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  String formatTime(String? time) {
    if (time == null || time.isEmpty) return "";
    try {
      final parsedTime = DateFormat('HH:mm:ss').parse(time);
      return DateFormat('hh:mm a').format(parsedTime);
    } catch (_) {
      return time;
    }
  }

  String formatSyrianPhone(String phone) {
    phone = phone.replaceAll(" ", "");
    if (phone.startsWith("+963")) return "0${phone.substring(4)}";
    if (phone.startsWith("963")) return "0${phone.substring(3)}";
    return phone;
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(restaurantProvider);
    final isLoading = state.isLoading;
    final displayState = isLoading ? RestaurantSkeletonizer.loadingData : state;
    final safeCategories = displayState.categories;
    final tabCount = safeCategories.length;

    if (_tabController == null) {
      _tabController = TabController(length: tabCount, vsync: this);
    } else if (_tabController!.length != tabCount) {
      _tabController!.dispose();
      _tabController = TabController(length: tabCount, vsync: this);
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Skeletonizer(
        enabled: isLoading,
        effect: ShimmerEffect(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
        ),
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            _buildSliverAppBar(
              context,
              displayState,
              safeCategories,
              isLoading,
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              sliver: isLoading
                  ? _buildSkeletonSliver()
                  : _buildAllMealsSliver(safeCategories),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSkeletonSliver() {
    return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
        return Container(
          margin: const EdgeInsets.only(bottom: 14),
          height: 110,
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Row(
            children: [
              Container(
                width: 120,
                height: 110,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(18),
                    bottomLeft: Radius.circular(18),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 14,
                        width: double.infinity,
                        color: Colors.grey.shade400,
                      ),
                      const SizedBox(height: 10),
                      Container(
                        height: 10,
                        width: 180,
                        color: Colors.grey.shade400,
                      ),
                      const SizedBox(height: 6),
                      Container(
                        height: 10,
                        width: 140,
                        color: Colors.grey.shade400,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }, childCount: 6),
    );
  }

  Widget _buildSliverAppBar(
    BuildContext context,
    RestaurantScreenState displayState,
    List safeCategories,
    bool isLoading,
  ) {
    final restaurant = displayState.restaurant;
    final tabLabels = safeCategories.map((c) => c.name).toList();

    return SliverAppBar(
      automaticallyImplyLeading: false,
      backgroundColor: const Color(0xFFF5F5F5),
      systemOverlayStyle: SystemUiOverlayStyle.light,
      surfaceTintColor: Colors.transparent,
      pinned: true,
      expandedHeight: 490,
      elevation: 0,
      collapsedHeight: 100,
      toolbarHeight: 70,
      title: Builder(
        builder: (context) {
          final settings = context
              .dependOnInheritedWidgetOfExactType<FlexibleSpaceBarSettings>();
          final currentExtent = settings?.currentExtent ?? 0;
          final maxExtent = settings?.maxExtent ?? 1;
          final collapseRatio = currentExtent / maxExtent;
          final showSearch = collapseRatio <= 0.35;

          return AnimatedOpacity(
            duration: const Duration(milliseconds: 250),
            opacity: showSearch ? 1 : 0,
            child: IgnorePointer(
              ignoring: !showSearch,
              child: SafeArea(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        InkWell(
                          onTap: () => Navigator.pop(context),
                          child: const Icon(Icons.chevron_left_outlined),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            restaurant?.name ?? "",
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(width: 30),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Container(
                      height: 42,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: "Search meals...",
                          prefixIcon: Icon(Icons.search, color: primaryColor),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 10,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.pin,
        background: Stack(
          clipBehavior: Clip.none,
          children: [
            // IMAGE
            Skeleton.keep(
              child: Hero(
                tag: "restaurant_${restaurant?.id ?? 0}",
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(40),
                    bottomRight: Radius.circular(40),
                  ),
                  child: Image.network(
                    widget.coverImage,
                    height: 250,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),

            // BACK BUTTON
            Positioned(
              top: MediaQuery.of(context).padding.top + 10,
              left: 12,
              child: Skeleton.keep(
                child: _circleButton(
                  icon: Icons.arrow_back_ios_new_rounded,
                  onTap: () => Navigator.pop(context),
                ),
              ),
            ),

            // FAVORITE BUTTON
            Positioned(
              top: MediaQuery.of(context).padding.top + 10,
              right: 12,
              child: Skeleton.keep(
                child: _circleButton(
                  icon: Icons.favorite_border_rounded,
                  onTap: () {},
                  iconColor: primaryColor,
                ),
              ),
            ),

            // FLOATING INFO CARD
            Positioned(
              top: 170,
              left: 16,
              right: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 14,
                  horizontal: 10,
                ),
                height: 190,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _infoCol(
                          icon: Icons.access_time_rounded,
                          label: "Hours",
                          value:
                              "${formatTime(restaurant?.hours.opens ?? '')}\n"
                              "${formatTime(restaurant?.hours.closes ?? '')}",
                        ),
                        _divider(),
                        _infoCol(
                          icon: Icons.phone_outlined,
                          label: "Phone",
                          value: formatSyrianPhone(restaurant?.phone ?? ""),
                          onTap: () => makePhoneCall(restaurant!.phone),
                        ),
                        _divider(),
                        _infoCol(
                          icon: Icons.delivery_dining_outlined,
                          label: "Away from",
                          value: "${restaurant!.location.distanceKm} Km",
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    _verticatDivider(),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.location_on_outlined,
                                color: primaryColor,
                                size: 22,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "Address",
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey.shade500,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          Expanded(
                            child: SizedBox(
                              height: 24,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Marquee(
                                      text: restaurant.address,
                                      style: const TextStyle(
                                        fontSize: 15,
                                        color: Colors.black,
                                      ),
                                      scrollAxis: Axis.horizontal,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      blankSpace: 40,
                                      velocity: 35,
                                      pauseAfterRound: const Duration(
                                        seconds: 1,
                                      ),
                                      startPadding: 10,
                                      accelerationDuration: const Duration(
                                        seconds: 1,
                                      ),
                                      accelerationCurve: Curves.easeIn,
                                      decelerationDuration: const Duration(
                                        milliseconds: 500,
                                      ),
                                      decelerationCurve: Curves.easeOut,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  GestureDetector(
                                    onTap: () {
                                      openMap(
                                        lat: restaurant.location.latitude!,
                                        lng: restaurant.location.longitude!,
                                        name: restaurant.name,
                                      );
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                        color: primaryColor.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Icon(
                                        Icons.open_in_new_rounded,
                                        color: primaryColor,
                                        size: 22,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // NAME + DESCRIPTION
            Positioned(
              top: 380,
              left: 16,
              right: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        restaurant.name,
                        style: const TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF1A1A1A),
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(width: 20),
                      Text(
                        restaurant.rate.toString(),
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(width: 2),
                      Icon(Icons.star_rounded, size: 20, color: primaryColor),
                    ],
                  ),
                  const SizedBox(height: 7),
                  Text(
                    restaurant.description,
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            ),

            // LOGO
            Positioned(
              top: 105,
              right: 35,
              child: _restaurantLogo(
                widget.logo,
                restaurant.id,
                isOpen: restaurant.hours.isOpen,
              ),
            ),
          ],
        ),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(40),
        child: Container(
          color: const Color(0xFFF5F5F5),
          child: TabBar(
            controller: _tabController,
            onTap: (index) {
              final key = categorykeys[index];
              if (key?.currentContext != null) {
                Scrollable.ensureVisible(
                  key!.currentContext!,
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeInOut,
                );
              }
            },
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            indicatorSize: TabBarIndicatorSize.tab,
            indicator: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.circular(20),
            ),
            labelColor: Colors.white,
            unselectedLabelColor: const Color(0xFF555555),
            labelStyle: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
            unselectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 13,
            ),
            dividerColor: Colors.transparent,
            tabs: tabLabels.map((label) {
              return Tab(
                child: Padding(
                  padding: const EdgeInsets.all(2),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [Text(label)],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildAllMealsSliver(List categories) {
    return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
        final category = categories[index];
        categorykeys[index] = GlobalKey();

        return Container(
          key: categorykeys[index],
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Text(
                  category.name,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ...category.menuItems.map<Widget>(
                (meal) => _MealCard(meal: meal, primaryColor: primaryColor),
              ),
            ],
          ),
        );
      }, childCount: categories.length),
    );
  }

  Widget _infoCol({
    required IconData icon,
    required String label,
    required String value,
    VoidCallback? onTap,
  }) {
    return Expanded(
      flex: 1,
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(icon, color: primaryColor, size: 22),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              value,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 13, color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }

  Widget _divider() =>
      Container(width: 1, height: 75, color: Colors.grey.shade300);

  Widget _verticatDivider() =>
      Container(width: 300, height: 1, color: Colors.grey.shade300);

  Widget _circleButton({
    required IconData icon,
    required VoidCallback onTap,
    Color iconColor = const Color(0xFF333333),
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.92),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 8),
          ],
        ),
        child: Icon(icon, size: 20, color: iconColor),
      ),
    );
  }

  Widget _restaurantLogo(String? logo, int? id, {bool isOpen = false}) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 78,
          height: 78,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 10),
            ],
            border: BoxBorder.all(color: const Color(0xFFFF6B35), width: 3),
          ),
          child: Hero(
            tag: "restaurant logo $id",
            child: ClipOval(
              child: (logo != null && logo.isNotEmpty)
                  ? Image.network(
                      logo,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                          Icon(Icons.restaurant, size: 30, color: primaryColor),
                    )
                  : Icon(Icons.restaurant, size: 30, color: primaryColor),
            ),
          ),
        ),
        if (isOpen)
          Positioned(
            bottom: 4,
            right: 4,
            child: Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 1),
              ),
            ),
          ),
      ],
    );
  }
}

class _MealCard extends StatelessWidget {
  final dynamic meal;
  final Color primaryColor;
  const _MealCard({required this.meal, required this.primaryColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 125,
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          // IMAGE
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(18),
                  bottomLeft: Radius.circular(18),
                ),
                child: Hero(
                  tag: "meal_${meal.id}",
                  child: (meal.image != null && meal.image!.isNotEmpty)
                      ? Image.network(
                          meal.image!,
                          width: 120,
                          height: 125,
                          fit: BoxFit.cover,
                        )
                      : Image.asset(
                          "assets/images/meal.jpg",
                          width: 120,
                          height: 125,
                          fit: BoxFit.cover,
                        ),
                ),
              ),
              if (meal.preparationTime != null &&
                  meal.preparationTime!.isNotEmpty)
                Positioned(
                  bottom: 8,
                  left: 6,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.timer_outlined,
                          color: Colors.white,
                          size: 12,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          meal.preparationTime!,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),

          // CONTENT
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          meal.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 15,
                            color: Color(0xFF1A1A1A),
                          ),
                        ),
                      ),
                      Icon(
                        Icons.favorite_border_rounded,
                        size: 18,
                        color: Colors.grey.shade500,
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Text(
                    meal.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade600,
                      height: 1.3,
                    ),
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => MealDetails(id: meal.id),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFF6B35),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            "View",
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        flex: 1,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(
                              color: Color(0xFF2E7D32),
                              width: 2,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            "Analyze",
                            style: TextStyle(
                              fontSize: 11,
                              color: Color(0xFF2E7D32),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
