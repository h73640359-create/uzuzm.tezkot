import 'dart:math';

import '../models/order.dart';
import '../sources/local_storage.dart';

abstract class OrderRepository {
  Future<List<Order>> getAll();
  Future<Order> create(Order order);
  Future<void> updateStatus(String id, OrderStatus status);
  String generateId();
}

/// Buyurtmalar lokal saqlanadi. Backend ulanganda bu yerda HTTP so'rovlar bo'ladi.
class LocalOrderRepository implements OrderRepository {
  LocalOrderRepository(this._storage);
  final LocalStorage _storage;

  @override
  Future<List<Order>> getAll() async {
    final raw = _storage.readOrders();
    final orders = raw.map(Order.fromJson).toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return orders;
  }

  @override
  Future<Order> create(Order order) async {
    final list = await getAll();
    list.insert(0, order);
    await _storage.writeOrders(list.map((o) => o.toJson()).toList());
    return order;
  }

  @override
  Future<void> updateStatus(String id, OrderStatus status) async {
    final list = await getAll();
    final idx = list.indexWhere((o) => o.id == id);
    if (idx == -1) return;
    list[idx] = list[idx].copyWith(status: status);
    await _storage.writeOrders(list.map((o) => o.toJson()).toList());
  }

  @override
  String generateId() {
    final r = Random();
    final n = List.generate(6, (_) => r.nextInt(10)).join();
    return 'BG-$n';
  }
}
