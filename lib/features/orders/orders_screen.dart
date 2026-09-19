import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/formatters.dart';
import '../../core/widgets/app_image.dart';
import '../../core/widgets/state_views.dart';
import '../../data/models/order.dart';
import '../../navigation/app_routes.dart';
import '../../providers/orders_provider.dart';
import 'order_status_chip.dart';

class OrdersScreen extends ConsumerStatefulWidget {
  const OrdersScreen({super.key});

  @override
  ConsumerState<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends ConsumerState<OrdersScreen> {
  OrderStatus? _filter; // null = barchasi

  @override
  Widget build(BuildContext context) {
    final async = ref.watch(ordersProvider);
    final c = context.colors;
    return Scaffold(
      appBar: AppBar(title: const Text('Buyurtmalar')),
      body: Column(
        children: [
          SizedBox(
            height: 44,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _chip(null, 'Barchasi'),
                for (final s in OrderStatus.values) _chip(s, s.label),
              ],
            ),
          ),
          const SizedBox(height: 4),
          Expanded(
            child: async.when(
              loading: () => const LoadingView(),
              error: (e, _) => ErrorView(onRetry: () => ref.invalidate(ordersProvider)),
              data: (orders) {
                final list = _filter == null ? orders : orders.where((o) => o.status == _filter).toList();
                if (list.isEmpty) {
                  return EmptyView(
                    icon: Icons.receipt_long_outlined,
                    title: orders.isEmpty ? "Buyurtmalar yo'q" : 'Bu bo\'limda buyurtma yo\'q',
                    subtitle: orders.isEmpty
                        ? 'Birinchi buyurtmangizni bering — tarix shu yerda ko\'rinadi'
                        : null,
                    actionLabel: orders.isEmpty ? 'Xaridni boshlash' : null,
                    onAction: orders.isEmpty ? () => context.go(AppRoutes.home) : null,
                  );
                }
                return RefreshIndicator(
                  color: AppColors.primary,
                  onRefresh: () => ref.read(ordersProvider.notifier).refresh(),
                  child: ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                    physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                    itemCount: list.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, i) => _OrderCard(order: list[i]),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _chip(OrderStatus? s, String label) {
    final selected = _filter == s;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: selected,
        labelStyle: context.text.labelMedium?.copyWith(color: selected ? Colors.white : context.colors.text),
        onSelected: (_) => setState(() => _filter = s),
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  const _OrderCard({required this.order});
  final Order order;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Material(
      color: c.surface,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => context.push(AppRoutes.orderDetailPath(order.id)),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Buyurtma ${order.id}', style: context.text.titleSmall),
                        Text(Formatters.dateTime(order.createdAt), style: context.text.labelSmall),
                      ],
                    ),
                  ),
                  OrderStatusChip(status: order.status),
                ],
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 56,
                child: Row(
                  children: [
                    for (final item in order.items.take(4))
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: AppImage(item.image, width: 56, height: 56, borderRadius: BorderRadius.circular(10)),
                      ),
                    if (order.items.length > 4)
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: c.surfaceVariant,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        alignment: Alignment.center,
                        child: Text('+${order.items.length - 4}', style: context.text.labelMedium),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Text('${order.itemCount} ta mahsulot', style: context.text.bodySmall),
                  const Spacer(),
                  Text(Formatters.price(order.total), style: context.text.titleSmall?.copyWith(color: AppColors.primary)),
                  const SizedBox(width: 4),
                  Icon(Icons.chevron_right_rounded, color: c.textTertiary),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
