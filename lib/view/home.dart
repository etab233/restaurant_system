import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurants_system/providers/auth_provider.dart';
import 'package:restaurants_system/providers/restaurant_request_provider.dart';
import 'package:restaurants_system/view/restaurant-request/restaurant_request.dart';
import 'package:restaurants_system/view/bottom_navbar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:restaurants_system/constants.dart';
import 'package:restaurants_system/view/login-register/login.dart';
import 'package:restaurants_system/providers/search_provider.dart';

class Home extends ConsumerStatefulWidget {
  const Home({super.key});
  @override
  ConsumerState<Home> createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> {
  final _searchController = TextEditingController();
  Timer? debounce;
  String? token;
  @override
  void initState() {
    super.initState();
    loadPrefs();
  }

  Future<void> loadPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString("token");
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
    debounce!.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final searchState = ref.watch(searchProvider);
    final authState = ref.watch(authProvider);
    final resState = ref.watch(restaurantRequestProvider.notifier);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: TextButton(
          onPressed: () {
            showModalBottomSheet(
              context: context,
              builder: (BuildContext context) {
                return SizedBox(
                  height: MediaQuery.of(context).size.height * 0.8,
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      //mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Where should we deliver your order?",
                              style: TextStyle(
                                color: Colors.black87,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.close),
                              onPressed: () => Navigator.pop(context),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            resState.getCurrentLocation();
                          },
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.radio_button_checked,
                                color: Color(Constants.orangeColor),
                                size: 35,
                              ),
                              const SizedBox(width: 20),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Use current location",
                                    style: TextStyle(
                                      color: Colors.black87,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    "browse restaurant near you",
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 18,
                                    ),
                                  ),
                                  Divider(thickness: 1, color: Colors.grey),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.arrow_drop_down_outlined,
                size: 25,
                color: Colors.black87,
              ),
              Text(
                "Deliver to Latakia 📍",
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        leading: Builder(
          builder: (context) {
            return IconButton(
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              icon: Icon(Icons.menu, size: 30, color: Colors.black87),
            );
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications_none, size: 30, color: Colors.black87),
            onPressed: () {},
          ),
        ],
      ),
      drawer: Drawer(
        elevation: 10,
        width: MediaQuery.of(context).size.width * 0.75,

        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color:Color(0xFFFF6B00).withOpacity(0.15),
              ),
              child: token == null
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              radius: 30,
                              backgroundColor: Colors.grey.shade100,
                              child: Icon(Icons.person),
                            ),
                            const SizedBox(width: 10),
                            Text("Login to unlock offers"),
                          ],
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => Login()),
                            );
                          },
                          child: Text(
                            "Login",
                            style: TextStyle(
                              color: Color(Constants.orangeColor),
                            ),
                          ),
                        ),
                      ],
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.grey.shade100,
                          child: Icon(Icons.person),
                        ),
                        const SizedBox(width: 10),
                        Text("Welcome ${authState.userData?['name']}"),
                      ],
                    ),
            ),
            ListTile(
              title: Text("Settings"),
              leading: Icon(Icons.settings),
              selectedColor: Color(Constants.orangeColor),
            ),
            Divider(color: Colors.grey.shade300, thickness: 0.7),
            ListTile(
              title: Text("Restaurant owner request"),
              leading: Icon(Icons.restaurant),
              selectedColor: Color(Constants.orangeColor),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => RestaurantRequest()),
                );
              },
            ),
            Divider(color: Colors.grey.shade300, thickness: 0.7),
            ListTile(
              title: Text("Delivery request"),
              leading: Icon(Icons.delivery_dining),
              selectedColor: Color(Constants.orangeColor),
            ),
            Divider(color: Colors.grey.shade300, thickness: 10.7),
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 30),
            child: Column(
              children: [
                Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 15,
                          offset: Offset(0, 6),
                        ),
                      ],
                    ),
                    child: TextField(
                      onChanged: (value) {
                        if (debounce?.isActive ?? false) debounce?.cancel();

                        debounce = Timer(Duration(milliseconds: 500), () {
                          ref
                              .read(searchProvider.notifier)
                              .search(query: value);
                        });
                      },
                      controller: _searchController,
                      cursorColor: Color(Constants.orangeColor),
                      decoration: InputDecoration(
                        hintText: "Search food, restaurants...",
                        prefixIcon: Icon(Icons.search, color: Colors.black),
                        filled: true,
                        fillColor: Colors.grey.shade300,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavBar(),
    );
  }
}
