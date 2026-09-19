import 'package:flutter/material.dart';

import '../models/banner_item.dart';

class DemoBanners {
  DemoBanners._();

  static const List<BannerItem> all = [
    BannerItem(
      id: 'b1',
      title: 'Kuzgi chegirmalar',
      subtitle: "Elektronikaga 25% gacha chegirma",
      badge: '-25%',
      colors: [Color(0xFF0F766E), Color(0xFF14B8A6)],
      icon: Icons.bolt_rounded,
      tag: 'sale',
    ),
    BannerItem(
      id: 'b2',
      title: 'Yangi kolleksiya',
      subtitle: "Kuz-qish kiyimlari allaqachon sotuvda",
      badge: 'YANGI',
      colors: [Color(0xFF7C3AED), Color(0xFFA855F7)],
      icon: Icons.checkroom_rounded,
      categoryId: 'clothing',
    ),
    BannerItem(
      id: 'b3',
      title: 'Bepul yetkazib berish',
      subtitle: "300 000 so'mdan yuqori xaridlarga",
      badge: '0 so\'m',
      colors: [Color(0xFFD97706), Color(0xFFF59E0B)],
      icon: Icons.local_shipping_rounded,
      tag: 'popular',
    ),
    BannerItem(
      id: 'b4',
      title: 'Har kuni yangi meva',
      subtitle: "Fermerlardan to'g'ridan-to'g'ri",
      badge: 'FRESH',
      colors: [Color(0xFF16A34A), Color(0xFF4ADE80)],
      icon: Icons.eco_rounded,
      categoryId: 'food',
    ),
  ];
}
