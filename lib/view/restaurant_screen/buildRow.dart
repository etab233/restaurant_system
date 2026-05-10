import 'package:flutter/material.dart';
import 'package:restaurants_system/constants.dart';

Widget buildRow(IconData icon, String text) {
  return Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(icon, color: Color(Constants.orangeColor), size: 18),
      const SizedBox(width: 10),
      Flexible(
        child: Text(
          text,
          style: const TextStyle(color: Colors.black, fontSize: 12),
          overflow: TextOverflow.ellipsis,
        ),
      ),
    ],
  );
}
