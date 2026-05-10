import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurants_system/constants.dart';
import 'package:restaurants_system/providers/restaurant_provider.dart';

class TabBarContent extends ConsumerWidget {
  final int? length;

  const TabBarContent({super.key, required this.length});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(categoryProvider);
    return TabBarView(
      children: [
        for (int i = 0; i < length!; i++)
          ListView.builder(
            padding: EdgeInsets.only(top: 10),
            itemCount: state.category?.menuItems!.length ?? 0,
            itemBuilder: (context, index) {
              final meal = state.category?.menuItems![index];
              return Container(
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 5,
                      offset: Offset(0, 3),
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
                            backgroundImage: AssetImage(
                              meal!.image ?? "assets/images/burger.png",
                            ),
                          ),
                          if (meal.is_featured)
                            Positioned(
                              top: 0,
                              right: 0,
                              child: Container(
                                padding: EdgeInsets.all(1),
                                decoration: BoxDecoration(
                                  color: Colors.white,
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
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Text(
                          meal.description,
                          style: TextStyle(fontSize: 10),
                        ),
                      ),
                      trailing: Text(
                        "${meal.price} \$",
                        style: TextStyle(fontSize: 14, color: Colors.green),
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(Constants.orangeColor),
                          ),
                          onPressed: () {},
                          child: Text(
                            "Meal Analysis",
                            style: TextStyle(color: Colors.white, fontSize: 10),
                          ),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(Constants.orangeColor),
                          ),
                          onPressed: () {},
                          child: Text(
                            "Order Meal",
                            style: TextStyle(color: Colors.white, fontSize: 10),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
      ],
    );
  }
}
