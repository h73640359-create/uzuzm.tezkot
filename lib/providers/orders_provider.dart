import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models/models.dart';
import 'cart_provider.dart';
import 'repository_providers.dart';

class OrdersNotifier extends AsyncNotifier<List<Order>> {
  final Map<String, Timer> _timers = {};

  @override
  Future<List<Order>> build() async {
    ref.onDispose(() {
      for (final t in _timers.values) {
        t.cancel();
      }
    });
    return ref.watch(orderRepositoryProvider).getAll();
  }

  /// Savatdagi tanlangan mahsulotlardan buyurtma yaratadi.
  Future<Order> placeOrder({
    required String address,
    required String phone,
    required PaymentMethod paymentMethod,
    String comment = '',
  }) async {
    final repo = ref.read(orderRepositoryProvider);
    final cart = ref.read(cartProvider);
    final items = cart.selected
        .map((c) => OrderItem(
              productId: c.product.id,
              name: c.product.name,
              image: c.product.image,
              price: c.product.price,
              quantity: c.quantity,
            ))
        .toList();

    // DEMO PAYMENT: real API yo'q, to'lov muvaffaqiyatli deb hisoblanadi.
    await Future<void>.delayed(const Duration(milliseconds: 900));

    final order = Order(
      id: repo.generateId(),
      createdAt: DateTime.now(),
      items: items,
      subtotal: cart.subtotal,
      deliveryFee: cart.deliveryFee,
      discount: cart.discount,
      total: cart.total,
      status: OrderStatus.pending,
      address: address,
      phone: phone,
      paymentMethod: paymentMethod,
      comment: comment,
    );
    await repo.create(order);
    ref.read(cartProvider.notifier).removeSelected();
    state = AsyncData(await repo.getAll());
    _simulateProgress(order.id);
    return order;
  }

  /// Demo: buyurtma statusi vaqt o'tishi bilan avtomatik o'zgaradi.
  void _simulateProgress(String id) {
    _timers[id]?.cancel();
    _timers[id] = Timer(const Duration(seconds: 25), () async {
      await updateStatus(id, OrderStatus.processing);
      _timers[id] = Timer(const Duration(seconds: 40), () async {
        await updateStatus(id, OrderStatus.shipping);
      });
    });
  }

  Future<void> updateStatus(String id, OrderStatus status) async {
    final repo = ref.read(orderRepositoryProvider);
    final current = state.valueOrNull;
    final existing = current?.where((o) => o.id == id).firstOrNull;
    if (existing == null || !existing.status.isActive) return;
    await repo.updateStatus(id, status);
    state = AsyncData(await repo.getAll());
  }

  Future<void> cancel(String id) async {
    _timers[id]?.cancel();
    await updateStatus(id, OrderStatus.cancelled);
  }

  Future<void> refresh() async {
    state = AsyncData(await ref.read(orderRepositoryProvider).getAll());
  }
}

final ordersProvider = AsyncNotifierProvider<OrdersNotifier, List<Order>>(OrdersNotifier.new);

final orderByIdProvider = Provider.family<Order?, String>((ref, id) {
  final orders = ref.watch(ordersProvider).valueOrNull ?? const [];
  for (final o in orders) {
    if (o.id == id) return o;
  }
  return null;
});
