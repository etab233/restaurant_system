// ignore_for_file: deprecated_member_use, depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurants_system/constants.dart';
import 'package:restaurants_system/providers/restaurant_provider.dart';
import 'package:restaurants_system/view/restaurant_screen/build_row.dart';

class RestaurantScreen extends ConsumerStatefulWidget {
  final int restaurantId;
  const RestaurantScreen({super.key, required this.restaurantId});

  @override
  ConsumerState<RestaurantScreen> createState() => _RestaurantScreenState();
}

class _RestaurantScreenState extends ConsumerState<RestaurantScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(restaurantProvider.notifier).viewRestaurant(widget.restaurantId);
    });
  }

  String formatPhoneNumber(String phone) {
    String cleanPhone = phone.replaceAll(RegExp(r'\s+'), '');
    return cleanPhone.replaceFirstMapped(
      RegExp(r'^(\+963)(\d{3})(\d{3})(\d{3})$'),
      (m) => '${m[1]} ${m[2]} ${m[3]} ${m[4]}',
    );
  }

  String formatTime(String time) {
    final parsedTime = DateFormat('HH:mm:ss').parse(time);
    return DateFormat('hh:mm a').format(parsedTime);
  }

  @override
  Widget build(BuildContext context) {
    final restaurantState = ref.watch(restaurantProvider);
    final length = restaurantState.categories?.length;
    return DefaultTabController(
      length: length ?? 0,
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: restaurantState.isLoading
            ? const Center(child: CircularProgressIndicator())
            : restaurantState.status == "success"
            ? CustomScrollView(
                slivers: [
                  SliverAppBar(
                    automaticallyImplyLeading: false,
                    backgroundColor: Theme.of(context).colorScheme.background,
                    pinned: true,
                    expandedHeight: 370,
                    elevation: 0,
                    leading: IconButton(
                      icon: Container(
                        padding: EdgeInsets.only(left: 10),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Theme.of(
                            context,
                          ).colorScheme.background.withAlpha(200),
                        ),
                        child: Center(
                          child: Icon(
                            Icons.arrow_back_ios,
                            color: Theme.of(context).colorScheme.onBackground,
                          ),
                        ),
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                    flexibleSpace: FlexibleSpaceBar(
                      background: Container(
                        child: Stack(
                          children: [
                            Positioned.fill(
                              child: Column(
                                children: [
                                  Image.network(
                                    height: 170,
                                    width: double.infinity,
                                    restaurantState.restaurant!.coverImage!,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Image.network(
                                        height: 170,
                                        width: double.infinity,
                                        "restaurantState.restaurant!.coverImage!",
                                        fit: BoxFit.cover,
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                            Positioned(
                              top: 140,
                              left: 10,
                              right: 10,
                              child: Container(
                                // height: 210,
                                margin: EdgeInsets.all(2),
                                padding: const EdgeInsets.only(
                                  left: 15,
                                  right: 20,
                                  bottom: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.surface,
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black45,
                                      blurRadius: 5,
                                      offset: Offset(0, 1),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      height: 40,
                                      padding: EdgeInsets.only(top: 5),
                                      child: Text(
                                        (restaurantState.restaurant?.name)!,
                                        // "Restaurant Name",
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.onBackground,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.only(top: 10),
                                      child: Text(
                                        (restaurantState
                                            .restaurant
                                            ?.description)!,
                                        // "lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
                                        maxLines: 1,
                                        softWrap: true,
                                        style: TextStyle(
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.onSurface,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        buildRow(
                                          context,
                                          Icons.location_on,
                                          (restaurantState
                                              .restaurant
                                              ?.address)!,
                                        ),
                                        const SizedBox(height: 10),
                                        buildRow(
                                          context,
                                          Icons.access_time,
                                          "${formatTime((restaurantState.restaurant?.hours.opens)!)} - ${formatTime((restaurantState.restaurant?.hours.closes)!)}",
                                        ),
                                        const SizedBox(height: 10),
                                        buildRow(
                                          context,
                                          Icons.phone,
                                          formatPhoneNumber(
                                            (restaurantState
                                                .restaurant
                                                ?.phone)!,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 8),
                                  ],
                                ),
                              ),
                            ),
                            Positioned(
                              top: 110,
                              right: 30,
                              child: CircleAvatar(
                                radius: 40,
                                backgroundColor: const Color.fromARGB(
                                  255,
                                  243,
                                  87,
                                  15,
                                ),
                                child: Stack(
                                  children: [
                                    CircleAvatar(
                                      radius: 35,
                                      backgroundImage: NetworkImage(
                                        restaurantState.restaurant!.logo!,
                                      ),
                                    ),
                                    if (restaurantState
                                        .restaurant!
                                        .hours
                                        .isOpen)
                                      Positioned(
                                        right: 2,
                                        bottom: 2,
                                        child: Container(
                                          width: 15,
                                          height: 15,
                                          decoration: BoxDecoration(
                                            color: Colors.green,
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
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    bottom: PreferredSize(
                      preferredSize: Size.fromHeight(50),
                      child: Container(
                        color: Theme.of(context).colorScheme.background,
                        child: Column(
                          children: [
                            TabBar(
                              isScrollable: true,
                              padding: EdgeInsets.symmetric(vertical: 10),
                              indicatorPadding: EdgeInsets.only(bottom: -10),
                              tabAlignment: TabAlignment.start,
                              indicatorColor: Theme.of(
                                context,
                              ).colorScheme.primary,
                              labelColor: Theme.of(context).colorScheme.primary,
                              unselectedLabelColor: Colors.grey,
                              dividerColor: Theme.of(
                                context,
                              ).colorScheme.background,
                              tabs: [
                                for (var category
                                    in restaurantState.categories!)
                                  Text(category.name),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // SliverList(
                  // delegate: SliverChildListDelegate([

                  // ]),
                  // ),
                  // SliverPersistentHeader(
                  //   delegate: MyTabsDelegate(
                  // child:
                  // ),
                  // ),
                  SliverFillRemaining(
                    child: TabBarView(
                      children: restaurantState.categories!.map((category) {
                        if (category.menuItems == null ||
                            category.menuItems!.isEmpty) {
                          return Center(child: Text("No meals available"));
                        }
                        return ListView.builder(
                          padding: EdgeInsets.only(top: 10),
                          itemCount: category.menuItems!.length,
                          itemBuilder: (context, index) {
                            final meal = category.menuItems![index];
                            return Container(
                              padding: EdgeInsets.all(10),
                              margin: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.surface,
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black45,
                                    blurRadius: 2,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  ListTile(
                                    leading: Stack(
                                      children: [
                                        CircleAvatar(
                                          radius: 30,
                                          backgroundImage: NetworkImage(
                                            meal.image!,
                                          ),
                                        ),
                                        if (meal.is_featured)
                                          Positioned(
                                            top: 0,
                                            right: 0,
                                            child: Container(
                                              padding: EdgeInsets.all(1),
                                              decoration: BoxDecoration(
                                                color: Theme.of(
                                                  context,
                                                ).colorScheme.onPrimary,
                                                shape: BoxShape.circle,
                                              ),
                                              child: Icon(
                                                Icons.verified,
                                                color: Colors.amber,
                                                size: 18,
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                    title: Text(
                                      meal.name,
                                      style: TextStyle(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.onSurface,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12,
                                      ),
                                    ),
                                    subtitle: Padding(
                                      padding: const EdgeInsets.only(top: 5),
                                      child: Text(
                                        meal.description,
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.onSurface,
                                        ),
                                      ),
                                    ),
                                    trailing: Text(
                                      "${meal.price} \$",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.green,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Color(
                                            Constants.orangeColor,
                                          ),
                                        ),
                                        onPressed: () {},
                                        child: Text(
                                          "Meal Analysis",
                                          style: TextStyle(
                                            color: Theme.of(
                                              context,
                                            ).colorScheme.onPrimary,
                                            fontSize: 10,
                                          ),
                                        ),
                                      ),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Color(
                                            Constants.orangeColor,
                                          ),
                                        ),
                                        onPressed: () {},
                                        child: Text(
                                          "Order Meal",
                                          style: TextStyle(
                                            color: Theme.of(
                                              context,
                                            ).colorScheme.onPrimary,
                                            fontSize: 10,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      }).toList(),
                    ),
                  ),
                ],
              )
            : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(restaurantState.message!),
                    SizedBox(height: 10),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                      ),
                      onPressed: () {
                        ref
                            .watch(restaurantProvider.notifier)
                            .viewRestaurant(widget.restaurantId);
                      },
                      child: Text(
                        "Try Again",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary,
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
