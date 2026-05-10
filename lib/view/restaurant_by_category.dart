import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurants_system/models/restaurant.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:restaurants_system/providers/restaurant_by_category.dart';

class RestaurantByCategory extends ConsumerStatefulWidget {
  const RestaurantByCategory({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _RestaurantByCategoryState();
}

class _RestaurantByCategoryState extends ConsumerState<RestaurantByCategory> {
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(RestaurantListProvider.notifier).fetchRestaurantsByCategory(2);
    });
  }

  String Category = "Soft Drinks";
  int toMinutes(String time) {
    final format = DateFormat("hh:mm a");
    final dt = format.parse(time);
    return dt.hour * 60 + dt.minute;
  }

  bool isOpen(String openingTime, String closingTime) {
    final now = DateTime.now();
    final nowMinutes = now.hour * 60 + now.minute;

    final open = toMinutes(openingTime);
    final close = toMinutes(closingTime);

    if (open < close) {
      return nowMinutes >= open && nowMinutes <= close;
    }

    return nowMinutes >= open || nowMinutes <= close;
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(RestaurantListProvider);
    List<Restaurant> restaurants = state.restaurants;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFFF6347),
        title: Text(
          "$Category",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
        ),
      ),
      body: state.isLoading
          ? Center(child: CircularProgressIndicator())
          : state.status == "success" && restaurants.isNotEmpty
          ? ListView.builder(
              itemCount: restaurants.length,
              itemBuilder: (context, index) {
                final restaurant = restaurants[index];
                return Card(
                  color: Color.fromARGB(255, 245, 245, 245),
                  shadowColor: Colors.black,
                  elevation: 7,
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      children: [
                        Stack(
                          children: [
                            CircleAvatar(
                              radius: 35,
                              backgroundImage: NetworkImage(restaurant.logo),
                            ),
                            Positioned(
                              right: 2,
                              bottom: 2,
                              child: Container(
                                width: 15,
                                height: 15,
                                decoration: BoxDecoration(
                                  color:
                                      isOpen(
                                        restaurant.openingTime,
                                        restaurant.closingTime,
                                      )
                                      ? Colors.green
                                      : Colors.red,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 2,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              restaurant.name,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 5),
                            Container(
                              width: 200,
                              // color: Colors.amber,
                              child: Text(
                                restaurant.description,
                                softWrap: true,
                                maxLines: 2,
                                style: TextStyle(
                                  fontSize: 11,
                                  color: const Color.fromARGB(
                                    255,
                                    114,
                                    108,
                                    108,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 5),
                            Row(
                              children: [
                                Text(
                                  "Rating:",
                                  style: TextStyle(
                                    color: const Color.fromARGB(
                                      255,
                                      114,
                                      108,
                                      108,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 5),
                                RatingBarIndicator(
                                  itemBuilder: (context, index) =>
                                      Icon(Icons.star, color: Colors.amber),
                                  unratedColor: Colors.grey[400],
                                  itemCount: 5,
                                  itemSize: 17.0,
                                  // rating: restaurant.rating.toDouble(),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Spacer(),
                        IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.arrow_forward_ios),
                        ),
                      ],
                    ),
                  ),
                );
              },
            )
          : Center(child: Text("${state.message}")),
    );
  }
}
