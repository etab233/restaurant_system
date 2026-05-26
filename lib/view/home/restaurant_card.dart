// ignore_for_file: deprecated_member_use

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:restaurants_system/models/restaurant_model.dart';

class RestaurantCard extends StatelessWidget {
  final RestaurantModel restaurant;
  final VoidCallback? onTap;

  const RestaurantCard({super.key, required this.restaurant, this.onTap});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: colors.outline.withOpacity(0.2)),
          boxShadow: [
            BoxShadow(
              color: colors.shadow,
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _CoverSection(restaurant: restaurant),
                _InfoSection(restaurant: restaurant),
              ],
            ),
            // Logo في الزاوية السفلى اليمنى
            Positioned(
              bottom: 100,
              right: 7,
              child: _LogoAvatar(
                name: restaurant.name,
                logoUrl: restaurant.logo,
                id: restaurant.id,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Cover ─────────────────────────────────────────────────────
class _CoverSection extends StatelessWidget {
  final RestaurantModel restaurant;
  const _CoverSection({required this.restaurant});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
          child: _CoverPlaceholder(
            name: restaurant.name,
            coverUrl: restaurant.coverImage,
          ),
        ),

        // شارة مفتوح / مغلق
        Positioned(
          top: 10,
          left: 10,
          child: _OpenBadge(isOpen: restaurant.hours.isOpen),
        ),
      ],
    );
  }
}

// ── Cover Placeholder ─────────────────────────────────────────
class _CoverPlaceholder extends StatelessWidget {
  final String name;
  final String? coverUrl;

  const _CoverPlaceholder({required this.name, this.coverUrl});

  @override
  Widget build(BuildContext context) {
    // لو الصورة موجودة وشغالة بتظهر، لو لأ بيظهر الـ placeholder
    if (coverUrl != null && coverUrl!.isNotEmpty) {
      return Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.transparent, Colors.black.withOpacity(0.3)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: CachedNetworkImage(
          imageUrl: coverUrl!,
          height: 140,
          width: double.infinity,
          fit: BoxFit.cover,
          errorWidget: (context, url, error) => _buildPlaceholder(name),
          placeholder: (context, url) => _buildPlaceholder(name),
        ),
      );
    }
    return _buildPlaceholder(name);
  }

  Widget _buildPlaceholder(String name) {
    return SizedBox(
      height: 140,
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.storefront_rounded, size: 44, color: Colors.grey),
          const SizedBox(height: 6),
          Text(
            name,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
        ],
      ),
    );
  }
}

// ── Open Badge ────────────────────────────────────────────────
class _OpenBadge extends StatelessWidget {
  final bool isOpen;
  const _OpenBadge({required this.isOpen});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: colors.surface.withOpacity(0.9),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 7,
            height: 7,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isOpen ? const Color(0xFF1a7a3a) : const Color(0xFFc0392b),
            ),
          ),
          const SizedBox(width: 5),
          Text(
            isOpen ? "Open now" : "Closed",
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: isOpen ? const Color(0xFF1a7a3a) : const Color(0xFFc0392b),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Logo Avatar ───────────────────────────────────────────────
class _LogoAvatar extends StatelessWidget {
  final String name;
  final String? logoUrl;
  final int id;

  const _LogoAvatar({required this.name, this.logoUrl, required this.id});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      width: 58,
      height: 58,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: colors.outline.withAlpha(2), width: 0.5),
        boxShadow: [
          BoxShadow(color: colors.shadow, offset: Offset(0, 3), blurRadius: 5),
        ],
      ),
      child: Hero(
        tag: "restaurant logo $id",
        child:  logoUrl != null
          ? ClipOval(
              child: Image.network(
                logoUrl!,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => _buildInitial(name),
              ),
            )
          : _buildInitial(name),
      )
    );
  }

  Widget _buildInitial(String name) {
    return Center(
      child: Text(
        name.isNotEmpty ? name[0].toUpperCase() : '?',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
    );
  }
}

// ── Info Section ──────────────────────────────────────────────
class _InfoSection extends StatelessWidget {
  final RestaurantModel restaurant;
  const _InfoSection({required this.restaurant});

  String formatDistance(double km) {
    if (km < 1) {
      return "${(km * 1000).round()} m";
    }
    return "${km.toStringAsFixed(1)} km";
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final opens = restaurant.hours.opens ?? '--';
    final closes = restaurant.hours.closes ?? '--';
    final cats = restaurant.categories.take(2).map((c) => c.name).join(' · ');

    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 22, 14, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // اسم + rating
          Row(
            children: [
              Expanded(
                child: Text(
                  restaurant.name,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: colors.onSurface,
                  ),
                ),
              ),
              Icon(Icons.star_rounded, size: 16, color: colors.primary),
              const SizedBox(width: 3),
              Text(
                restaurant.rate.toStringAsFixed(1),
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: colors.onSurface,
                ),
              ),
            ],
          ),

          const SizedBox(height: 4),

          // التصنيفات + وقت
          Text(
            cats.isNotEmpty ? cats : restaurant.description,
            style: TextStyle(fontSize: 14, color: colors.onSurfaceVariant),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),

          const SizedBox(height: 10),
          Divider(height: 1, color: colors.outline.withOpacity(0.2)),
          const SizedBox(height: 10),

          // ساعات + مسافة
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(
                Icons.access_time_rounded,
                size: 17,
                color: Colors.grey,
              ),
              const SizedBox(width: 7),
              Text(
                "$opens — $closes",
                style: TextStyle(fontSize: 11, color: colors.onSurfaceVariant),
              ),
              const Spacer(),

              // مسافة لو كانت nearby
              if (restaurant.location.distanceKm != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 9,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: colors.primaryContainer,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    formatDistance(restaurant.location.distanceKm!),
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
