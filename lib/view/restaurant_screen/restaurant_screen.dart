import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurants_system/constants.dart';
import 'package:restaurants_system/providers/restaurant_provider.dart';
import 'package:restaurants_system/view/restaurant_screen/buildRow.dart';
import 'package:restaurants_system/view/restaurant_screen/tabBar_content.dart';

class RestaurantScreen extends ConsumerStatefulWidget {
  const RestaurantScreen({super.key});

  @override
  ConsumerState<RestaurantScreen> createState() => _RestaurantScreenState();
}

class _RestaurantScreenState extends ConsumerState<RestaurantScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(restaurantProvider.notifier).viewRestaurant(1);
      ref.read(categoryProvider.notifier).fetchCategory(0);
    });
  }

  String formatPhoneNumber(String phone) {
    String cleanPhone = phone.replaceAll(RegExp(r'\s+'), '');
    return cleanPhone.replaceFirstMapped(
      RegExp(r'^(\+963)(\d{3})(\d{3})(\d{3})$'),
      (m) => '${m[1]} ${m[2]} ${m[3]} ${m[4]}',
    );
  }

  @override
  Widget build(BuildContext context) {
    final restaurantState = ref.watch(restaurantProvider);
    final length = restaurantState.categories?.length;
    final categoryState = ref.watch(categoryProvider);
    return DefaultTabController(
      length: length ?? 0,
      child: Scaffold(
        body: restaurantState.isLoading
            ? const Center(child: CircularProgressIndicator())
            : restaurantState.status == "success"
            ? CustomScrollView(
                slivers: [
                  SliverAppBar(
                    automaticallyImplyLeading: false,
                    backgroundColor: Colors.white,
                    pinned: true,
                    expandedHeight: 390,
                    elevation: 0,
                    leading: IconButton(
                      icon: Container(
                        padding: EdgeInsets.only(left: 10),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withAlpha(200),
                        ),
                        child: Center(
                          child: Icon(
                            Icons.arrow_back_ios,
                            color: Colors.black,
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
                                    restaurantState.restaurant!.cover_image,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Image.asset(
                                        height: 170,
                                        width: double.infinity,
                                        "assets/images/cover.png",
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
                                  left: 10,
                                  right: 20,
                                  bottom: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color.fromARGB(90, 0, 0, 0),
                                      blurRadius: 10,
                                      offset: Offset(0, 5),
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
                                          color: Colors.black54,
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
                                          Icons.location_on,
                                          (restaurantState
                                              .restaurant
                                              ?.address)!,
                                        ),
                                        const SizedBox(height: 8),
                                        buildRow(
                                          Icons.alternate_email,
                                          (restaurantState.restaurant?.email)!,
                                        ),
                                        const SizedBox(height: 8),

                                        buildRow(
                                          Icons.access_time,
                                          "${(restaurantState.restaurant?.openingTime)!} - ${(restaurantState.restaurant?.closingTime)!}",
                                        ),
                                        const SizedBox(height: 8),
                                        buildRow(
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
                                        restaurantState.restaurant!.logo,
                                      ),
                                    ),
                                    if (restaurantState.restaurant!.isOpen)
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
                                              color: Colors.white,
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
                        color: Colors.white,
                        child: TabBar(
                          isScrollable: true,
                          padding: EdgeInsets.symmetric(vertical: 10),
                          indicatorPadding: EdgeInsets.only(bottom: -10),
                          tabAlignment: TabAlignment.start,
                          indicatorColor: Color(Constants.orangeColor),
                          labelColor: Color(Constants.orangeColor),
                          unselectedLabelColor: Colors.grey,
                          tabs: [
                            for (var category in restaurantState.categories!)
                              Text(category.name),
                          ],
                          onTap: (index) {
                            ref
                                .watch(categoryProvider.notifier)
                                .fetchCategory(index);
                          },
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
                    child: categoryState.isLoading
                        ? Center(child: CircularProgressIndicator())
                        : categoryState.category!.menuItems!.isEmpty
                        ? Center(child: Text("No meals available"))
                        : categoryState.status == "success"
                        ? TabBarContent(length: length)
                        : Center(child: Text(categoryState.message!)),
                  ),
                ],
              )
            : Center(child: Text(restaurantState.message!)),
      ),
    );
  }
}
