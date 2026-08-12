import 'package:flutter/material.dart';

class RestaurantByCategorySkeleton extends StatelessWidget {
  const RestaurantByCategorySkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  "مطعم البيت العربي الطويل",
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(width: 8),
              Row(
                children: [
                  Icon(Icons.star, size: 18),
                  SizedBox(width: 4),
                  Text("4.5"),
                ],
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            "مطعم يقدم أشهى المأكولات السورية والمشاوي بأنواعها",
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.location_on, size: 18),
              SizedBox(width: 4),
              Text("اللاذقية - شارع 8 آذار"),
            ],
          ),
        ],
      ),
    );
  }
}
