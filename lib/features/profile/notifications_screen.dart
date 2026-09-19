import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/formatters.dart';
import '../../core/widgets/state_views.dart';
import '../../data/models/order.dart';
import '../../providers/orders_provider.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orders = ref.watch(ordersProvider).valueOrNull ?? const [];
    final c = context.colors;
    final items = <_Notif>[
      for (final o in orders)
        _Notif(
          icon: Icons.receipt_long_rounded,
          color: AppColors.primary,
          title: 'Buyurtma ${o.id}',
          body: 'Holati: ${o.status.label}. Jami ${Formatters.price(o.total)}',
          date: o.createdAt,
        ),
      _Notif(
        icon: Icons.local_offer_rounded,
        color: AppColors.accent,
        title: 'Kuzgi chegirmalar boshlandi!',
        body: 'Elektronika va maishiy texnikaga 25% gacha chegirma.',
        date: DateTime.now().subtract(const Duration(days: 1)),
      ),
      _Notif(
        icon: Icons.local_shipping_rounded,
        color: AppColors.success,
        title: 'Bepul yetkazib berish',
        body: "300 000 so'mdan yuqori buyurtmalarga yetkazib berish bepul.",
        date: DateTime.now().subtract(const Duration(days: 3)),
      ),
    ]..sort((a, b) => b.date.compareTo(a.date));

    return Scaffold(
      appBar: AppBar(title: const Text('Bildirishnomalar')),
      body: items.isEmpty
          ? const EmptyView(icon: Icons.notifications_none_rounded, title: "Bildirishnomalar yo'q")
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: items.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, i) {
                final n = items[i];
                return Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(color: c.surface, borderRadius: BorderRadius.circular(AppRadius.lg)),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(color: n.color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(12)),
                        child: Icon(n.icon, color: n.color, size: 20),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(n.title, style: context.text.titleSmall),
                            const SizedBox(height: 2),
                            Text(n.body, style: context.text.bodySmall),
                            const SizedBox(height: 4),
                            Text(Formatters.dateTime(n.date), style: context.text.labelSmall?.copyWith(color: c.textTertiary)),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}

class _Notif {
  const _Notif({required this.icon, required this.color, required this.title, required this.body, required this.date});
  final IconData icon;
  final Color color;
  final String title;
  final String body;
  final DateTime date;
}
