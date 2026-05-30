// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurants_system/models/favorite_meal_model.dart';
import 'package:restaurants_system/models/restaurant_model.dart';
import 'package:restaurants_system/providers/favorite_provider.dart';
import 'package:restaurants_system/services/hive/favorite_meal_services.dart';
import 'package:restaurants_system/services/hive/favorite_restaurant_services.dart';
import 'package:restaurants_system/view/restaurant_screen/meal_details.dart';
import 'package:restaurants_system/view/restaurant_screen/restaurant_screen.dart';

class Favorites extends ConsumerStatefulWidget {
  const Favorites({super.key});
  @override
  ConsumerState<Favorites> createState() => FavoritesState();
}

class FavoritesState extends ConsumerState<Favorites> with TickerProviderStateMixin{
  final List<String> tabLabels = ["Restaurants", "Meals"];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final favorite = ref.watch(favoritesProvider);
    final restaurants = favorite.favoriteRestaurants; 
    final meals  = favorite.favoriteMeals;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "My Favorites",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              height: 1,
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(70),
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
              // الكبسولة
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 12,
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
                      BoxShadow(
                        color: Color(0x33FF6B35),
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),

                  labelColor: Colors.white,
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
                return _restaurantCard(restaurants[index]);
              },
            ),
            ListView.builder(
              itemCount: meals.length,
              itemBuilder: (context, index) {
                return favoriteMealCard(meals[index]);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _restaurantCard(RestaurantModel restaurant) {
    final isFavorite = FavoriteServices.isFavorite(restaurant.id);

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => RestaurantScreen(restaurantId: restaurant.id),
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
            // Restaurant Image
            ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child:
                  (restaurant.coverImage != null &&
                      restaurant.coverImage!.isNotEmpty)
                  ? Image.network(
                      restaurant.coverImage!,
                      width: 120,
                      height: 125,
                      fit: BoxFit.cover,
                    )
                  : SizedBox(
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

            // Content
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
                                Spacer(),
                                InkWell(
                                  onTap: () {
                                    ref.read(favoritesProvider.notifier).toggleRestaurant(restaurant);
                                  },
                                  child: isFavorite
                                      ? Icon(
                                          Icons.favorite,
                                          color: const Color(0xFFFF6B35),
                                        )
                                      : Icon(
                                          Icons.favorite_border_rounded,
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

  Widget favoriteMealCard(FavoriteMeal meal) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => MealDetails(
              itemId: meal.itemId,
              restaurantId: meal.restaurantId,
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
            // IMAGE
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
                        "assets/images/meal.jpg",
                        fit: BoxFit.cover,
                      ),
                    ),
            ),

            const SizedBox(width: 14),

            // CONTENT
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // NAME + HEART
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
                            ref.read(favoritesProvider.notifier).toggleMeal(meal);
                          },
                          child: Icon(
                            FavoriteMealServices.isFavorite(meal.itemId)
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

                    // DESCRIPTION
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

                    // BOTTOM INFO
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
