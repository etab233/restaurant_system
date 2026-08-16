// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurants_system/core/enums/meal_details_mode.dart';
import 'package:restaurants_system/core/widgets/app_network_image.dart';
import 'package:restaurants_system/features/favorites/data/models/favorite_meal_model.dart';
import 'package:restaurants_system/features/favorites/presentation/providers/favorite_notifier.dart';
import 'package:restaurants_system/features/meal_details/data/models/meal_item_model.dart';
import 'package:restaurants_system/features/meal_details/presentation/screens/meal_details_screens.dart';

class MealCard extends ConsumerStatefulWidget {
  final MealItem meal;
  final Color primaryColor;
  const MealCard({super.key, required this.meal, required this.primaryColor});

  @override
  ConsumerState<MealCard> createState() => _MealCardState();
}

class _MealCardState extends ConsumerState<MealCard> {
  @override
  Widget build(BuildContext context) {
    final favoritesState = ref.watch(favoritesProvider);

    final isFav = favoritesState.favoriteMeals.any(
      (m) => m.itemId == widget.meal.itemId,
    );

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => MealDetails(
              itemId: widget.meal.itemId,
              restaurantId: widget.meal.restaurantId,
              image: widget.meal.image,
              mode: MealDetailsMode.create,
            ),
          ),
        );
      },
      child: Container(
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
            Stack(
              children: [
                Hero(
                  tag: "meal_${widget.meal.itemId}",
                  child: AppNetworkImage(
                    imageUrl: widget.meal.image,
                    width: 120,
                    height: 125,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(18),
                      bottomLeft: Radius.circular(18),
                    ),
                    fallback: Image.asset(
                      "assets/images/meal.webp",
                      width: 120,
                      height: 125,
                      fit: BoxFit.cover,
                    ),
                    placeholder: Image.asset(
                      "assets/images/meal.webp",
                      width: 120,
                      height: 125,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                if (widget.meal.preparationTime.isNotEmpty)
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
                            widget.meal.preparationTime,
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
                if (widget.meal.isFeatured)
                  Positioned(
                    top: 8,
                    left: 6,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: const Row(
                        children: [
                          Text(
                            "الأكثر طلباً",
                            style: TextStyle(
                              color: Color(0xFFFF6B35),
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                          SizedBox(width: 4),
                          Icon(Icons.star, size: 13, color: Color(0xFFFF6B35)),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            widget.meal.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 15,
                              color: Color(0xFF1A1A1A),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            ref
                                .read(favoritesProvider.notifier)
                                .toggleMeal(
                                  FavoriteMeal(
                                    itemId: widget.meal.itemId,
                                    restaurantId: widget.meal.restaurantId,
                                    name: widget.meal.name,
                                    image: widget.meal.image,
                                    description: widget.meal.description,
                                  ),
                                );
                          },
                          child: Icon(
                            isFav
                                ? Icons.favorite
                                : Icons.favorite_border_rounded,
                            size: 24,
                            color: const Color(0xFFFF6B35),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Text(
                      widget.meal.description ?? "",
                      maxLines: 1,
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
                        Text(
                          "${widget.meal.price} SYP",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2E7D32),
                          ),
                        ),
                        const Spacer(),
                        Container(
                          width: 25,
                          height: 25,
                          decoration: BoxDecoration(
                            color: const Color(0xFFFF6B35),
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(.35),
                                blurRadius: 12,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.add_rounded,
                            color: Colors.white,
                            size: 24,
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
      ),
    );
  }
}
