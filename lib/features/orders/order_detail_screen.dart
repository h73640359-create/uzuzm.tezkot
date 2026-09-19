import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/formatters.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_image.dart';
import '../../core/widgets/app_snackbar.dart';
import '../../core/widgets/state_views.dart';
import '../../data/models/order.dart';
import '../../data/sources/demo_products.dart';
import '../../navigation/app_routes.dart';
import '../../providers/cart_provider.dart';
import '../../providers/orders_provider.dart';
import 'order_status_chip.dart';

class OrderDetailScreen extends ConsumerWidget {
  const OrderDetailScreen({super.key, required this.orderId});
  final String orderId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final order = ref.watch(orderByIdProvider(orderId));
    final c = context.colors;
    if (order == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const EmptyView(icon: Icons.receipt_long_outlined, title: 'Buyurtma topilmadi'),
      );
    }
    return Scaffold(
      appBar: AppBar(title: Text('Buyurtma ${order.id}')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        physics: const BouncingScrollPhysics(),
        children: [
          // Status + timeline
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: c.surface, borderRadius: BorderRadius.circular(AppRadius.lg)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(child: Text(Formatters.dateTime(order.createdAt), style: context.text.bodySmall)),
                    OrderStatusChip(status: order.status),
                  ],
                ),
                const SizedBox(height: 16),
                _Timeline(status: order.status),
              ],
            ),
          ),
          const SizedBox(height: 12),
          _Block(
            title: 'Yetkazib berish',
            children: [
              _line(context, Icons.location_on_outlined, order.address),
              _line(context, Icons.phone_outlined, order.phone),
              _line(context, Icons.account_balance_wallet_outlined, order.paymentMethod.label),
              if (order.comment.isNotEmpty) _line(context, Icons.chat_bubble_outline_rounded, order.comment),
            ],
          ),
          const SizedBox(height: 12),
          _Block(
            title: 'Mahsulotlar (${order.itemCount})',
            children: [
              for (final item in order.items)
                InkWell(
                  onTap: () => context.push(AppRoutes.productPath(item.productId)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      children: [
                        AppImage(item.image, width: 56, height: 56, borderRadius: BorderRadius.circular(10)),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(item.name, maxLines: 2, overflow: TextOverflow.ellipsis, style: context.text.bodyMedium),
                              Text('${item.quantity} x ${Formatters.price(item.price)}', style: context.text.labelSmall),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(Formatters.price(item.total), style: context.text.labelMedium),
                      ],
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          _Block(
            title: "To'lov",
            children: [
              _row(context, 'Mahsulotlar', Formatters.price(order.subtotal)),
              if (order.discount > 0) _row(context, 'Chegirma', '-${Formatters.price(order.discount)}', color: AppColors.danger),
              _row(context, 'Yetkazib berish', order.deliveryFee == 0 ? 'Bepul' : Formatters.price(order.deliveryFee)),
              const Divider(height: 18),
              Row(
                children: [
                  Text('Jami', style: context.text.titleMedium),
                  const Spacer(),
                  Text(Formatters.price(order.total), style: context.text.titleMedium?.copyWith(color: AppColors.primary)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          if (order.status == OrderStatus.pending || order.status == OrderStatus.processing)
            AppButton(
              label: 'Buyurtmani bekor qilish',
              outlined: true,
              color: AppColors.danger,
              onPressed: () => _cancel(context, ref, order),
            ),
          if (order.status == OrderStatus.shipping)
            AppButton(
              label: 'Qabul qildim',
              icon: Icons.check_rounded,
              color: AppColors.success,
              onPressed: () => ref.read(ordersProvider.notifier).updateStatus(order.id, OrderStatus.delivered),
            ),
          if (order.status == OrderStatus.delivered || order.status == OrderStatus.cancelled)
            AppButton(
              label: 'Qayta buyurtma berish',
              icon: Icons.replay_rounded,
              onPressed: () {
                final cart = ref.read(cartProvider.notifier);
                var added = 0;
                for (final i in order.items) {
                  final p = DemoProducts.byId(i.productId);
                  if (p != null && p.inStock) {
                    cart.add(p, quantity: i.quantity);
                    added++;
                  }
                }
                showAppSnackBar(context, "$added ta mahsulot savatga qo'shildi", icon: Icons.shopping_bag_rounded);
                context.go(AppRoutes.cart);
              },
            ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Future<void> _cancel(BuildContext context, WidgetRef ref, Order order) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Buyurtmani bekor qilish'),
        content: Text('${order.id} buyurtmasini bekor qilmoqchimisiz?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Yo'q")),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Ha, bekor qilish', style: TextStyle(color: AppColors.danger)),
          ),
        ],
      ),
    );
    if (ok == true) {
      await ref.read(ordersProvider.notifier).cancel(order.id);
      if (context.mounted) showAppSnackBar(context, 'Buyurtma bekor qilindi', icon: Icons.cancel_outlined);
    }
  }

  Widget _line(BuildContext context, IconData icon, String text) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 18, color: context.colors.textSecondary),
            const SizedBox(width: 10),
            Expanded(child: Text(text, style: context.text.bodyMedium)),
          ],
        ),
      );

  Widget _row(BuildContext context, String l, String v, {Color? color}) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 3),
        child: Row(
          children: [
            Text(l, style: context.text.bodyMedium?.copyWith(color: context.colors.textSecondary)),
            const Spacer(),
            Text(v, style: context.text.labelMedium?.copyWith(color: color)),
          ],
        ),
      );
}

class _Block extends StatelessWidget {
  const _Block({required this.title, required this.children});
  final String title;
  final List<Widget> children;
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: context.colors.surface,
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: context.text.titleMedium),
            const SizedBox(height: 8),
            ...children,
          ],
        ),
      );
}

class _Timeline extends StatelessWidget {
  const _Timeline({required this.status});
  final OrderStatus status;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    if (status == OrderStatus.cancelled) {
      return Row(
        children: [
          const Icon(Icons.cancel_rounded, color: AppColors.danger),
          const SizedBox(width: 10),
          Expanded(child: Text('Buyurtma bekor qilingan', style: context.text.bodyMedium)),
        ],
      );
    }
    const steps = [OrderStatus.pending, OrderStatus.processing, OrderStatus.shipping, OrderStatus.delivered];
    final idx = steps.indexOf(status);
    return Row(
      children: [
        for (var i = 0; i < steps.length; i++) ...[
          Column(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: i <= idx ? orderStatusColor(steps[i]) : c.surfaceVariant,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  i < idx ? Icons.check_rounded : orderStatusIcon(steps[i]),
                  size: 16,
                  color: i <= idx ? Colors.white : c.textTertiary,
                ),
              ),
              const SizedBox(height: 6),
              SizedBox(
                width: 64,
                child: Text(
                  steps[i].label,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.text.labelSmall?.copyWith(
                    fontSize: 10,
                    color: i <= idx ? c.text : c.textTertiary,
                    fontWeight: i == idx ? FontWeight.w800 : FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          if (i != steps.length - 1)
            Expanded(
              child: Container(
                height: 3,
                margin: const EdgeInsets.only(bottom: 22),
                decoration: BoxDecoration(
                  color: i < idx ? AppColors.primary : c.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
        ],
      ],
    );
  }
}
