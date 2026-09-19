import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/formatters.dart';
import '../../core/widgets/app_button.dart';
import '../../data/models/order.dart';
import '../../navigation/app_routes.dart';
import '../../providers/orders_provider.dart';

class OrderSuccessScreen extends ConsumerStatefulWidget {
  const OrderSuccessScreen({super.key, required this.orderId});
  final String orderId;

  @override
  ConsumerState<OrderSuccessScreen> createState() => _OrderSuccessScreenState();
}

class _OrderSuccessScreenState extends ConsumerState<OrderSuccessScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 900))..forward();

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final order = ref.watch(orderByIdProvider(widget.orderId));
    final scale = CurvedAnimation(parent: _c, curve: const Interval(0, 0.6, curve: Curves.elasticOut));
    final fade = CurvedAnimation(parent: _c, curve: const Interval(0.4, 1, curve: Curves.easeOut));

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) context.go(AppRoutes.home);
      },
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const Spacer(),
                ScaleTransition(
                  scale: scale,
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: AppColors.success.withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.check_rounded, size: 64, color: AppColors.success),
                  ),
                ),
                const SizedBox(height: 24),
                FadeTransition(
                  opacity: fade,
                  child: Column(
                    children: [
                      Text('Buyurtma qabul qilindi!', style: context.text.headlineSmall, textAlign: TextAlign.center),
                      const SizedBox(height: 8),
                      Text(
                        'Buyurtma raqami: ${widget.orderId}',
                        style: context.text.titleMedium?.copyWith(color: AppColors.primary),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        order != null
                            ? "Jami: ${Formatters.price(order.total)} • ${order.paymentMethod.label}\nTez orada operator siz bilan bog'lanadi."
                            : "Tez orada operator siz bilan bog'lanadi.",
                        textAlign: TextAlign.center,
                        style: context.text.bodyMedium?.copyWith(color: context.colors.textSecondary),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                FadeTransition(
                  opacity: fade,
                  child: Column(
                    children: [
                      AppButton(
                        label: "Buyurtmani ko'rish",
                        onPressed: () {
                          context.go(AppRoutes.orders);
                          context.push(AppRoutes.orderDetailPath(widget.orderId));
                        },
                      ),
                      const SizedBox(height: 10),
                      AppButton(
                        label: 'Xaridni davom ettirish',
                        outlined: true,
                        onPressed: () => context.go(AppRoutes.home),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
