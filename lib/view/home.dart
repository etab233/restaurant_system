import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurants_system/view/restaurant-request/restaurant_request.dart';
import 'package:restaurants_system/view/bottom_navbar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:restaurants_system/constants.dart';
import 'package:restaurants_system/view/login-register/login.dart';

class Home extends ConsumerStatefulWidget {
  const Home({super.key});
  @override
  ConsumerState<Home> createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> {
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text("App Bar"),
        centerTitle: true,
        leading: Builder(
          builder: (context) {
            return IconButton(
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              icon: Icon(Icons.menu, size: 30),
            );
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications, size: 35, color: Colors.black),
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
                color: Color(Constants.backgroundColor),
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
                  : Row(children: []),
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
      body: Center(child: Text("Home", style: TextStyle(fontSize: 30))),
      bottomNavigationBar: BottomNavBar(),
    );
  }
}
