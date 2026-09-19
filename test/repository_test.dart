import 'package:bozorgo/data/repositories/product_repository.dart';
import 'package:bozorgo/data/sources/demo_products.dart';
import 'package:bozorgo/core/utils/formatters.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final repo = DemoProductRepository();

  test("Demo ma'lumotlarda kamida 50 ta mahsulot bor", () {
    expect(DemoProducts.all.length, greaterThanOrEqualTo(50));
    final ids = DemoProducts.all.map((p) => p.id).toSet();
    expect(ids.length, DemoProducts.all.length, reason: 'ID lar takrorlanmasligi kerak');
  });

  test('Qidiruv: "telefon" telefonlarni topadi', () async {
    final r = await repo.search(const ProductFilter(query: 'telefon'));
    expect(r, isNotEmpty);
    expect(r.any((p) => p.name.contains('iPhone')), isTrue);
  });

  test('Qidiruv: "olma" mevani topadi', () async {
    final r = await repo.search(const ProductFilter(query: 'olma'));
    expect(r.any((p) => p.name.startsWith('Olma')), isTrue);
  });

  test('Qidiruv: "erkaklar kiyimi"', () async {
    final r = await repo.search(const ProductFilter(query: 'erkaklar kiyimi'));
    expect(r, isNotEmpty);
    expect(r.every((p) => p.categoryId == 'clothing'), isTrue);
  });

  test('Saralash: arzonidan qimmatiga', () async {
    final r = await repo.search(const ProductFilter(sort: SortOption.priceAsc));
    for (var i = 1; i < r.length; i++) {
      expect(r[i].price >= r[i - 1].price, isTrue);
    }
  });

  test('Filtr: faqat chegirmadagilar va narx oralig\'i', () async {
    final r = await repo.search(const ProductFilter(onlyDiscount: true, minPrice: 100000, maxPrice: 500000));
    expect(r, isNotEmpty);
    for (final p in r) {
      expect(p.hasDiscount, isTrue);
      expect(p.price, inInclusiveRange(100000, 500000));
    }
  });

  test('Narx formatlash', () {
    expect(Formatters.price(1234567), "1 234 567 so'm");
    expect(Formatters.price(900), "900 so'm");
    expect(Formatters.discountPercent(80, 100), 20);
  });
}
