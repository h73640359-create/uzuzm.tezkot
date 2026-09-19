import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models/product.dart';
import '../data/sources/demo_products.dart';
import '../data/sources/local_storage.dart';

class WishlistNotifier extends Notifier<Set<String>> {
  late LocalStorage _storage;

  @override
  Set<String> build() {
    _storage = ref.watch(localStorageProvider);
    return _storage.readFavorites().toSet();
  }

  bool contains(String id) => state.contains(id);

  /// Qo'shilgan bo'lsa `true`, olib tashlangan bo'lsa `false` qaytaradi.
  bool toggle(String id) {
    final s = Set<String>.from(state);
    final added = s.add(id);
    if (!added) s.remove(id);
    state = s;
    _storage.writeFavorites(s.toList());
    return added;
  }

  void remove(String id) {
    if (!state.contains(id)) return;
    final s = Set<String>.from(state)..remove(id);
    state = s;
    _storage.writeFavorites(s.toList());
  }

  void clear() {
    state = {};
    _storage.writeFavorites(const []);
  }
}

final wishlistProvider = NotifierProvider<WishlistNotifier, Set<String>>(WishlistNotifier.new);

final isFavoriteProvider = Provider.family<bool, String>((ref, id) {
  return ref.watch(wishlistProvider.select((s) => s.contains(id)));
});

final wishlistProductsProvider = Provider<List<Product>>((ref) {
  final ids = ref.watch(wishlistProvider);
  return ids.map(DemoProducts.byId).whereType<Product>().toList();
});
