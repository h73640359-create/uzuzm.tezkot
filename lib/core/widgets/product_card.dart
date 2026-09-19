import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../data/models/product.dart';
import '../../navigation/app_routes.dart';
import '../../providers/cart_provider.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_theme.dart';
import '../utils/formatters.dart';
import 'app_image.dart';
import 'app_snackbar.dart';
import 'price_text.dart';
import 'shimmer_box.dart';
import 'wishlist_button.dart';

/// Mahsulot kartasi (grid va gorizontal ro'yxatlar uchun).
class ProductCard extends ConsumerStatefulWidget {
  const ProductCard({super.key, required this.product, this.width});
  final Product product;
  final double? width;

  @override
  ConsumerState<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends ConsumerState<ProductCard> {
  bool _pressed = false;

  Product get p => widget.product;

  void _addToCart() {
    if (!p.inStock) return;
    HapticFeedback.mediumImpact();
    ref.read(cartProvider.notifier).add(p);
    showAppSnackBar(
      context,
      "Savatga qo'shildi",
      icon: Icons.shopping_bag_rounded,
      actionLabel: 'Savat',
      onAction: () => context.go(AppRoutes.cart),
    );
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final inCart = ref.watch(cartProvider.select((s) => s.contains(p.id)));

    return AnimatedScale(
      scale: _pressed ? 0.97 : 1,
      duration: AppDurations.fast,
      child: SizedBox(
        width: widget.width,
        child: Material(
          color: c.surface,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: () => context.push(AppRoutes.productPath(p.id)),
            onHighlightChanged: (v) => setState(() => _pressed = v),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ---- Rasm ----
                Stack(
                  children: [
                    AspectRatio(
                      aspectRatio: 1,
                      child: AppImage(p.image, width: double.infinity),
                    ),
                    if (p.hasDiscount)
                      Positioned(
                        left: 8,
                        top: 8,
                        child: _Badge('-${p.discountPercent}%', AppColors.danger),
                      ),
                    if (!p.inStock)
                      Positioned(
                        left: 8,
                        bottom: 8,
                        child: _Badge('Tugagan', c.textSecondary),
                      ),
                    Positioned(
                      right: 6,
                      top: 6,
                      child: WishlistButton(productId: p.id, size: 18),
                    ),
                  ],
                ),
                // ---- Matn ----
                Expanded(
                  child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                        child: Text(
                          p.name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: context.text.bodySmall?.copyWith(
                            color: c.text,
                            fontSize: 12.5,
                            height: 1.25,
                          ),
                        ),
                      ),
                      const Spacer(),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.star_rounded, size: 14, color: AppColors.star),
                          const SizedBox(width: 2),
                          Text(
                            p.rating.toStringAsFixed(1),
                            style: context.text.labelSmall?.copyWith(color: c.text),
                          ),
                          const SizedBox(width: 6),
                          Flexible(
                            child: Text(
                              '${Formatters.compact(p.soldCount)} sotilgan',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: context.text.labelSmall?.copyWith(fontSize: 10.5),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(child: PriceText(price: p.price, oldPrice: p.oldPrice)),
                          const SizedBox(width: 6),
                          _CartButton(
                            active: inCart,
                            enabled: p.inStock,
                            onTap: _addToCart,
                          ),
                        ],
                      ),
                    ],
                  ),
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

class _CartButton extends StatelessWidget {
  const _CartButton({required this.active, required this.enabled, required this.onTap});
  final bool active;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Material(
      color: !enabled
          ? c.surfaceVariant
          : active
              ? AppColors.primary
              : AppColors.primary.withValues(alpha: 0.1),
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: enabled ? onTap : null,
        borderRadius: BorderRadius.circular(10),
        child: SizedBox(
          width: 34,
          height: 34,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            transitionBuilder: (child, a) => ScaleTransition(scale: a, child: child),
            child: Icon(
              active ? Icons.check_rounded : Icons.add_shopping_cart_rounded,
              key: ValueKey(active),
              size: 18,
              color: !enabled
                  ? c.textTertiary
                  : active
                      ? Colors.white
                      : AppColors.primary,
            ),
          ),
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge(this.text, this.color);
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
        decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(8)),
        child: Text(
          text,
          style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w800),
        ),
      );
}

/// Yuklanish paytida ko'rsatiladigan skelet karta.
class ProductCardSkeleton extends StatelessWidget {
  const ProductCardSkeleton({super.key, this.width});
  final double? width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Container(
        decoration: BoxDecoration(
          color: context.colors.surface,
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AspectRatio(aspectRatio: 1, child: ShimmerBox(radius: 18)),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  ShimmerBox(height: 12, width: double.infinity, radius: 6),
                  SizedBox(height: 6),
                  ShimmerBox(height: 12, width: 100, radius: 6),
                  SizedBox(height: 10),
                  ShimmerBox(height: 10, width: 80, radius: 6),
                  SizedBox(height: 10),
                  ShimmerBox(height: 16, width: 110, radius: 6),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Ekran kengligiga moslashuvchi mahsulot gridi (sliver).
class ProductSliverGrid extends StatelessWidget {
  const ProductSliverGrid({super.key, required this.products, this.padding});
  final List<Product> products;
  final EdgeInsets? padding;

  static int columnsFor(double width) {
    if (width >= 1100) return 5;
    if (width >= 800) return 4;
    if (width >= 560) return 3;
    return 2;
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final cols = columnsFor(width);
    final pad = padding ?? const EdgeInsets.fromLTRB(16, 8, 16, 24);
    final itemWidth = (width - pad.horizontal - (cols - 1) * 10) / cols;
    // rasm (kvadrat) + matn qismi (~128px)
    final itemHeight = itemWidth + 128;
    return SliverPadding(
      padding: pad,
      sliver: SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: cols,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: itemWidth / itemHeight,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, i) => _FadeIn(
            index: i,
            child: ProductCard(product: products[i]),
          ),
          childCount: products.length,
        ),
      ),
    );
  }
}

class ProductSliverGridSkeleton extends StatelessWidget {
  const ProductSliverGridSkeleton({super.key, this.count = 6});
  final int count;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final cols = ProductSliverGrid.columnsFor(width);
    final itemWidth = (width - 32 - (cols - 1) * 10) / cols;
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      sliver: SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: cols,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: itemWidth / (itemWidth + 128),
        ),
        delegate: SliverChildBuilderDelegate(
          (context, i) => const ProductCardSkeleton(),
          childCount: count,
        ),
      ),
    );
  }
}

/// Gorizontal mahsulotlar ro'yxati (bosh sahifa bo'limlari uchun).
class ProductHorizontalList extends StatelessWidget {
  const ProductHorizontalList({super.key, required this.products, this.loading = false});
  final List<Product> products;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final cardWidth = (width * 0.42).clamp(150.0, 190.0);
    final height = cardWidth + 128;
    return SizedBox(
      height: height,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: loading ? 4 : products.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, i) => loading
            ? ProductCardSkeleton(width: cardWidth)
            : _FadeIn(index: i, child: ProductCard(product: products[i], width: cardWidth)),
      ),
    );
  }
}

/// Elementlar paydo bo'lishida yengil fade+slide animatsiyasi.
class _FadeIn extends StatefulWidget {
  const _FadeIn({required this.child, required this.index});
  final Widget child;
  final int index;

  @override
  State<_FadeIn> createState() => _FadeInState();
}

class _FadeInState extends State<_FadeIn> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 320),
  );

  @override
  void initState() {
    super.initState();
    final delay = (widget.index.clamp(0, 8)) * 40;
    Future<void>.delayed(Duration(milliseconds: delay), () {
      if (mounted) _c.forward();
    });
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final a = CurvedAnimation(parent: _c, curve: Curves.easeOutCubic);
    return FadeTransition(
      opacity: a,
      child: SlideTransition(
        position: Tween(begin: const Offset(0, 0.05), end: Offset.zero).animate(a),
        child: widget.child,
      ),
    );
  }
}
