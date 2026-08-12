// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurants_system/core/enums/meal_details_mode.dart';
import 'package:restaurants_system/core/navigation/main_tabs.dart';
import 'package:restaurants_system/features/auth/presentation/providers/auth_provider.dart';
import 'package:restaurants_system/features/favorites/data/models/favorite_meal_model.dart';
import 'package:restaurants_system/features/favorites/presentation/providers/favorite_notifier.dart';
import 'package:restaurants_system/features/cart/presentation/providers/cart_provider.dart';
import 'package:restaurants_system/features/meal_details/presentation/providers/meal_details_notifier.dart';
import 'package:restaurants_system/features/meal_details/presentation/providers/meal_details_state.dart';
import 'package:restaurants_system/features/meal_details/presentation/widgets/meal_details_section.dart';
import 'package:restaurants_system/features/meal_details/presentation/widgets/nutrition_section.dart';
import 'package:restaurants_system/features/navigation/presentation/providers/bottom_navigation_bar_provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 22);

    path.quadraticBezierTo(
      size.width * 0.25,
      size.height,
      size.width * 0.50,
      size.height - 12,
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
  final MealDetailsMode mode;

  const MealDetails({
    super.key,
    this.image,
    required this.itemId,
    required this.restaurantId,
    required this.mode,
  });
  @override
  ConsumerState<MealDetails> createState() => MealDetailsState();
}

class MealDetailsState extends ConsumerState<MealDetails> {
  final GlobalKey _addBtnKey = GlobalKey();
  final TextEditingController _noteController = TextEditingController();
  Map<int, bool> expandedGroup = {};

  bool _showMiniCartBar = false;
  int _selectedTab = 0;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      switch (widget.mode) {
        case MealDetailsMode.create:
          ref
              .read(mealDetailsProvider.notifier)
              .getMealDetails(
                restaurantId: widget.restaurantId,
                mealId: widget.itemId,
              );
          break;

        case MealDetailsMode.edit:
          ref
              .read(mealDetailsProvider.notifier)
              .getCartMealDetails(itemId: widget.itemId);
          break;
      }
    });
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  bool _isArabic(String text) {
    return RegExp(r'[\u0600-\u06FF]').hasMatch(text);
  }

  void _goToCart() {
    Navigator.of(context).popUntil((route) => route.isFirst);
    ref.read(bottomNavbarProvider.notifier).setTab(MainTab.cart);
  }

  Widget _buildMiniCartBar() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFFF6B35),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFF6B35).withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.shopping_cart_rounded,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              "Item added to cart",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
          TextButton(
            onPressed: _goToCart,
            style: TextButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: const Color(0xFFFF6B35),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "View Cart",
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                ),
                SizedBox(width: 4),
                Icon(Icons.arrow_forward_ios_rounded, size: 12),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTab({
    required String title,
    required IconData icon,
    required int index,
  }) {
    final selected = _selectedTab == index;

    return GestureDetector(
      onTap: () {
        if (_selectedTab == index) return;

        setState(() {
          _selectedTab = index;
        });
      },
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
        padding: const EdgeInsets.only(top: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedScale(
                  scale: selected ? 1.05 : 1.0,
                  duration: const Duration(milliseconds: 200),
                  child: Icon(
                    icon,
                    size: 20,
                    color: selected
                        ? const Color(0xFFFF6B35)
                        : const Color(0xFF8A8A8A),
                  ),
                ),
                const SizedBox(width: 7),
                AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 200),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: selected ? FontWeight.w800 : FontWeight.w500,
                    color: selected
                        ? const Color(0xFFFF6B35)
                        : const Color(0xFF8A8A8A),
                  ),
                  child: Text(title),
                ),
              ],
            ),

            const SizedBox(height: 10),

            // الخط الموجود تحت الـ Tab
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOut,
              height: 3,
              width: selected ? MediaQuery.of(context).size.width * 40 : 0,
              decoration: BoxDecoration(
                color: const Color(0xFFFF6B35),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext build) {
    final state = ref.watch(mealDetailsProvider);
    final notifier = ref.read(mealDetailsProvider.notifier);
    final favoritesState = ref.watch(favoritesProvider);
    final cartState = ref.watch(cartNotifierProvider);
    final authState = ref.watch(authNotifierProvider);

    final int selectedVariantId = state.selectedVariantId;
    final int quantity = state.quantity;
    final Map<int, List<int>> selectedModifier = state.selectedModifier;

    ref.listen<MealState>(mealDetailsProvider, (previous, next) {
      final wasLoading = previous == null || previous.status == "loading";
      final justLoaded = wasLoading && next.status != "loading";
      if (justLoaded && _noteController.text != next.note) {
        _noteController.text = next.note;
      }
    });

    final bool isLoading = state.status == "loading";
    final isFav = favoritesState.favoriteMeals.any(
      (m) => m.itemId == widget.itemId,
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      bottomNavigationBar: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedSlide(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
              offset: _showMiniCartBar ? Offset.zero : const Offset(0, 1),
              child: _showMiniCartBar
                  ? _buildMiniCartBar()
                  : const SizedBox.shrink(),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
              decoration: BoxDecoration(
                color: Colors.white,
                border: const Border(top: BorderSide(color: Color(0xFFF5F5F5))),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 16,
                    offset: const Offset(0, -4),
                  ),
                ],
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(24),
                ),
              ),
              child: Padding(
                padding:const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
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
                          '${state.totalPrice.toInt()} SYP',
                          style: const TextStyle(
                            color: Color(0xFFFF6B35),
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        InkWell(
                          onTap: notifier.decrementQuantity,
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
                          onTap: notifier.incrementQuantity,
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
                              key: _addBtnKey,
                              onPressed: () async {
                                if (!mounted) return;

                                final cartState = ref.read(
                                  cartNotifierProvider,
                                );

                                if (cartState.status == "unauthenticated") {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text("Please login first"),
                                    ),
                                  );
                                  return;
                                }

                                if (selectedVariantId == -1 &&
                                    state.menuItem.variants.isNotEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      margin: EdgeInsets.all(10),
                                      behavior: SnackBarBehavior.floating,
                                      content: Text('يرجى اختيار حجم الوجبة'),
                                    ),
                                  );
                                  return;
                                }

                                for (final group
                                    in state.menuItem.modifierGroups) {
                                  if (group.isRequired) {
                                    final selected = selectedModifier[group.id];
                                    if (selected == null || selected.isEmpty) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            "يرجى اختيار ${group.name}",
                                          ),
                                        ),
                                      );
                                      return;
                                    }
                                  }
                                }

                                final List<Map<String, dynamic>>
                                modifierSelections = [];
                                selectedModifier.forEach((
                                  groupId,
                                  modifierIds,
                                ) {
                                  for (final modifierId in modifierIds) {
                                    modifierSelections.add({
                                      "modifier_group_id": groupId,
                                      "modifier_id": modifierId,
                                    });
                                  }
                                });

                                if (widget.mode == MealDetailsMode.create) {
                                  await ref
                                      .read(cartNotifierProvider.notifier)
                                      .addToCart(
                                        restaurantId: widget.restaurantId
                                            .toString(),
                                        itemId: widget.itemId.toString(),
                                        variantId: selectedVariantId == -1
                                            ? null
                                            : selectedVariantId.toString(),
                                        quantity: quantity,
                                        description: state.note,
                                        modifierSelections: modifierSelections,
                                      );
                                } else {
                                  await ref
                                      .read(cartNotifierProvider.notifier)
                                      .editAndAddToCart(
                                        restaurantId: widget.restaurantId
                                            .toString(),
                                        itemId: state.menuItem.itemId
                                            .toString(),
                                        variantId: selectedVariantId == -1
                                            ? null
                                            : selectedVariantId.toString(),
                                        quantity: quantity,
                                        description: state.note,
                                        modifierSelections: modifierSelections,
                                        cartId: state.menuItem.cartId!,
                                      );
                                }
                                if (!mounted) return;

                                final newState = ref.read(cartNotifierProvider);
                                if (newState.status == "success") {
                                  if (!_showMiniCartBar) {
                                    setState(() => _showMiniCartBar = true);
                                  }
                                } else if (newState.status == "error") {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      margin: const EdgeInsets.all(10),
                                      behavior: SnackBarBehavior.floating,
                                      backgroundColor: Colors.red.shade600,
                                      content:const Text(
                                        "حدث خطأ، يرجى المحاولة مرة أخرى",
                                      ),
                                    ),
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFFF6B35),
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              child: (cartState.isAddingToCart)
                                  ? const SizedBox(
                                      width: 22,
                                      height: 22,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2.5,
                                      ),
                                    )
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Icon(
                                          Icons.shopping_cart_outlined,
                                          color: Colors.white,
                                          size: 20,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          authState.isLoggedIn
                                              ? "Add to Cart"
                                              : "Log in to add",
                                          style:const TextStyle(
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
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // ═══ ثابت: الصورة + رجوع/مفضلة ═══
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
                            height: MediaQuery.of(context).size.height * 0.28,
                            fit: BoxFit.cover,
                          )
                        : Container(
                            width: double.infinity,
                            height: MediaQuery.of(context).size.height * 0.28,
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
                      child: const Icon(Icons.arrow_back, color: Colors.black),
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
                        isFav ? Icons.favorite : Icons.favorite_border_rounded,
                        color: const Color(0xFFFF6B35),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // ═══ ثابت: اسم الوجبة + الوقت + الوصف ═══
            Skeletonizer(
              enabled: isLoading,
              effect: ShimmerEffect(
                baseColor: Colors.grey.shade300,
                highlightColor: Colors.grey.shade100,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                child: Column(
                  crossAxisAlignment: _isArabic(state.menuItem.name)
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.access_time_rounded,
                          size: 16,
                          color: Color(0xFF1A1A1A),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          isLoading ? '--' : state.menuItem.preparationTime,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF1A1A1A),
                          ),
                        ),
                        const SizedBox(width: 10),
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
                    const SizedBox(height: 8),
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
                        style: const TextStyle(
                          color: Colors.black87,
                          fontSize: 14,
                          height: 1.5,
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),

            // ═══ ثابت: Tabs bar ═══
            Container(
              margin: const EdgeInsets.fromLTRB(20, 0, 20, 8),
              child: Row(
                children: [
                  Expanded(
                    child: _buildTab(
                      title: 'Order Details',
                      icon: Icons.restaurant_outlined,
                      index: 0,
                    ),
                  ),
                  Expanded(
                    child: _buildTab(
                      title: 'Nutrition',
                      icon: Icons.lunch_dining_rounded,
                      index: 1,
                    ),
                  ),
                ],
              ),
            ),

            // ═══ المنطقة الوحيدة القابلة للسكرول ═══
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                child: _selectedTab == 0
                    ? const MealDetailsSection(key: ValueKey('details'))
                    : NutritionSection(
                        key: const ValueKey('nutrition'),
                        restaurantId: widget.restaurantId,
                        isNutritionallyAnalyzed:
                            state.menuItem.isNutritionallyAnalyzed,
                        menuItemId: widget.itemId,
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
