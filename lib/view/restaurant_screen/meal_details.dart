// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurants_system/models/favorite_meal_model.dart';
import 'package:restaurants_system/providers/favorite_provider.dart';
import 'package:restaurants_system/providers/meal_details_provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 22);

    path.quadraticBezierTo(
      size.width * 0.25, //  X's of first_control point
      size.height, //  Y's of first_control point

      size.width * 0.50, //  X's of end point
      size.height - 12, //  Y's of end point
    );

    path.quadraticBezierTo(
      size.width * 0.75,
      size.height - 26,

      size.width,
      size.height - 6,
    );

    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldCliper) {
    return false;
  }
}

class MealDetails extends ConsumerStatefulWidget {
  final String? image;
  final int itemId;
  final int restaurantId;
  const MealDetails({
    super.key,
    this.image,
    required this.itemId,
    required this.restaurantId,
  });
  @override
  ConsumerState<MealDetails> createState() => MealDetailsState();
}

class MealDetailsState extends ConsumerState<MealDetails> {
  final bool isSelected = false;
  int selectedVariantId = -1;
  int quantity = 1;
  Map<int, bool> expandedGroup = {}; // لمعرفة أي مجموعة مفتوحة
  Map<int, List<int>> selectedModifier = {};
  /* example: {
  2: [3],
  3: [8,9],
  4: [11]
  } */

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(mealDetailsProvider.notifier)
          .getMealDetails(
            restaurantId: widget.restaurantId,
            mealId: widget.itemId,
          );
    });
  }

  bool _isArabic(String text) {
    return RegExp(r'[\u0600-\u06FF]').hasMatch(text);
  }

  // ── Total price ─────────────────────────────────────────────────────────────
  double _totalPrice() {
    final state = ref.read(mealDetailsProvider);
    double base = 0;

    if (selectedVariantId != -1) {
      final v = state.menuItem.variants.firstWhere(
        (v) => v.id == selectedVariantId,
        orElse: () => state.menuItem.variants.first,
      );
      base = v.price;
    } else if (state.menuItem.variants.isNotEmpty) {
      base = state.menuItem.variants.first.price;
    }

    double extras = 0;
    for (final group in state.menuItem.modifierGroups) {
      final selected = selectedModifier[group.id] ?? [];
      for (final modId in selected) {
        final mod = group.modifiers.firstWhere(
          (m) => m.id == modId,
          orElse: () => group.modifiers.first,
        );
        extras += mod.price;
      }
    }

    return (base + extras) * quantity;
  }

  @override
  Widget build(BuildContext build) {
    final state = ref.watch(mealDetailsProvider);
    final favoritesState = ref.watch(favoritesProvider);

    final bool isLoading = state.status == "loading";
    final isFav = favoritesState.favoriteMeals.any(
      (m) => m.itemId == widget.itemId,
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF8F6F2),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
          decoration: BoxDecoration(
            color: Colors.white,
            border: const Border(top: BorderSide(color: Color(0xFFEDE9E2))),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 16,
                offset: const Offset(0, -4),
              ),
            ],
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Total Price
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Total Price: ',
                        style: TextStyle(
                          color: Color(0xFFFF6B35),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Text(
                      '${_totalPrice().toInt()} SYP',
                      style: const TextStyle(
                        color: Color(0xFFFF6B35),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                // Quantity + Button
                Row(
                  children: [
                    InkWell(
                      onTap: () {
                        if (quantity > 1) {
                          setState(() {
                            quantity--;
                          });
                        }
                      },
                      child: const SizedBox(
                        width: 36,
                        height: 44,
                        child: Icon(
                          Icons.remove,
                          size: 30,
                          color: Color(0xFFFF6B35),
                        ),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Text(
                      quantity.toString(),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF1A1A1A),
                      ),
                    ),
                    const SizedBox(width: 15),
                    InkWell(
                      onTap: () {
                        setState(() {
                          quantity++;
                        });
                      },
                      child: const SizedBox(
                        width: 36,
                        height: 44,
                        child: Icon(
                          Icons.add,
                          size: 30,
                          color: Color(0xFFFF6B35),
                        ),
                      ),
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: SizedBox(
                        height: 54,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFF6B35),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.shopping_cart_outlined,
                                color: Colors.white,
                                size: 18,
                              ),
                              SizedBox(width: 8),
                              Text(
                                "Add to Cart",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
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
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Hero(
                    tag: "meal_${widget.itemId}",
                    child: ClipPath(
                      clipper: CurveClipper(),
                      child: (widget.image != null)
                          ? Image.network(
                              widget.image!,
                              width: double.infinity,
                              height: MediaQuery.of(context).size.height * 0.30,
                              fit: BoxFit.cover,
                            )
                          : Container(
                              width: double.infinity,
                              height: MediaQuery.of(context).size.height * 0.30,
                              color: Colors.grey.shade200,
                              child: Image.asset(
                                "assets/images/meal.jpg",
                                fit: BoxFit.cover,
                              ),
                            ),
                    ),
                  ),

                  Positioned(
                    top: 14,
                    left: 14,
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(color: const Color(0x55FF6B35)),
                        ),
                        //backgroundColor: Colors.grey.shade300,
                        child: const Icon(
                          Icons.arrow_back,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 14,
                    right: 14,
                    child: GestureDetector(
                      onTap: () {
                        ref
                            .read(favoritesProvider.notifier)
                            .toggleMeal(
                              FavoriteMeal(
                                itemId: widget.itemId,
                                restaurantId: widget.restaurantId,
                                name: state.menuItem.name,
                                image: state.menuItem.image,
                                description: state.menuItem.description,
                              ),
                            );
                      },
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(color: const Color(0x55FF6B35)),
                        ),
                        child: Icon(
                          isFav
                              ? Icons.favorite
                              : Icons.favorite_border_rounded,
                          color: Color(0xFFFF6B35),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Skeletonizer(
                enabled: isLoading,
                effect: ShimmerEffect(
                  baseColor: Colors.grey.shade300,
                  highlightColor: Colors.grey.shade100,
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: _isArabic(state.menuItem.name)
                        ? CrossAxisAlignment.end
                        : CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.access_time_rounded,
                            size: 16,
                            color: Color(0xFF1A1A1A),
                          ),
                          SizedBox(width: 4),
                          Text(
                            isLoading ? '--' : state.menuItem.preparationTime,
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF1A1A1A),
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              isLoading ? '...' : state.menuItem.name,
                              textAlign: TextAlign.right,
                              textDirection: TextDirection.rtl,
                              style: const TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF1A1A1A),
                                height: 1.2,
                                shadows: [
                                  Shadow(
                                    color: Color(0x55000000),
                                    blurRadius: 12,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      // الوصف
                      if (state.menuItem.description != null)
                        Text(
                          isLoading
                              ? "loading description ..."
                              : state.menuItem.description!,
                          textDirection: _isArabic(state.menuItem.description!)
                              ? TextDirection.rtl
                              : TextDirection.ltr,
                          textAlign: _isArabic(state.menuItem.description!)
                              ? TextAlign.right
                              : TextAlign.left,
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 14,
                            height: 1.5,
                          ),
                        ),

                      if (state.menuItem.variants.isNotEmpty) ...[
                        const SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: _isArabic(state.menuItem.name)
                              ? MainAxisAlignment.end
                              : MainAxisAlignment.start,
                          children: const [
                            Text(
                              "اختر الحجم",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(width: 6),
                            Icon(
                              Icons.layers_outlined,
                              color: Color(0xFFFF6B35),
                              size: 25,
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: state.menuItem.variants.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount:
                                    state.menuItem.variants.length >= 3
                                    ? 3
                                    : state.menuItem.variants.length,
                                crossAxisSpacing: 8,
                                mainAxisSpacing: 8,
                                childAspectRatio: 1.1,
                              ),
                          itemBuilder: (_, i) {
                            final v = state.menuItem.variants[i];
                            final isOn = selectedVariantId == v.id;
                            final isUnavailable = !v.isAvailable;

                            return Opacity(
                              opacity: isUnavailable ? 0.45 : 1,
                              child: GestureDetector(
                                onTap: isUnavailable
                                    ? null
                                    : () {
                                        setState(() {
                                          selectedVariantId = v.id;
                                        });
                                      },
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  padding: const EdgeInsets.all(2),
                                  decoration: BoxDecoration(
                                    color: isOn
                                        ? Color(0xFFFFF4EF)
                                        : Colors.white,
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: isOn
                                          ? Color(0xFFFF6B35)
                                          : const Color(0xFFEDE9E2),
                                      width: isOn ? 1.8 : 1,
                                    ),
                                    boxShadow: isOn
                                        ? [
                                            BoxShadow(
                                              color: Color(
                                                0xFFFF6B35,
                                              ).withOpacity(0.15),
                                              blurRadius: 12,
                                              offset: const Offset(0, 4),
                                            ),
                                          ]
                                        : null,
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      // Check circle
                                      AnimatedContainer(
                                        duration: const Duration(
                                          milliseconds: 200,
                                        ),
                                        width: 20,
                                        height: 20,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: isOn
                                              ? Color(0xFFFF6B35)
                                              : Colors.transparent,
                                          border: Border.all(
                                            color: isOn
                                                ? Color(0xFFFF6B35)
                                                : const Color(0xFFDDDDDD),
                                            width: 2,
                                          ),
                                        ),
                                        child: isOn
                                            ? const Icon(
                                                Icons.check,
                                                size: 11,
                                                color: Colors.white,
                                              )
                                            : null,
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        v.name,
                                        textAlign: TextAlign.center,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700,
                                          color: isOn
                                              ? const Color(0xFF1A1A1A)
                                              : const Color(0xFF444444),
                                        ),
                                      ),
                                      const SizedBox(height: 3),
                                      Text(
                                        isUnavailable
                                            ? 'غير متوفر'
                                            : '${v.price.toInt()} SYP',
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: isOn
                                              ? FontWeight.w700
                                              : FontWeight.w400,
                                          color: isUnavailable
                                              ? Colors.red.shade400
                                              : isOn
                                              ? Color(0xFFFF6B35)
                                              : const Color(0xFFAAAAAA),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 15),

                        if (state.menuItem.modifierGroups.isNotEmpty)
                          Row(
                            mainAxisAlignment: _isArabic(state.menuItem.name)
                                ? MainAxisAlignment.end
                                : MainAxisAlignment.start,
                            children: const [
                              Text(
                                "اختر الإضافات",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(width: 6),
                              Icon(
                                Icons.layers_outlined,
                                color: Color(0xFFFF6B35),
                                size: 25,
                              ),
                            ],
                          ),
                        const SizedBox(width: 12),
                        Column(
                          children: state.menuItem.modifierGroups.map((group) {
                            final isExpanded = expandedGroup[group.id] ?? false;

                            return Container(
                              margin: const EdgeInsets.only(bottom: 14),

                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: Colors.grey.shade200),
                              ),

                              child: Column(
                                crossAxisAlignment: _isArabic(group.name)
                                    ? CrossAxisAlignment.end
                                    : CrossAxisAlignment.start,
                                children: [
                                  /// HEADER
                                  InkWell(
                                    borderRadius: BorderRadius.circular(20),

                                    onTap: () {
                                      setState(() {
                                        expandedGroup[group.id] = !isExpanded;
                                      });
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(16),
                                      child: Row(
                                        textDirection: TextDirection.rtl,
                                        children: [
                                          Expanded(
                                            child: Row(
                                              mainAxisAlignment:
                                                  _isArabic(group.name)
                                                  ? MainAxisAlignment.end
                                                  : MainAxisAlignment.start,
                                              children: [
                                                AnimatedRotation(
                                                  duration: const Duration(
                                                    milliseconds: 200,
                                                  ),

                                                  turns: isExpanded ? 0.5 : 0,

                                                  child: const Icon(
                                                    Icons.keyboard_arrow_down,
                                                  ),
                                                ),
                                                const SizedBox(height: 4),

                                                Container(
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        horizontal: 8,
                                                        vertical: 2,
                                                      ),
                                                  decoration: BoxDecoration(
                                                    color: group.isRequired
                                                        ? const Color(
                                                            0xFFFFF0EE,
                                                          )
                                                        : const Color(
                                                            0xFFF2F0EB,
                                                          ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          10,
                                                        ),
                                                  ),
                                                  child: Text(
                                                    group.isRequired
                                                        ? "مطلوب"
                                                        : "اختياري",

                                                    style: TextStyle(
                                                      color: group.isRequired
                                                          ? Colors.red
                                                          : Colors.grey,

                                                      fontSize: 13,
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    group.name,
                                                    textDirection:
                                                        _isArabic(group.name)
                                                        ? TextDirection.rtl
                                                        : TextDirection.ltr,
                                                    textAlign:
                                                        _isArabic(group.name)
                                                        ? TextAlign.right
                                                        : TextAlign.left,
                                                    style: const TextStyle(
                                                      fontSize: 17,
                                                      fontWeight:
                                                          FontWeight.bold,
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

                                  // options
                                  if (isExpanded)
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        left: 16,
                                        right: 16,
                                        bottom: 16,
                                      ),
                                      child: Column(
                                        children: group.modifiers.map((
                                          modifier,
                                        ) {
                                          final selected =
                                              selectedModifier[group.id]
                                                  ?.contains(modifier.id) ??
                                              false;
                                          return InkWell(
                                            onTap: () {
                                              setState(() {
                                                selectedModifier.putIfAbsent(
                                                  group.id,
                                                  () => [],
                                                );
                                                // if multiple
                                                if (group.isMultiple) {
                                                  if (selected) {
                                                    selectedModifier[group.id]!
                                                        .remove(modifier.id);
                                                  } else {
                                                    if (selectedModifier[group
                                                                .id]!
                                                            .length <
                                                        group.maxSelections) {
                                                      selectedModifier[group
                                                              .id]!
                                                          .add(modifier.id);
                                                    }
                                                  }
                                                }
                                                // if Single
                                                else {
                                                  selectedModifier[group.id] = [
                                                    modifier.id,
                                                  ];
                                                }
                                              });
                                            },
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    vertical: 12,
                                                  ),
                                              child: Row(
                                                textDirection:
                                                    TextDirection.rtl,
                                                children: [
                                                  /// ICON
                                                  group.isMultiple
                                                      ? Checkbox(
                                                          value: selected,
                                                          onChanged: (value) {
                                                            {
                                                              setState(() {
                                                                selectedModifier
                                                                    .putIfAbsent(
                                                                      group.id,
                                                                      () => [],
                                                                    );

                                                                if (selected) {
                                                                  selectedModifier[group
                                                                          .id]!
                                                                      .remove(
                                                                        modifier
                                                                            .id,
                                                                      );
                                                                } else {
                                                                  if (selectedModifier[group
                                                                              .id]!
                                                                          .length <
                                                                      group
                                                                          .maxSelections) {
                                                                    selectedModifier[group
                                                                            .id]!
                                                                        .add(
                                                                          modifier
                                                                              .id,
                                                                        );
                                                                  }
                                                                }
                                                              });
                                                            }
                                                          },
                                                        )
                                                      : Radio<int>(
                                                          value: modifier.id,

                                                          groupValue:
                                                              selectedModifier[group
                                                                          .id]
                                                                      ?.isNotEmpty ==
                                                                  true
                                                              ? selectedModifier[group
                                                                        .id]!
                                                                    .first
                                                              : null,

                                                          onChanged: (value) {
                                                            setState(() {
                                                              selectedModifier[group
                                                                  .id] = [
                                                                modifier.id,
                                                              ];
                                                            });
                                                          },
                                                        ),
                                                  Text(modifier.name),

                                                  if (modifier.price > 0)
                                                    Expanded(
                                                      child: Text(
                                                        "+${modifier.price.toInt()} SYP",
                                                        style: const TextStyle(
                                                          color: Color(
                                                            0xFFFF6B35,
                                                          ),
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                ],
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ],
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
