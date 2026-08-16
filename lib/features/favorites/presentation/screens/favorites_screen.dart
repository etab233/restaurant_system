// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurants_system/core/enums/meal_details_mode.dart';
import 'package:restaurants_system/core/widgets/app_network_image.dart';
import 'package:restaurants_system/features/home/data/models/restaurant_model.dart';
import 'package:restaurants_system/features/meal_details/presentation/screens/meal_details_screens.dart';
import 'package:restaurants_system/features/restaurant_menu/presentation/screens/restaurant_menu_screen.dart';
import '../../data/models/favorite_meal_model.dart';
import '../providers/favorite_notifier.dart';

class FavoritesScreen extends ConsumerStatefulWidget {
  const FavoritesScreen({super.key});
  @override
  ConsumerState<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends ConsumerState<FavoritesScreen>
    with TickerProviderStateMixin {
  final List<String> tabLabels = ["Restaurants", "Meals"];

  @override
  Widget build(BuildContext context) {
    final favorite = ref.watch(favoritesProvider);
    final restaurants = favorite.favoriteRestaurants;
    final meals = favorite.favoriteMeals;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F5F5),
        appBar: AppBar(
          title: const Text(
            "My Favorites",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              height: 1,
            ),
          ),
          centerTitle: true,
          backgroundColor: const Color(0xFFF5F5F5),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(70),
            child: Container(
              color: const Color(0xFFF5F5F5),
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 15,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: TabBar(
                  dividerColor: Colors.transparent,
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFF7A3D), Color(0xFFFF6B35)],
                    ),
                    boxShadow: [
                      const BoxShadow(
                        color: Color(0x33FF6B35),
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  labelColor: const Color(0xFFF5F5F5),
                  unselectedLabelColor: const Color(0xFF777777),
                  labelStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                  unselectedLabelStyle: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  splashBorderRadius: BorderRadius.circular(30),
                  tabs: tabLabels.map((label) {
                    return Tab(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(label),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        ),
        body: TabBarView(
          children: [
            ListView.builder(
              itemCount: restaurants.length,
              itemBuilder: (context, index) {
                return _restaurantCard(restaurants[index], restaurants);
              },
            ),
            ListView.builder(
              itemCount: meals.length,
              itemBuilder: (context, index) {
                return _favoriteMealCard(meals[index], meals);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _restaurantCard(
    RestaurantModel restaurant,
    List<RestaurantModel> allFavorites,
  ) {
    // isFavorite مشتقة من القائمة نفسها بدل استدعاء منفصل لـ Hive
    final isFavorite = allFavorites.any((r) => r.id == restaurant.id);

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => RestaurantMenuScreen(restaurantId: restaurant.id),
          ),
        );
      },
      child: Container(
        height: 125,
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 14,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            AppNetworkImage(
              imageUrl: restaurant.coverImage,
              width: 120,
              height: 125,
              borderRadius: BorderRadius.circular(18),
              fallback: const SizedBox(
                width: 120,
                height: 125,
                child: Icon(
                  Icons.store_mall_directory,
                  size: 44,
                  color: Colors.grey,
                ),
              ),
              placeholder: const SizedBox(
                width: 120,
                height: 125,
                child: Icon(
                  Icons.store_mall_directory,
                  size: 44,
                  color: Colors.grey,
                ),
              ),
            ),
            const SizedBox(width: 30),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  restaurant.name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF1A1A1A),
                                  ),
                                ),
                                const Spacer(),
                                InkWell(
                                  onTap: () {
                                    ref
                                        .read(favoritesProvider.notifier)
                                        .toggleRestaurant(restaurant);
                                  },
                                  child: Icon(
                                    isFavorite
                                        ? Icons.favorite
                                        : Icons.favorite_border_rounded,
                                    color: const Color(0xFFFF6B35),
                                  ),
                                ),
                                const SizedBox(width: 10),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              restaurant.description,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      const Icon(
                        Icons.star_rounded,
                        color: Colors.orange,
                        size: 18,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        restaurant.rate.toString(),
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        restaurant.location.distanceKm.toString(),
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 14,
                        ),
                      ),
                      const Spacer(),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 18,
                        color: Colors.grey.shade500,
                      ),
                      const SizedBox(width: 10),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    restaurant.hours.isOpen ? "Open now" : "Closed",
                    style: TextStyle(
                      color: restaurant.hours.isOpen
                          ? Colors.green
                          : Colors.red,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
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

  Widget _favoriteMealCard(FavoriteMeal meal, List<FavoriteMeal> allFavorites) {
    final isFavorite = allFavorites.any((m) => m.itemId == meal.itemId);

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => MealDetails(
              itemId: meal.itemId,
              restaurantId: meal.restaurantId,
              mode: MealDetailsMode.create,
            ),
          ),
        );
      },
      borderRadius: BorderRadius.circular(22),
      child: Container(
        height: 125,
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 14,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            // الحالي
            ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(18)),
              child: (meal.image != null && meal.image!.isNotEmpty)
                  ? Image.network(
                      meal.image!,
                      width: 120,
                      height: 125,
                      fit: BoxFit.cover,
                    )
                  : Container(
                      width: 120,
                      height: 125,
                      color: Colors.grey.shade200,
                      child: Image.asset(
                        "assets/images/meal.webp",
                        fit: BoxFit.cover,
                      ),
                    ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
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
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF1A1A1A),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            ref
                                .read(favoritesProvider.notifier)
                                .toggleMeal(meal);
                          },
                          child: Icon(
                            isFavorite
                                ? Icons.favorite
                                : Icons.favorite_border_rounded,
                            size: 22,
                            color: const Color(0xFFFF6B35),
                          ),
                        ),
                        const SizedBox(width: 12),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      meal.description ?? "",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14,
                        height: 1.3,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        Container(
                          width: 9,
                          height: 9,
                          decoration: const BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          "Tap to see details",
                          style: TextStyle(
                            color: Colors.green.shade700,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Spacer(),
                        Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 18,
                          color: Colors.grey.shade500,
                        ),
                        const SizedBox(width: 12),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
