enum OrderStatus { pending, processing, shipping, delivered, cancelled }

extension OrderStatusX on OrderStatus {
  String get label => switch (this) {
        OrderStatus.pending => 'Kutilmoqda',
        OrderStatus.processing => 'Tayyorlanmoqda',
        OrderStatus.shipping => "Yo'lda",
        OrderStatus.delivered => 'Yetkazildi',
        OrderStatus.cancelled => 'Bekor qilingan',
      };

  bool get isActive =>
      this == OrderStatus.pending ||
      this == OrderStatus.processing ||
      this == OrderStatus.shipping;
}

enum PaymentMethod { cash, card, online }

extension PaymentMethodX on PaymentMethod {
  String get label => switch (this) {
        PaymentMethod.cash => 'Naqd pul',
        PaymentMethod.card => 'Bank kartasi',
        PaymentMethod.online => "Onlayn to'lov",
      };

  String get description => switch (this) {
        PaymentMethod.cash => 'Yetkazib berilganda naqd to\'lov',
        PaymentMethod.card => 'UzCard / Humo / Visa (DEMO)',
        PaymentMethod.online => 'Payme / Click / Uzum (DEMO)',
      };
}

class OrderItem {
  const OrderItem({
    required this.productId,
    required this.name,
    required this.image,
    required this.price,
    required this.quantity,
  });

  final String productId;
  final String name;
  final String image;
  final int price;
  final int quantity;

  int get total => price * quantity;

  factory OrderItem.fromJson(Map<String, dynamic> j) => OrderItem(
        productId: j['productId'] as String,
        name: j['name'] as String,
        image: j['image'] as String? ?? '',
        price: j['price'] as int,
        quantity: j['quantity'] as int,
      );

  Map<String, dynamic> toJson() => {
        'productId': productId,
        'name': name,
        'image': image,
        'price': price,
        'quantity': quantity,
      };
}

class Order {
  const Order({
    required this.id,
    required this.createdAt,
    required this.items,
    required this.subtotal,
    required this.deliveryFee,
    required this.discount,
    required this.total,
    required this.status,
    required this.address,
    required this.phone,
    required this.paymentMethod,
    this.comment = '',
  });

  final String id;
  final DateTime createdAt;
  final List<OrderItem> items;
  final int subtotal;
  final int deliveryFee;
  final int discount;
  final int total;
  final OrderStatus status;
  final String address;
  final String phone;
  final PaymentMethod paymentMethod;
  final String comment;

  int get itemCount => items.fold(0, (s, i) => s + i.quantity);

  Order copyWith({OrderStatus? status}) => Order(
        id: id,
        createdAt: createdAt,
        items: items,
        subtotal: subtotal,
        deliveryFee: deliveryFee,
        discount: discount,
        total: total,
        status: status ?? this.status,
        address: address,
        phone: phone,
        paymentMethod: paymentMethod,
        comment: comment,
      );

  factory Order.fromJson(Map<String, dynamic> j) => Order(
        id: j['id'] as String,
        createdAt: DateTime.parse(j['createdAt'] as String),
        items: (j['items'] as List)
            .map((e) => OrderItem.fromJson(e as Map<String, dynamic>))
            .toList(),
        subtotal: j['subtotal'] as int,
        deliveryFee: j['deliveryFee'] as int,
        discount: j['discount'] as int? ?? 0,
        total: j['total'] as int,
        status: OrderStatus.values[j['status'] as int],
        address: j['address'] as String,
        phone: j['phone'] as String,
        paymentMethod: PaymentMethod.values[j['paymentMethod'] as int],
        comment: j['comment'] as String? ?? '',
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'createdAt': createdAt.toIso8601String(),
        'items': items.map((e) => e.toJson()).toList(),
        'subtotal': subtotal,
        'deliveryFee': deliveryFee,
        'discount': discount,
        'total': total,
        'status': status.index,
        'address': address,
        'phone': phone,
        'paymentMethod': paymentMethod.index,
        'comment': comment,
      };
}
