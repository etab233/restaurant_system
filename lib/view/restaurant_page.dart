import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:restaurants_system/notifier/restaurant_screen_notifier.dart';
import 'package:restaurants_system/providers/restaurant_provider.dart';
import 'package:restaurants_system/services/view_restaurant_service.dart';
import 'package:restaurants_system/view/login-register/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RestaurantScreen extends ConsumerStatefulWidget {
  const RestaurantScreen({super.key});

  @override
  ConsumerState<RestaurantScreen> createState() => _RestaurantScreenState();
}

class _RestaurantScreenState extends ConsumerState<RestaurantScreen> {
  @override
  void initState() {
    super.initState(); // تأكد أن هذه أول سطر
    WidgetsBinding.instance.addPostFrameCallback((_) {
      test();
    });
  }
  // @override
  // void initState() {
  //   super.initState();
  //   Future.microtask(() => test());
  // test();
  // final prefs = await SharedPreferences.getInstance();
  // final token = prefs.getString("token") ?? "";
  // if (token.isNotEmpty) {
  //   await ref.read(restaurantProvider.notifier).viewRestaurant(1, token!);
  // } else {
  // ScaffoldMessenger.of(context).showSnackBar(
  //   SnackBar(
  //     content: Text("The session has been expired."),
  //     backgroundColor: Colors.red,
  //   ),
  // );
  //     Navigator.of(
  //       context,
  //     ).pushReplacement(MaterialPageRoute(builder: (context) => Login()));
  //   }
  // }

  void test() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token") ?? "";
    await ref.read(restaurantProvider.notifier).viewRestaurant(1);
    if (token.isNotEmpty) {}
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(restaurantProvider);
    return Scaffold(
      // appBar: AppBar(),
      backgroundColor: const Color(0xFFFDF5E6),
      body: state.isLoading
          ? const Center(child: CircularProgressIndicator())
          : state.status == "success"
          ? CustomScrollView(
              slivers: [
                SliverAppBar(
                  expandedHeight: 290,
                  pinned: true,
                  elevation: 0,
                  backgroundColor: const Color(0xFFFDF5E6),
                  leading: IconButton(
                    icon: Icon(Icons.arrow_back_ios, color: Colors.black),
                    onPressed: () => Navigator.pop(context),
                  ),

                  flexibleSpace: FlexibleSpaceBar(
                    centerTitle: true,
                    title: LayoutBuilder(
                      builder: (context, constraints) {
                        var top = constraints.biggest.height;
                        bool isCollapsed =
                            top <=
                            (kToolbarHeight +
                                MediaQuery.of(context).padding.top);

                        return AnimatedOpacity(
                          duration: Duration(milliseconds: 200),
                          opacity: isCollapsed ? 1.0 : 0.0,
                          child: Text(
                            (ref.read(restaurantProvider).restaurant?.name)!,
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      },
                    ),
                    background: Container(
                      height: 290,
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: Column(
                              children: [
                                Image.asset(
                                  height: 170,
                                  width: double.infinity,

                                  // ref
                                  //         .read(restaurantProvider)
                                  //         .restaurant
                                  //         ?.cover_image ??
                                      "assets/cover.png",
                                  fit: BoxFit.cover,
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFDF5E6),
                                    // boxShadow: [
                                    //   BoxShadow(
                                    //     color: Colors.black12,
                                    //     blurRadius: 10,
                                    //     offset: Offset(0, 5),
                                    //   ),
                                    // ],
                                  ),
                                  child: Column(
                                    children: [
                                      Container(
                                        height: 40,
                                        alignment: Alignment.centerLeft,
                                        padding: EdgeInsets.only(
                                          left: 8,
                                          top: 10,
                                        ),
                                        child: Text(
                                          (ref
                                              .read(restaurantProvider)
                                              .restaurant
                                              ?.name)!,
                                          style: TextStyle(
                                            fontSize: 26,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      Container(
                                        margin: EdgeInsets.only(bottom: 8),
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 8,
                                        ),
                                        child: Text(
                                          (ref
                                              .read(restaurantProvider)
                                              .restaurant
                                              ?.description)!,
                                          maxLines: 3,
                                          style: TextStyle(
                                            color: Colors.black54,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                            top: 120,
                            right: 20,
                            child: CircleAvatar(
                              radius: 50,
                              backgroundColor: const Color(
                                0xFFFDF5E6,
                              ), // إطار أبيض عشان يبرز اللوغو
                              child: CircleAvatar(
                                radius: 45,
                                backgroundImage: AssetImage(
                                  // ref
                                  //         .read(restaurantProvider)
                                  //         .restaurant
                                  //         ?.logo ??
                                      "assets/logo.jpg",
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SliverList(
                  delegate: SliverChildListDelegate([
                    Container(
                      margin: EdgeInsets.all(10.0),
                      padding: const EdgeInsets.all(10.0),

                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 10,
                            offset: Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.location_on),
                              SizedBox(width: 5),
                              Expanded(
                                child: Text(
                                  (ref
                                      .read(restaurantProvider)
                                      .restaurant
                                      ?.address)!,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(Icons.phone),
                              SizedBox(width: 5),
                              Text(
                                "Phone: ${(ref.read(restaurantProvider).restaurant?.phone)!}",
                              ),
                              Spacer(),
                              MaterialButton(
                                onPressed: () {},
                                child: Row(
                                  children: [Icon(Icons.phone), Text(" Call")],
                                ),
                                color: const Color.fromARGB(255, 105, 202, 109),
                                splashColor: const Color.fromARGB(
                                  255,
                                  61,
                                  177,
                                  65,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          TextButton(
                            onPressed: () {},
                            child: Text(
                              "${(ref.read(restaurantProvider).restaurant?.email)!}",
                            ),
                          ),
                          Row(
                            children: [
                              Icon(Icons.access_time),
                              SizedBox(width: 5),
                              Text("Opening Hours:"),
                            ],
                          ),
                          Row(
                            children: [
                              SizedBox(width: 30),
                              Column(
                                children: [
                                  Text(
                                    "${(ref.read(restaurantProvider).restaurant?.openingTime)!}",
                                  ),
                                  Text(
                                    "${(ref.read(restaurantProvider).restaurant?.closingTime)!}",
                                  ),
                                ],
                              ),
                              Spacer(),
                              Text(
                                "Currently Open",
                                style: TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          // padding: const EdgeInsets.all(10.0),
                          height: 200,
                          width: double.infinity,
                          decoration: BoxDecoration(color: Colors.grey[200]),
                          child: FlutterMap(
                            options: MapOptions(
                              initialCenter: LatLng(
                                35.35609272393359,
                                35.927740005382056,
                              ),
                              initialZoom: 15,
                            ),
                            children: [
                              TileLayer(
                                urlTemplate:
                                    'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                userAgentPackageName:
                                    'com.omar.restaurants_system',
                              ),
                              MarkerLayer(
                                markers: [
                                  Marker(
                                    point: LatLng(
                                      35.35609272393359,
                                      35.927740005382056,
                                    ),
                                    child: Icon(Icons.location_on),
                                    height: 40,
                                    width: 40,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ]),
                ),
              ],
            )
          : Center(child: Text(state.message!)),
    );
  }
}
