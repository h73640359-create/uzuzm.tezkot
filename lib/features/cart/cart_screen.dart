import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/config/app_config.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/formatters.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_image.dart';
import '../../core/widgets/app_snackbar.dart';
import '../../core/widgets/quantity_selector.dart';
import '../../core/widgets/state_views.dart';
import '../../core/widgets/wishlist_button.dart';
import '../../data/models/cart_item.dart';
import '../../navigation/app_routes.dart';
import '../../providers/cart_provider.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cart = ref.watch(cartProvider);
    final notifier = ref.read(cartProvider.notifier);
    final c = context.colors;

    return Scaffold(
      appBar: AppBar(
        title: Text(cart.isEmpty ? 'Savat' : 'Savat (${cart.count})'),
        actions: [
          if (!cart.isEmpty)
            TextButton(
              onPressed: () => _confirmClear(context, notifier),
              child: const Text('Tozalash', style: TextStyle(color: AppColors.danger)),
            ),
        ],
      ),
      body: cart.isEmpty
          ? EmptyView(
              icon: Icons.shopping_bag_outlined,
              title: "Savatingiz hozircha bo'sh",
              subtitle: "Bosh sahifadan o'zingizga yoqqan mahsulotlarni tanlang",
              actionLabel: 'Xaridni boshlash',
              onAction: () => context.go(AppRoutes.home),
            )
          : Column(
              children: [
                // Barchasini tanlash
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 0, 16, 0),
                  child: Row(
                    children: [
                      Checkbox(
                        value: cart.allSelected,
                        onChanged: (v) => notifier.selectAll(v ?? false),
                      ),
                      Text('Barchasini tanlash', style: context.text.bodyMedium),
                      const Spacer(),
                      Text('${cart.selected.length} ta tanlandi', style: context.text.labelSmall),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    physics: const BouncingScrollPhysics(),
                    itemCount: cart.items.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, i) => _CartTile(
                      key: ValueKey(cart.items[i].product.id),
                      item: cart.items[i],
                    ),
                  ),
                ),
              ],
            ),
      bottomNavigationBar: cart.isEmpty
          ? null
          : Container(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
              decoration: BoxDecoration(
                color: c.surface,
                border: Border(top: BorderSide(color: c.border)),
              ),
              child: SafeArea(
                top: false,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _SummaryRow('Mahsulotlar (${cart.selected.length})', Formatters.price(cart.subtotal)),
                    if (cart.discount > 0)
                      _SummaryRow('Chegirma', '-${Formatters.price(cart.discount)}', color: AppColors.danger),
                    _SummaryRow(
                      'Yetkazib berish',
                      cart.deliveryFee == 0 ? 'Bepul' : Formatters.price(cart.deliveryFee),
                      color: cart.deliveryFee == 0 ? AppColors.success : null,
                    ),
                    if (cart.deliveryFee > 0)
                      Padding(
                        padding: const EdgeInsets.only(top: 2, bottom: 4),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Yana ${Formatters.price(AppConfig.freeDeliveryThreshold - cart.itemsTotal)} xarid qiling — yetkazib berish bepul",
                            style: context.text.labelSmall?.copyWith(color: AppColors.accent),
                          ),
                        ),
                      ),
                    const Divider(height: 16),
                    Row(
                      children: [
                        Text('Umumiy summa', style: context.text.titleMedium),
                        const Spacer(),
                        Text(Formatters.price(cart.total), style: context.text.titleLarge?.copyWith(color: AppColors.primary)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    AppButton(
                      label: 'Buyurtma berish',
                      icon: Icons.arrow_forward_rounded,
                      onPressed: cart.selected.isEmpty ? null : () => context.push(AppRoutes.checkout),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Future<void> _confirmClear(BuildContext context, CartNotifier notifier) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Savatni tozalash'),
        content: const Text("Savatdagi barcha mahsulotlar o'chiriladi. Davom etasizmi?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Bekor qilish')),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("O'chirish", style: TextStyle(color: AppColors.danger)),
          ),
        ],
      ),
    );
    if (ok == true) notifier.clear();
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow(this.label, this.value, {this.color});
  final String label;
  final String value;
  final Color? color;
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 3),
        child: Row(
          children: [
            Text(label, style: context.text.bodyMedium?.copyWith(color: context.colors.textSecondary)),
            const Spacer(),
            Text(value, style: context.text.labelMedium?.copyWith(color: color)),
          ],
        ),
      );
}

class _CartTile extends ConsumerWidget {
  const _CartTile({super.key, required this.item});
  final CartItem item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final notifier = ref.read(cartProvider.notifier);
    final p = item.product;
    return Dismissible(
      key: ValueKey('dismiss-${p.id}'),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: AppColors.danger,
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        child: const Icon(Icons.delete_outline_rounded, color: Colors.white),
      ),
      onDismissed: (_) {
        notifier.remove(p.id);
        showAppSnackBar(
          context,
          "Mahsulot o'chirildi",
          icon: Icons.delete_outline_rounded,
          actionLabel: 'Qaytarish',
          onAction: () => notifier.add(p, quantity: item.quantity),
        );
      },
      child: AnimatedContainer(
        duration: AppDurations.normal,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: c.surface,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(color: item.selected ? Colors.transparent : c.border),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 28,
              child: Checkbox(
                value: item.selected,
                visualDensity: VisualDensity.compact,
                onChanged: (_) => notifier.toggleSelected(p.id),
              ),
            ),
            GestureDetector(
              onTap: () => context.push(AppRoutes.productPath(p.id)),
              child: AppImage(
                p.image,
                width: 84,
                height: 84,
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () => context.push(AppRoutes.productPath(p.id)),
                    child: Text(
                      p.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: context.text.bodyMedium?.copyWith(height: 1.25),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(p.sellerName, style: context.text.labelSmall, maxLines: 1, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 8),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (p.hasDiscount)
                              Text(
                                Formatters.price(item.oldTotal),
                                style: context.text.labelSmall?.copyWith(
                                  decoration: TextDecoration.lineThrough,
                                  color: c.textTertiary,
                                ),
                              ),
                            Text(
                              Formatters.price(item.total),
                              style: context.text.titleSmall?.copyWith(fontWeight: FontWeight.w800),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      QuantitySelector(
                        value: item.quantity,
                        max: p.stock,
                        compact: true,
                        onChanged: (v) => notifier.setQuantity(p.id, v),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Column(
              children: [
                WishlistButton(productId: p.id, size: 18, filledBackground: false, showSnack: false),
                IconButton(
                  visualDensity: VisualDensity.compact,
                  icon: Icon(Icons.delete_outline_rounded, size: 20, color: c.textSecondary),
                  onPressed: () => notifier.remove(p.id),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
