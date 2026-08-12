import 'package:flutter/material.dart';
import 'package:restaurants_system/features/meal_details/data/models/meal_item_model.dart';
import 'package:restaurants_system/features/restaurant_menu/presentation/widgets/meal_card.dart';
import 'package:restaurants_system/core/utils/search_utils.dart';

class MealSearchDelegate extends SearchDelegate<MealItem> {
  final List<MealItem> meals;

  MealSearchDelegate(this.meals);

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () => Navigator.of(context).pop(),
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: const Icon(Icons.clear),
      ),
    ];
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query.isEmpty) {
      return Center(
        child: Image.asset(
          "assets/images/search_meal.jpg",
          fit: BoxFit.fitWidth,
          width: double.infinity,
        ),
      );
    }

    final results = meals.map((meal) {
      final score = SearchUtils.mealScore(meal.name, query);
      return MapEntry(meal, score);
    }).toList()..sort((a, b) => b.value.compareTo(a.value));

    final filteredResults = results.where((e) => e.value > 0.4).toList();

    if (results.isEmpty) {
      return Center(
        child: SizedBox(
          child: Image.asset(
            "assets/images/error_search.jpg",
            width: MediaQuery.of(context).size.width * 0.85,
            height: MediaQuery.of(context).size.height * 0.50,
            fit: BoxFit.cover,
          ),
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: filteredResults.length,
      itemBuilder: (context, index) {
        return MealCard(
          meal: filteredResults[index].key,
          primaryColor: const Color(0xFFFF6B35),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return Center(
        child: SizedBox(
          child: Image.asset(
            "assets/images/search_meal.jpg",
            width: MediaQuery.of(context).size.width * 0.85,
            height: MediaQuery.of(context).size.height * 0.50,
            fit: BoxFit.cover,
          ),
        ),
      );
    }

    final suggestions = meals.map((meal) {
      final score = SearchUtils.mealScore(meal.name, query);
      return MapEntry(meal, score);
    }).toList()..sort((a, b) => b.value.compareTo(a.value));

    if (suggestions.isEmpty) {
      return Center(
        child: SizedBox(
          child: Image.asset(
            "assets/images/error_search.jpg",
            width: MediaQuery.of(context).size.width * 0.85,
            height: MediaQuery.of(context).size.height * 0.50,
            fit: BoxFit.cover,
          ),
        ),
      );
    }

    final filteredSuggestions = suggestions
        .where((e) => e.value > 0.4)
        .take(6)
        .toList();

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: filteredSuggestions.length,
      itemBuilder: (context, index) {
        return MealCard(
          meal: filteredSuggestions[index].key,
          primaryColor: const Color(0xFFFF6B35),
        );
      },
    );
  }
}
