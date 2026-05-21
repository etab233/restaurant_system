// ignore_for_file: deprecated_member_use, unnecessary_import

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:restaurants_system/models/restaurant_model.dart';
import 'package:restaurants_system/providers/restaurant_by_category.dart';
import 'package:restaurants_system/view/restaurant_screen/restaurant_screen.dart';

class RestaurantByCategory extends ConsumerStatefulWidget {
  final int categoryId;
  final String categoryName;
  const RestaurantByCategory({
    super.key,
    required this.categoryId,
    required this.categoryName,
  });
  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _RestaurantByCategoryState();
}

class _RestaurantByCategoryState extends ConsumerState<RestaurantByCategory> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(RestaurantListProvider.notifier)
          .fetchRestaurantsByCategory(widget.categoryId);
    });
  }

  // int toMinutes(String time) {
  //   final format = DateFormat("hh:mm a");
  //   final dt = format.parse(time);
  //   return dt.hour * 60 + dt.minute;
  // }

  // bool isOpen(String openingTime, String closingTime) {
  //   final now = DateTime.now();
  //   final nowMinutes = now.hour * 60 + now.minute;

  //   final open = toMinutes(openingTime);
  //   final close = toMinutes(closingTime);

  //   if (open < close) {
  //     return nowMinutes >= open && nowMinutes <= close;
  //   }

  //   return nowMinutes >= open || nowMinutes <= close;
  // }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(RestaurantListProvider);
    List<RestaurantModel> restaurants = state.restaurants;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(
          widget.categoryName,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
      ),
      body: state.isLoading
          ? Center(child: CircularProgressIndicator())
          : state.status == "success" && restaurants.isNotEmpty
          ? ListView.builder(
              itemCount: restaurants.length,
              itemBuilder: (context, index) {
                final restaurant = restaurants[index];
                return Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.background,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 5,
                          offset: Offset(0, 1),
                          // color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ],
                    ),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(15),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                RestaurantScreen(restaurantId: restaurant.id),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          children: [
                            Stack(
                              children: [
                                CircleAvatar(
                                  radius: 35,
                                  backgroundImage: NetworkImage(
                                    restaurant.logo!,
                                  ),
                                ),
                                Positioned(
                                  right: 2,
                                  bottom: 2,
                                  child: Container(
                                    width: 15,
                                    height: 15,
                                    decoration: BoxDecoration(
                                      color:
                                          state.restaurants[index].hours.isOpen
                                          ? Colors.green
                                          : null,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.onPrimary,
                                        width: 2,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(width: 15),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    restaurant.name,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    restaurant.description,
                                    style: TextStyle(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onSurface,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(height: 4),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        "Rating:",
                                        style: TextStyle(
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.onSurface,
                                        ),
                                      ),
                                      SizedBox(width: 5),
                                      RatingBarIndicator(
                                        itemBuilder: (context, index) => Icon(
                                          Icons.star,
                                          color: Colors.amber,
                                        ),
                                        unratedColor: Colors.grey,
                                        itemCount: 5,
                                        itemSize: 17.0,
                                        // rating: restaurant.rating.toDouble(),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Icon(Icons.arrow_forward_ios),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            )
          : Center(child: Text("${state.message}")),
    );
  }
}
