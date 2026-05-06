// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class CategoryIconCard extends StatelessWidget {
  final String name;
  final VoidCallback? onTap;
  final String? imgUrl;

  const CategoryIconCard({
    super.key,
    required this.name,
    this.onTap,
    this.imgUrl,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return InkWell(
      onTap: onTap,
      child: Container(
        width: 76,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color:Colors.grey.shade100, width: 1.5),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: SizedBox(
                width: double.infinity,
                child: imgUrl == null
                    ? Icon(Icons.image_not_supported, size: 28)
                    : ClipRRect(
                        borderRadius: BorderRadiusGeometry.circular(15),
                        child: Image.network(imgUrl!, fit: BoxFit.cover),
                      ),
              ),
            ),
            Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15)
                ),
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Text(
                  name,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: colors.onSurface,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
