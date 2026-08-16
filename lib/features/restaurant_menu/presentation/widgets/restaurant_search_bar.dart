// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class RestaurantSearchHeader extends StatelessWidget {
  final bool isSearchVisible;
  final String restaurantName;
  final VoidCallback onSearchTap;

  const RestaurantSearchHeader({
    required this.isSearchVisible,
    required this.restaurantName,
    required this.onSearchTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 250),
        opacity: isSearchVisible ? 1 : 0,
        child: IgnorePointer(
          ignoring: !isSearchVisible,
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    const SizedBox(width: 30),
                    Expanded(
                      child: Text(
                        restaurantName,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(width: 30),
                  ],
                ),
                const SizedBox(height: 5),
                Container(
                  height: 42,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: onSearchTap,
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: Row(
                        children: [
                          Icon(Icons.search, color: Color(0xFFFF6B35)),
                          SizedBox(width: 10),
                          Text(
                            "Search meals...",
                            style: TextStyle(color: Colors.grey, fontSize: 15),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
