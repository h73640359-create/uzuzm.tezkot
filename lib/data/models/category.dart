import 'package:flutter/material.dart';

/// Mahsulot kategoriyasi.
class Category {
  const Category({
    required this.id,
    required this.name,
    required this.emoji,
    required this.icon,
    required this.color,
    this.subcategories = const [],
  });

  final String id;
  final String name;
  final String emoji;
  final IconData icon;
  final Color color;
  final List<String> subcategories;

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json['id'] as String,
        name: json['name'] as String,
        emoji: json['emoji'] as String? ?? '',
        icon: Icons.category_outlined,
        color: Color(json['color'] as int? ?? 0xFF0F766E),
        subcategories:
            (json['subcategories'] as List?)?.cast<String>() ?? const [],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'emoji': emoji,
        'color': color.toARGB32(),
        'subcategories': subcategories,
      };
}
