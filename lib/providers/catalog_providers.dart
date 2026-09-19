import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models/models.dart';
import '../data/repositories/product_repository.dart';
import 'repository_providers.dart';

final categoriesProvider = FutureProvider<List<Category>>((ref) {
  return ref.watch(categoryRepositoryProvider).getAll();
});

final allProductsProvider = FutureProvider<List<Product>>((ref) {
  return ref.watch(productRepositoryProvider).getAll();
});

final productByIdProvider = FutureProvider.family<Product?, String>((ref, id) {
  return ref.watch(productRepositoryProvider).getById(id);
});

final productsByTagProvider = FutureProvider.family<List<Product>, String>((ref, tag) {
  return ref.watch(productRepositoryProvider).getByTag(tag, limit: 10);
});

/// "Siz uchun" — sevimlilar va savat kategoriyalari asosida oddiy tavsiya.
final recommendedProductsProvider = FutureProvider<List<Product>>((ref) async {
  final all = await ref.watch(allProductsProvider.future);
  final list = List<Product>.from(all)..sort((a, b) => b.rating.compareTo(a.rating));
  // Turli kategoriyalardan aralash olish
  final seen = <String>{};
  final out = <Product>[];
  for (final p in list) {
    if (seen.add(p.categoryId)) out.add(p);
    if (out.length >= 10) break;
  }
  return out;
});

final productReviewsProvider = FutureProvider.family<List<Review>, String>((ref, id) {
  return ref.watch(productRepositoryProvider).getReviews(id);
});

final brandsProvider = FutureProvider.family<List<String>, String?>((ref, categoryId) {
  return ref.watch(productRepositoryProvider).getBrands(categoryId: categoryId);
});

final popularSearchesProvider = FutureProvider<List<String>>((ref) {
  return ref.watch(productRepositoryProvider).getPopularSearches();
});

/// Filtr asosida qidiruv natijalari.
final searchResultsProvider =
    FutureProvider.autoDispose.family<List<Product>, ProductFilter>((ref, filter) {
  return ref.watch(productRepositoryProvider).search(filter);
});

/// O'xshash mahsulotlar (bir kategoriya, o'zi bundan mustasno).
final similarProductsProvider =
    FutureProvider.family<List<Product>, String>((ref, productId) async {
  final repo = ref.watch(productRepositoryProvider);
  final p = await repo.getById(productId);
  if (p == null) return const [];
  final list = await repo.getByCategory(p.categoryId);
  return list.where((e) => e.id != productId).take(8).toList();
});
