// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

Widget buildRow(BuildContext context, IconData icon, String text) {
  return Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(icon, color: Theme.of(context).colorScheme.primary, size: 18),
      const SizedBox(width: 10),
      Flexible(
        child: Text(
          text,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onBackground,
            fontSize: 12,
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ),
    ],
  );
}
