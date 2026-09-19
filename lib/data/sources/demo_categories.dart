import 'package:flutter/material.dart';

import '../models/category.dart';

/// Demo kategoriyalar. Backend ulanganda [CategoryRepository] shu ro'yxat
/// o'rniga serverdan keladigan ma'lumotni qaytaradi.
class DemoCategories {
  DemoCategories._();

  static const List<Category> all = [
    Category(
      id: 'electronics',
      name: 'Elektronika',
      emoji: '📱',
      icon: Icons.devices_other_rounded,
      color: Color(0xFF2563EB),
      subcategories: ['Telefonlar', 'Noutbuklar', 'Quloqchinlar', 'Televizorlar', 'Aksessuarlar'],
    ),
    Category(
      id: 'appliances',
      name: 'Maishiy texnika',
      emoji: '🧺',
      icon: Icons.kitchen_rounded,
      color: Color(0xFF0891B2),
      subcategories: ['Oshxona texnikasi', 'Uy tozalash', 'Iqlim texnikasi'],
    ),
    Category(
      id: 'clothing',
      name: 'Kiyim',
      emoji: '👕',
      icon: Icons.checkroom_rounded,
      color: Color(0xFFDB2777),
      subcategories: ['Erkaklar kiyimi', 'Ayollar kiyimi', 'Bolalar kiyimi'],
    ),
    Category(
      id: 'shoes',
      name: 'Oyoq kiyim',
      emoji: '👟',
      icon: Icons.hiking_rounded,
      color: Color(0xFF7C3AED),
      subcategories: ['Krossovkalar', 'Tuflilar', 'Etiklar', 'Shippaklar'],
    ),
    Category(
      id: 'beauty',
      name: "Go'zallik",
      emoji: '💄',
      icon: Icons.spa_rounded,
      color: Color(0xFFE11D48),
      subcategories: ['Kosmetika', 'Parfyumeriya', 'Soch parvarishi', 'Teri parvarishi'],
    ),
    Category(
      id: 'home',
      name: 'Uy uchun',
      emoji: '🏠',
      icon: Icons.chair_rounded,
      color: Color(0xFFD97706),
      subcategories: ['Uy jihozlari', 'Oshxona buyumlari', 'Tekstil', 'Dekor'],
    ),
    Category(
      id: 'food',
      name: 'Oziq-ovqat',
      emoji: '🍎',
      icon: Icons.local_grocery_store_rounded,
      color: Color(0xFF16A34A),
      subcategories: ['Meva va sabzavotlar', 'Ichimliklar', 'Shirinliklar', 'Kundalik mahsulotlar'],
    ),
    Category(
      id: 'household',
      name: "Uy-ro'zg'or",
      emoji: '🧴',
      icon: Icons.cleaning_services_rounded,
      color: Color(0xFF0D9488),
      subcategories: ['Tozalash vositalari', 'Gigiyena', 'Kir yuvish'],
    ),
    Category(
      id: 'auto',
      name: 'Avto',
      emoji: '🚗',
      icon: Icons.directions_car_rounded,
      color: Color(0xFF475569),
      subcategories: ['Aksessuarlar', 'Elektronika', 'Parvarish'],
    ),
    Category(
      id: 'sport',
      name: 'Sport',
      emoji: '⚽',
      icon: Icons.fitness_center_rounded,
      color: Color(0xFFEA580C),
      subcategories: ['Fitnes', 'Futbol', 'Velosport', 'Sport kiyimlari'],
    ),
    Category(
      id: 'kids',
      name: 'Bolalar',
      emoji: '🧸',
      icon: Icons.child_care_rounded,
      color: Color(0xFFF59E0B),
      subcategories: ["O'yinchoqlar", 'Chaqaloq parvarishi', 'Maktab'],
    ),
    Category(
      id: 'books',
      name: 'Kitoblar',
      emoji: '📚',
      icon: Icons.menu_book_rounded,
      color: Color(0xFF9333EA),
      subcategories: ['Badiiy', 'Biznes', 'Bolalar uchun', "O'quv"],
    ),
    Category(
      id: 'tools',
      name: 'Asboblar',
      emoji: '🔧',
      icon: Icons.handyman_rounded,
      color: Color(0xFF64748B),
      subcategories: ['Elektr asboblar', "Qo'l asboblari", "O'lchov"],
    ),
    Category(
      id: 'garden',
      name: "Bog' uchun",
      emoji: '🌱',
      icon: Icons.yard_rounded,
      color: Color(0xFF65A30D),
      subcategories: ['Urug\'lar', 'Sug\'orish', "Bog' asboblari"],
    ),
  ];

  static Category? byId(String id) {
    for (final c in all) {
      if (c.id == id) return c;
    }
    return null;
  }
}
