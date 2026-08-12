// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurants_system/features/restaurant_by_category/presentation/widgets/empty_restaurant_view.dart';
import 'package:restaurants_system/features/restaurant_by_category/presentation/widgets/restaurant_by_category_cart.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../providers/restaurant_by_category_notifier.dart';
import '../widgets/restaurant_by_category_skeleton.dart';

class RestaurantByCategoryScreen extends ConsumerStatefulWidget {
  final int id;
  final String name;
  final String img;
  const RestaurantByCategoryScreen({
    required this.id,
    required this.name,
    required this.img,
    super.key,
  });

  @override
  ConsumerState<RestaurantByCategoryScreen> createState() =>
      _RestaurantByCategoryScreenState();
}

class _RestaurantByCategoryScreenState
    extends ConsumerState<RestaurantByCategoryScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref
          .read(restaurantByCategoryProvider.notifier)
          .fetchRestaurantsByCategory(widget.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final categoryState = ref.watch(restaurantByCategoryProvider);
    final restaurants = categoryState.restaurants;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF6F6F6),
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              automaticallyImplyLeading: false,
              expandedHeight: 300,
              backgroundColor: Colors.black,
              actions: [
                Padding(
                  padding: const EdgeInsets.only(left: 12),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.45),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(
                        Icons.keyboard_arrow_left,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                ),
              ],
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(
                      widget.img,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey.shade300,
                          child: const Center(
                            child: Icon(
                              Icons.fastfood,
                              size: 60,
                              color: Colors.grey,
                            ),
                          ),
                        );
                      },
                    ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.black.withOpacity(0.6),
                            Colors.transparent,
                          ],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 16,
                      right: 16,
                      left: 16,
                      child: Text(
                        widget.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 16)),
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: categoryState.isLoading
                  ? SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        return const Padding(
                          padding: EdgeInsets.only(bottom: 12),
                          child: Skeletonizer(
                            enabled: true,
                            effect: ShimmerEffect(),
                            child: RestaurantByCategorySkeleton(),
                          ),
                        );
                      }, childCount: 3),
                    )
                  : categoryState.restaurants.isEmpty
                  ? SliverToBoxAdapter(
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.7,
                        child: EmptyRestaurantsView(
                          onRetry: () {
                            ref
                                .read(restaurantByCategoryProvider.notifier)
                                .fetchRestaurantsByCategory(widget.id);
                          },
                        ),
                      ),
                    )
                  : SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        final restaurant = restaurants[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: RestaurantByCategoryCard(
                            restaurant: restaurant,
                          ),
                        );
                      }, childCount: restaurants.length),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
