import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/config/app_config.dart';
import '../data/models/models.dart';
import '../data/sources/demo_products.dart';
import '../data/sources/local_storage.dart';

class CartState {
  const CartState({this.items = const []});
  final List<CartItem> items;

  bool get isEmpty => items.isEmpty;
  int get count => items.fold(0, (s, i) => s + i.quantity);
  List<CartItem> get selected => items.where((i) => i.selected).toList();
  bool get allSelected => items.isNotEmpty && items.every((i) => i.selected);

  int get subtotal => selected.fold(0, (s, i) => s + i.oldTotal);
  int get discount => selected.fold(0, (s, i) => s + (i.oldTotal - i.total));
  int get itemsTotal => selected.fold(0, (s, i) => s + i.total);
  int get deliveryFee =>
      selected.isEmpty || itemsTotal >= AppConfig.freeDeliveryThreshold ? 0 : AppConfig.deliveryFee;
  int get total => itemsTotal + deliveryFee;

  int quantityOf(String productId) {
    for (final i in items) {
      if (i.product.id == productId) return i.quantity;
    }
    return 0;
  }

  bool contains(String productId) => quantityOf(productId) > 0;
}

class CartNotifier extends Notifier<CartState> {
  late LocalStorage _storage;

  @override
  CartState build() {
    _storage = ref.watch(localStorageProvider);
    return _load();
  }

  CartState _load() {
    final raw = _storage.readCart();
    final items = <CartItem>[];
    for (final m in raw) {
      final p = DemoProducts.byId(m['productId'] as String);
      if (p == null) continue;
      items.add(CartItem(
        product: p,
        quantity: (m['quantity'] as int?) ?? 1,
        selected: (m['selected'] as bool?) ?? true,
      ));
    }
    return CartState(items: items);
  }

  void _persist(List<CartItem> items) {
    state = CartState(items: items);
    _storage.writeCart(items.map((e) => e.toJson()).toList());
  }

  void add(Product product, {int quantity = 1}) {
    final items = List<CartItem>.from(state.items);
    final idx = items.indexWhere((i) => i.product.id == product.id);
    if (idx >= 0) {
      final q = (items[idx].quantity + quantity).clamp(1, product.stock);
      items[idx] = items[idx].copyWith(quantity: q);
    } else {
      items.add(CartItem(product: product, quantity: quantity.clamp(1, product.stock)));
    }
    _persist(items);
  }

  void setQuantity(String productId, int quantity) {
    final items = List<CartItem>.from(state.items);
    final idx = items.indexWhere((i) => i.product.id == productId);
    if (idx < 0) return;
    if (quantity <= 0) {
      items.removeAt(idx);
    } else {
      items[idx] = items[idx].copyWith(quantity: quantity.clamp(1, items[idx].product.stock));
    }
    _persist(items);
  }

  void increment(String productId) =>
      setQuantity(productId, state.quantityOf(productId) + 1);

  void decrement(String productId) =>
      setQuantity(productId, state.quantityOf(productId) - 1);

  void remove(String productId) {
    _persist(state.items.where((i) => i.product.id != productId).toList());
  }

  void toggleSelected(String productId) {
    _persist([
      for (final i in state.items)
        if (i.product.id == productId) i.copyWith(selected: !i.selected) else i,
    ]);
  }

  void selectAll(bool value) {
    _persist([for (final i in state.items) i.copyWith(selected: value)]);
  }

  void removeSelected() {
    _persist(state.items.where((i) => !i.selected).toList());
  }

  void clear() => _persist(const []);
}

final cartProvider = NotifierProvider<CartNotifier, CartState>(CartNotifier.new);
