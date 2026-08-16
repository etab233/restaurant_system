// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:marquee/marquee.dart';
import 'package:restaurants_system/core/widgets/app_network_image.dart';
import 'package:restaurants_system/features/favorites/presentation/providers/favorite_notifier.dart';
import 'package:restaurants_system/features/restaurant_menu/presentation/providers/restaurant_menu_notifier.dart';
import 'package:restaurants_system/features/restaurant_menu/presentation/providers/restaurant_menu_state.dart';
import 'package:restaurants_system/features/restaurant_menu/presentation/utils/restaurant_actions.dart';
import 'package:restaurants_system/features/restaurant_menu/presentation/widgets/meal_card.dart';
import 'package:restaurants_system/features/restaurant_menu/presentation/screens/meal_search_delegate.dart';
import 'package:restaurants_system/features/meal_details/data/models/meal_item_model.dart';
import 'package:restaurants_system/features/restaurant_menu/presentation/widgets/restaurant_search_bar.dart';
import 'package:skeletonizer/skeletonizer.dart';

class RestaurantMenuScreen extends ConsumerStatefulWidget {
  const RestaurantMenuScreen({
    super.key,
    required this.restaurantId,
    this.coverImage,
    this.logo,
  });

  final String? coverImage;
  final String? logo;
  final int restaurantId;

  @override
  ConsumerState<RestaurantMenuScreen> createState() =>
      _RestaurantMenuScreenState();
}

class _RestaurantMenuScreenState extends ConsumerState<RestaurantMenuScreen>
    with TickerProviderStateMixin {
  final Map<int, GlobalKey> categorykeys = {};
  final Color primaryColor = const Color(0xFFFF6B35);

  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  TabController? _tabController;

  @override
  void dispose() {
    _tabController?.dispose();
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(restaurantMenuProvider(widget.restaurantId).notifier)
          .viewRestaurant(widget.restaurantId);
    });
    _scrollController.addListener(_onScroll);
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

  Widget circleButton({
    required IconData icon,
    required VoidCallback onTap,
    Color iconColor = const Color(0xFF333333),
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 45,
        height: 45,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.92),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 8),
          ],
        ),
        child: Icon(icon, size: 25, color: iconColor),
      ),
    );
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

  Widget _buildLoadingLayout() {
    return Skeletonizer(
      enabled: true,
      effect: ShimmerEffect(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
      ),
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _buildSkeletonHeader()),
          SliverPadding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            sliver: _buildSkeletonSliver(),
          ),
        ],
      ),
    );
  }

  Widget _skeletonBox({
    double? width,
    double? height,
    double radius = 8,
    Color? color,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color ?? Colors.grey.shade300,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }

  Widget _buildSkeletonHeader() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // صورة الغلاف
        ClipRRect(
          borderRadius: const BorderRadius.vertical(
            bottom: Radius.circular(15),
          ),
          child: Container(
            height: 210,
            width: double.infinity,
            color: Colors.grey.shade300,
          ),
        ),

        // زرين الرجوع والمفضلة
        Positioned(
          top: 10,
          left: 15,
          child: Container(
            width: 45,
            height: 45,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
          ),
        ),
        Positioned(
          top: 10,
          right: 15,
          child: Container(
            width: 45,
            height: 45,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
          ),
        ),

        // شعار المطعم (دائرة فوق الصورة)
        Positioned(
          top: 90,
          right: 35,
          child: Container(
            width: 78,
            height: 78,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
          ),
        ),

        // بطاقة المعلومات (الساعات / الهاتف / المسافة + العنوان)
        Positioned(
          top: 155,
          left: 16,
          right: 16,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
            height: 190,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _skeletonInfoCol(),
                    Container(
                      width: 1,
                      height: 75,
                      color: Colors.grey.shade300,
                    ),
                    _skeletonInfoCol(),
                    Container(
                      width: 1,
                      height: 75,
                      color: Colors.grey.shade300,
                    ),
                    _skeletonInfoCol(),
                  ],
                ),
                const SizedBox(height: 20),
                Container(width: 300, height: 1, color: Colors.grey.shade300),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _skeletonBox(width: 22, height: 22, radius: 7),
                          const SizedBox(height: 4),
                          _skeletonBox(width: 40, height: 10, radius: 5),
                        ],
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Container(
                          height: 15,
                          color: Colors.grey.shade300,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _skeletonInfoCol() {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _skeletonBox(width: 22, height: 22, radius: 7),
          const SizedBox(height: 5),
          _skeletonBox(width: 40, height: 9, radius: 5),
          const SizedBox(height: 7),
          _skeletonBox(width: 50, height: 12, radius: 6),
        ],
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
    RestaurantMenuState displayState,
    List<dynamic> safeCategories,
    bool isLoading,
    bool isFavorite,
  ) {
    final restaurant = displayState.restaurant;
    final tabLabels = safeCategories.map((c) => c.name).toList();
    final imageUrl = restaurant?.coverImage?.isNotEmpty == true
        ? restaurant!.coverImage!
        : widget.coverImage;

    return SliverAppBar(
      automaticallyImplyLeading: false,
      backgroundColor: const Color(0xFFF5F5F5),
      systemOverlayStyle: SystemUiOverlayStyle.light,
      surfaceTintColor: Colors.transparent,
      pinned: true,
      expandedHeight: 480,
      elevation: 0,
      collapsedHeight: 100,
      toolbarHeight: 100,
      title: Builder(
        builder: (context) {
          final settings = context
              .dependOnInheritedWidgetOfExactType<FlexibleSpaceBarSettings>();
          final currentExtent = settings?.currentExtent ?? 0;
          final maxExtent = settings?.maxExtent ?? 1;
          final collapseRatio = currentExtent / maxExtent;
          final isSearchVisible = collapseRatio <= 0.35;

          return RestaurantSearchHeader(
            isSearchVisible: isSearchVisible,
            restaurantName: restaurant?.name ?? "",
            onSearchTap: () {
              final allMeals = safeCategories
                  .expand((category) => category.menuItems ?? [])
                  .cast<MealItem>()
                  .toList();
              showSearch(
                context: context,
                delegate: MealSearchDelegate(allMeals),
              );
            },
          );
        },
      ),
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.pin,
        background: Stack(
          clipBehavior: Clip.none,
          children: [
            Skeleton.keep(
              child: Hero(
                tag: "restaurant_${restaurant?.id ?? 0}",
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(15),
                  ),
                  child: AppNetworkImage(
                    imageUrl: imageUrl,
                    width: double.infinity,
                    height: 210,
                    fallback: Image.asset(
                      "assets/images/no_restaurant_image.webp",
                      fit: BoxFit.cover,
                    ),
                    placeholder: Image.asset(
                      "assets/images/no_restaurant_image.webp",
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).padding.top + 10,
              left: 15,
              child: Skeleton.keep(
                child: circleButton(
                  icon: Icons.arrow_back_ios_new_rounded,
                  onTap: () => Navigator.pop(context),
                ),
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).padding.top + 10,
              right: 15,
              child: Skeleton.keep(
                child: circleButton(
                  icon: isFavorite
                      ? Icons.favorite
                      : Icons.favorite_border_rounded,
                  onTap: () {
                    if (restaurant != null) {
                      ref
                          .read(favoritesProvider.notifier)
                          .toggleRestaurant(restaurant);
                    }
                  },
                  iconColor: primaryColor,
                ),
              ),
            ),
            Positioned(
              top: 155,
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
                              "${formatTime(restaurant?.hours.opens ?? '')}\n${formatTime(restaurant?.hours.closes ?? '')}",
                        ),
                        _divider(),
                        _infoCol(
                          icon: Icons.phone_outlined,
                          label: "Phone",
                          value: formatSyrianPhone(restaurant?.phone ?? ""),
                          onTap: () => makePhoneCall(restaurant?.phone ?? ""),
                        ),
                        _divider(),
                        _infoCol(
                          icon: Icons.delivery_dining_outlined,
                          label: "Away from",
                          value: "${restaurant?.location.distanceKm ?? 0} Km",
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
                                    child: RepaintBoundary(
                                      child: Marquee(
                                        text: restaurant?.address ?? " ",
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
                                  ),
                                  const SizedBox(width: 8),
                                  GestureDetector(
                                    onTap: () {
                                      if (restaurant != null) {
                                        openMap(
                                          lat: restaurant.location.latitude!,
                                          lng: restaurant.location.longitude!,
                                          name: restaurant.name,
                                        );
                                      }
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
                        restaurant?.name ?? "",
                        style: const TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF1A1A1A),
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(width: 20),
                      Text(
                        restaurant?.rate.toString() ?? "",
                        style: const TextStyle(
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
                    restaurant?.description ?? "",
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 90,
              right: 35,
              child: _restaurantLogo(
                widget.logo,
                restaurant?.id,
                isOpen: restaurant?.hours.isOpen ?? false,
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
                (meal) => MealCard(meal: meal, primaryColor: primaryColor),
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
              style: const TextStyle(
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
            child: AppNetworkImage(
              imageUrl: logo,
              width: 78,
              height: 78,
              borderRadius: BorderRadius.circular(39),
              fallback: Icon(Icons.restaurant, size: 30, color: primaryColor),
              placeholder: Icon(
                Icons.restaurant,
                size: 30,
                color: primaryColor,
              ),
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

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(restaurantMenuProvider(widget.restaurantId));
    final favoritesState = ref.watch(favoritesProvider);

    final isLoading = state.isLoading;
    final displayState = isLoading ? RestaurantSkeletonizer.loadingData : state;
    final safeCategories = displayState.categories;
    final tabCount = safeCategories.length;
    final restaurant = displayState.restaurant;

    final isFavorite = favoritesState.favoriteRestaurants.any(
      (m) => m.id == restaurant?.id,
    );

    if (_tabController == null) {
      _tabController = TabController(length: tabCount, vsync: this);
    } else if (_tabController!.length != tabCount) {
      _tabController!.dispose();
      _tabController = TabController(length: tabCount, vsync: this);
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF5F4F0),
      body: isLoading
          ? _buildLoadingLayout()
          : CustomScrollView(
              controller: _scrollController,
              slivers: [
                _buildSliverAppBar(
                  context,
                  displayState,
                  safeCategories,
                  isLoading,
                  isFavorite,
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 16,
                  ),
                  sliver: _buildAllMealsSliver(safeCategories),
                ),
              ],
            ),
    );
  }
}
