import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Asset yoki tarmoq rasmi — avtomatik aniqlaydi, placeholder va xato holatlari bilan.
class AppImage extends StatelessWidget {
  const AppImage(
    this.src, {
    super.key,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.heroTag,
  });

  final String src;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final Object? heroTag;

  @override
  Widget build(BuildContext context) {
    Widget child;
    if (src.isEmpty) {
      child = _Fallback(width: width, height: height);
    } else if (src.startsWith('http')) {
      child = CachedNetworkImage(
        imageUrl: src,
        width: width,
        height: height,
        fit: fit,
        fadeInDuration: const Duration(milliseconds: 250),
        placeholder: (_, __) => _Shimmer(width: width, height: height),
        errorWidget: (_, __, ___) => _Fallback(width: width, height: height),
      );
    } else {
      child = Image.asset(
        src,
        width: width,
        height: height,
        fit: fit,
        cacheWidth: width != null && width!.isFinite
            ? (width! * MediaQuery.devicePixelRatioOf(context)).round().clamp(64, 1200)
            : null,
        errorBuilder: (_, __, ___) => _Fallback(width: width, height: height),
      );
    }
    if (heroTag != null) child = Hero(tag: heroTag!, child: child);
    if (borderRadius != null) {
      child = ClipRRect(borderRadius: borderRadius!, child: child);
    }
    return child;
  }
}

class _Fallback extends StatelessWidget {
  const _Fallback({this.width, this.height});
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) => Container(
        width: width,
        height: height,
        color: context.colors.surfaceVariant,
        alignment: Alignment.center,
        child: Icon(Icons.image_outlined, color: context.colors.textTertiary, size: 28),
      );
}

class _Shimmer extends StatelessWidget {
  const _Shimmer({this.width, this.height});
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) => Container(
        width: width,
        height: height,
        color: context.colors.surfaceVariant,
      );
}
