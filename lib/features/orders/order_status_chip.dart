import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../data/models/order.dart';

Color orderStatusColor(OrderStatus s) => switch (s) {
      OrderStatus.pending => AppColors.accent,
      OrderStatus.processing => AppColors.info,
      OrderStatus.shipping => const Color(0xFF7C3AED),
      OrderStatus.delivered => AppColors.success,
      OrderStatus.cancelled => AppColors.danger,
    };

IconData orderStatusIcon(OrderStatus s) => switch (s) {
      OrderStatus.pending => Icons.hourglass_top_rounded,
      OrderStatus.processing => Icons.inventory_2_outlined,
      OrderStatus.shipping => Icons.local_shipping_outlined,
      OrderStatus.delivered => Icons.check_circle_outline_rounded,
      OrderStatus.cancelled => Icons.cancel_outlined,
    };

class OrderStatusChip extends StatelessWidget {
  const OrderStatusChip({super.key, required this.status});
  final OrderStatus status;

  @override
  Widget build(BuildContext context) {
    final color = orderStatusColor(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(orderStatusIcon(status), size: 14, color: color),
          const SizedBox(width: 5),
          Text(
            status.label,
            style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}
