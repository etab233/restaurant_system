// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurants_system/providers/home_provider.dart';
import 'package:restaurants_system/view/categories/category_card.dart';
import 'package:restaurants_system/view/restaurant_by_category.dart';

class CategoriesList extends ConsumerWidget {
  const CategoriesList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = ref.watch(homeProvider).categories;
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Column(
            children: [
              _Header(),
              Divider(color: colors.outline.withOpacity(0.3), thickness: 1),
              Expanded(child: _CategoriesGrid(categories: categories)),
            ],
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Row(
      children: [
        Text(
          "All Categories",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: colors.onSurface,
          ),
        ),
        const Spacer(),
        IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: colors.surface,
              border: Border.all(color: colors.outline.withOpacity(0.3)),
            ),
            child: Icon(Icons.close, size: 18, color: colors.onSurface,),
          ),
        ),
      ],
    );
  }
}

class _CategoriesGrid extends StatelessWidget {
  final List categories;

  const _CategoriesGrid({required this.categories});

  @override
  Widget build(BuildContext context) {

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 5,
        mainAxisSpacing: 10,
        childAspectRatio: 0.8,
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];

        return CategoryIconCard(
          name: category.name,
          imgUrl: category.image,
          onTap: () {
            // لاحقاً: فلتر المطاعم بهيدا التصنيف
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => RestaurantByCategory(
                  categoryId: category.id,
                  categoryName: category.name,
                ),
              ),
            );
          },
        );
      },
    );
  }
}
