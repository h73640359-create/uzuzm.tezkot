import 'product.dart';

class CartItem {
  const CartItem({
    required this.product,
    required this.quantity,
    this.selected = true,
  });

  final Product product;
  final int quantity;
  final bool selected;

  int get total => product.price * quantity;
  int get oldTotal => (product.oldPrice ?? product.price) * quantity;

  CartItem copyWith({int? quantity, bool? selected}) => CartItem(
        product: product,
        quantity: quantity ?? this.quantity,
        selected: selected ?? this.selected,
      );

  Map<String, dynamic> toJson() => {
        'productId': product.id,
        'quantity': quantity,
        'selected': selected,
      };
}
