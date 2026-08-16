import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class AppNetworkImage extends StatelessWidget {
  final String? imageUrl;
  final double width;
  final double height;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final Widget? placeholder;
  final Widget? fallback;

  const AppNetworkImage({
    super.key,
    required this.imageUrl,
    required this.width,
    required this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.placeholder,
    this.fallback,
  });

  @override
  Widget build(BuildContext context) {
    final hasValidUrl = imageUrl != null &&
        imageUrl!.isNotEmpty &&
        imageUrl!.startsWith('http');

    final pixelRatio = MediaQuery.of(context).devicePixelRatio;

    final cacheWidth = width.isFinite ? (width * pixelRatio).round() : null;
    final cacheHeight = height.isFinite ? (height * pixelRatio).round() : null;

    Widget image = hasValidUrl
        ? CachedNetworkImage(
            imageUrl: imageUrl!,
            width: width,
            height: height,
            fit: fit,
            memCacheWidth: cacheWidth,
            memCacheHeight: cacheHeight,
            fadeInDuration: const Duration(milliseconds: 200),
            placeholder: (context, url) => placeholder ?? _defaultPlaceholder(),
            errorWidget: (context, url, error) => fallback ?? _defaultFallback(),
          )
        : (fallback ?? _defaultFallback());

    if (borderRadius != null) {
      image = ClipRRect(borderRadius: borderRadius!, child: image);
    }

    return image;
  }

  Widget _defaultPlaceholder() {
    return Container(
      width: width.isFinite ? width : null,
      height: height.isFinite ? height : null,
      color: Colors.grey.shade200,
      child: const Center(
        child: SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      ),
    );
  }

  Widget _defaultFallback() {
    return Container(
      width: width.isFinite ? width : null,
      height: height.isFinite ? height : null,
      color: Colors.grey.shade200,
      child: Icon(Icons.image_not_supported_outlined,
          color: Colors.grey.shade400,
          size: width.isFinite ? width * 0.3 : 40),
    );
  }
}