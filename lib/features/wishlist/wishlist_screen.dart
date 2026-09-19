import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../core/widgets/app_snackbar.dart';
import '../../core/widgets/product_card.dart';
import '../../core/widgets/state_views.dart';
import '../../navigation/app_routes.dart';
import '../../providers/cart_provider.dart';
import '../../providers/wishlist_provider.dart';

class WishlistScreen extends ConsumerWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final products = ref.watch(wishlistProductsProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(products.isEmpty ? 'Sevimlilar' : 'Sevimlilar (${products.length})'),
        actions: [
          if (products.isNotEmpty)
            TextButton(
              onPressed: () {
                final cart = ref.read(cartProvider.notifier);
                var n = 0;
                for (final p in products) {
                  if (p.inStock) {
                    cart.add(p);
                    n++;
                  }
                }
                showAppSnackBar(context, "$n ta mahsulot savatga qo'shildi", icon: Icons.shopping_bag_rounded);
              },
              child: const Text('Hammasini savatga'),
            ),
        ],
      ),
      body: products.isEmpty
          ? EmptyView(
              icon: Icons.favorite_border_rounded,
              title: "Sevimlilar ro'yxati bo'sh",
              subtitle: "Yoqqan mahsulotlaringizni ♥ belgisi orqali saqlang",
              actionLabel: "Mahsulotlarni ko'rish",
              onAction: () => context.go(AppRoutes.home),
            )
          : CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                ProductSliverGrid(products: products, padding: const EdgeInsets.fromLTRB(16, 8, 16, 24)),
                SliverToBoxAdapter(
                  child: Center(
                    child: TextButton.icon(
                      onPressed: () => ref.read(wishlistProvider.notifier).clear(),
                      icon: const Icon(Icons.delete_outline_rounded, color: AppColors.danger, size: 18),
                      label: const Text("Ro'yxatni tozalash", style: TextStyle(color: AppColors.danger)),
                    ),
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 16)),
              ],
            ),
    );
  }
}
