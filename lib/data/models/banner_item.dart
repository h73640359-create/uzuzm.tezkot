import 'package:flutter/material.dart';

class BannerItem {
  const BannerItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.badge,
    required this.colors,
    required this.icon,
    this.categoryId,
    this.tag,
  });

  final String id;
  final String title;
  final String subtitle;
  final String badge;
  final List<Color> colors;
  final IconData icon;
  final String? categoryId;
  final String? tag;
}
