import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/repositories/repositories.dart';
import '../data/sources/local_storage.dart';

/// Repozitoriy providerlari. Backend ulanganda faqat shu yerdagi
/// implementatsiyalarni almashtirish kifoya.
final productRepositoryProvider = Provider<ProductRepository>((ref) {
  return DemoProductRepository();
});

final categoryRepositoryProvider = Provider<CategoryRepository>((ref) {
  return DemoCategoryRepository();
});

final orderRepositoryProvider = Provider<OrderRepository>((ref) {
  return LocalOrderRepository(ref.watch(localStorageProvider));
});

final userRepositoryProvider = Provider<UserRepository>((ref) {
  return LocalUserRepository(ref.watch(localStorageProvider));
});
