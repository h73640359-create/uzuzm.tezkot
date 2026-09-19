import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/formatters.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_image.dart';
import '../../core/widgets/app_snackbar.dart';
import '../../core/widgets/price_text.dart';
import '../../core/widgets/product_card.dart';
import '../../core/widgets/quantity_selector.dart';
import '../../core/widgets/rating_stars.dart';
import '../../core/widgets/section_header.dart';
import '../../core/widgets/state_views.dart';
import '../../core/widgets/wishlist_button.dart';
import '../../data/models/models.dart';
import '../../navigation/app_routes.dart';
import '../../providers/cart_provider.dart';
import '../../providers/catalog_providers.dart';
import '../../providers/repository_providers.dart';
import 'widgets/image_gallery.dart';

class ProductDetailScreen extends ConsumerStatefulWidget {
  const ProductDetailScreen({super.key, required this.productId});
  final String productId;

  @override
  ConsumerState<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends ConsumerState<ProductDetailScreen> {
  int _qty = 1;
  bool _descExpanded = false;

  void _addToCart(Product p, {bool buyNow = false}) {
    HapticFeedback.mediumImpact();
    ref.read(cartProvider.notifier).add(p, quantity: _qty);
    if (buyNow) {
      // Faqat shu mahsulotni tanlangan qilib checkoutga o'tamiz
      final cart = ref.read(cartProvider.notifier);
      for (final item in ref.read(cartProvider).items) {
        if (item.product.id != p.id && item.selected) cart.toggleSelected(item.product.id);
        if (item.product.id == p.id && !item.selected) cart.toggleSelected(item.product.id);
      }
      context.push(AppRoutes.checkout);
    } else {
      showAppSnackBar(
        context,
        "Savatga qo'shildi",
        icon: Icons.shopping_bag_rounded,
        actionLabel: 'Savat',
        onAction: () => context.go(AppRoutes.cart),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final async = ref.watch(productByIdProvider(widget.productId));
    return async.when(
      loading: () => const Scaffold(body: LoadingView()),
      error: (e, _) => Scaffold(
        appBar: AppBar(),
        body: ErrorView(onRetry: () => ref.invalidate(productByIdProvider(widget.productId))),
      ),
      data: (p) {
        if (p == null) {
          return Scaffold(
            appBar: AppBar(),
            body: const EmptyView(icon: Icons.search_off_rounded, title: 'Mahsulot topilmadi'),
          );
        }
        return _buildContent(p);
      },
    );
  }

  Widget _buildContent(Product p) {
    final c = context.colors;
    final cartQty = ref.watch(cartProvider.select((s) => s.quantityOf(p.id)));
    final category = ref.read(categoryRepositoryProvider).byId(p.categoryId);
    final width = MediaQuery.sizeOf(context).width;
    final imageHeight = (width * 0.95).clamp(280.0, 460.0);

    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            expandedHeight: imageHeight,
            pinned: true,
            stretch: true,
            backgroundColor: c.background,
            leading: _CircleBtn(icon: Icons.arrow_back_rounded, onTap: () => context.pop()),
            actions: [
              _CircleBtn(
                icon: Icons.share_outlined,
                onTap: () => showAppSnackBar(context, 'Havola nusxalandi', icon: Icons.link_rounded),
              ),
              const SizedBox(width: 6),
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: Container(
                  decoration: BoxDecoration(color: c.surface, shape: BoxShape.circle),
                  child: WishlistButton(productId: p.id, size: 22, filledBackground: false),
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              stretchModes: const [StretchMode.zoomBackground],
              background: ImageGallery(images: p.images, heroTag: 'product-${p.id}'),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              decoration: BoxDecoration(
                color: c.surface,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
              ),
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Brend va kategoriya
                  Row(
                    children: [
                      if (p.brand.isNotEmpty) ...[
                        _Tag(p.brand, AppColors.primary),
                        const SizedBox(width: 8),
                      ],
                      if (category != null)
                        Flexible(
                          child: InkWell(
                            onTap: () => context.push(AppRoutes.categoryPath(category.id)),
                            child: Text(
                              '${category.name} › ${p.subcategory}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: context.text.labelSmall,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(p.name, style: context.text.titleLarge?.copyWith(height: 1.25)),
                  const SizedBox(height: 10),
                  // Reyting
                  Row(
                    children: [
                      RatingStars(rating: p.rating, size: 16),
                      const SizedBox(width: 6),
                      Text(p.rating.toStringAsFixed(1), style: context.text.labelMedium),
                      const SizedBox(width: 6),
                      Text('(${p.reviewCount} sharh)', style: context.text.labelSmall),
                      const SizedBox(width: 10),
                      Container(width: 3, height: 3, decoration: BoxDecoration(color: c.textTertiary, shape: BoxShape.circle)),
                      const SizedBox(width: 10),
                      Flexible(
                        child: Text(
                          '${Formatters.compact(p.soldCount)} marta sotilgan',
                          style: context.text.labelSmall,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  // Narx
                  PriceText(price: p.price, oldPrice: p.oldPrice, large: true, showBadge: true),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.accentSoft,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      "${Formatters.price(p.monthlyPayment)} x 12 oy muddatli to'lov",
                      style: context.text.labelSmall?.copyWith(color: const Color(0xFF7C4A03)),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Mavjudlik + miqdor
                  Row(
                    children: [
                      Icon(
                        p.inStock ? Icons.check_circle_rounded : Icons.cancel_rounded,
                        size: 18,
                        color: p.inStock ? AppColors.success : AppColors.danger,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          p.inStock
                              ? (p.stock <= 10 ? 'Faqat ${p.stock} ta qoldi' : 'Sotuvda mavjud')
                              : 'Sotuvda yo\'q',
                          style: context.text.labelMedium?.copyWith(
                            color: p.inStock ? AppColors.success : AppColors.danger,
                          ),
                        ),
                      ),
                      if (p.inStock)
                        QuantitySelector(
                          value: _qty,
                          max: p.stock,
                          onChanged: (v) => setState(() => _qty = v),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          // Yetkazib berish va sotuvchi
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: Column(
                children: [
                  _InfoCard(
                    icon: Icons.local_shipping_outlined,
                    color: AppColors.info,
                    title: 'Yetkazib berish',
                    subtitle: 'Toshkent bo\'ylab 1–2 kun • Viloyatlarga 2–5 kun',
                    trailing: p.price >= 300000 ? 'Bepul' : Formatters.price(15000),
                  ),
                  const SizedBox(height: 10),
                  _InfoCard(
                    icon: Icons.storefront_outlined,
                    color: AppColors.primary,
                    title: p.sellerName,
                    subtitle: 'Rasmiy sotuvchi • 98% ijobiy sharhlar',
                    trailing: 'Do\'kon',
                  ),
                  const SizedBox(height: 10),
                  _InfoCard(
                    icon: Icons.verified_user_outlined,
                    color: AppColors.success,
                    title: 'Qaytarish kafolati',
                    subtitle: '14 kun ichida sababsiz qaytarish',
                  ),
                ],
              ),
            ),
          ),
          // Tavsif
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Tavsif', style: context.text.titleMedium),
                  const SizedBox(height: 8),
                  AnimatedSize(
                    duration: const Duration(milliseconds: 250),
                    alignment: Alignment.topCenter,
                    child: Text(
                      p.description,
                      maxLines: _descExpanded ? null : 3,
                      overflow: _descExpanded ? null : TextOverflow.ellipsis,
                      style: context.text.bodyMedium?.copyWith(color: c.textSecondary, height: 1.5),
                    ),
                  ),
                  if (p.description.length > 120)
                    TextButton(
                      style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: Size.zero),
                      onPressed: () => setState(() => _descExpanded = !_descExpanded),
                      child: Text(_descExpanded ? 'Yopish' : "Batafsil o'qish"),
                    ),
                ],
              ),
            ),
          ),
          // Xususiyatlar
          if (p.specs.isNotEmpty)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Xususiyatlari', style: context.text.titleMedium),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: c.surface,
                        borderRadius: BorderRadius.circular(AppRadius.lg),
                      ),
                      child: Column(
                        children: [
                          for (final (i, e) in p.specs.entries.indexed)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
                              decoration: BoxDecoration(
                                border: i == 0
                                    ? null
                                    : Border(top: BorderSide(color: c.border)),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: Text(e.key, style: context.text.bodySmall),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: Text(e.value, style: context.text.bodyMedium),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          // Sharhlar
          SliverToBoxAdapter(child: _ReviewsSection(product: p)),
          // O'xshash mahsulotlar
          SliverToBoxAdapter(child: _SimilarSection(productId: p.id)),
          const SliverToBoxAdapter(child: SizedBox(height: 24)),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
        decoration: BoxDecoration(
          color: c.surface,
          border: Border(top: BorderSide(color: c.border)),
        ),
        child: SafeArea(
          top: false,
          child: Row(
            children: [
              Expanded(
                child: AppButton(
                  label: cartQty > 0 ? 'Savatda ($cartQty)' : "Savatga qo'shish",
                  icon: cartQty > 0 ? Icons.check_rounded : Icons.shopping_bag_outlined,
                  outlined: true,
                  onPressed: p.inStock ? () => _addToCart(p) : null,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: AppButton(
                  label: 'Hozir sotib olish',
                  onPressed: p.inStock ? () => _addToCart(p, buyNow: true) : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CircleBtn extends StatelessWidget {
  const _CircleBtn({required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => Center(
        child: Material(
          color: context.colors.surface,
          shape: const CircleBorder(),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onTap,
            child: SizedBox(width: 40, height: 40, child: Icon(icon, size: 22, color: context.colors.text)),
          ),
        ),
      );
}

class _Tag extends StatelessWidget {
  const _Tag(this.text, this.color);
  final String text;
  final Color color;
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(text, style: context.text.labelSmall?.copyWith(color: color, fontWeight: FontWeight.w800)),
      );
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
    this.trailing,
  });
  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  final String? trailing;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: context.text.titleSmall, maxLines: 1, overflow: TextOverflow.ellipsis),
                Text(subtitle, style: context.text.labelSmall, maxLines: 2, overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
          if (trailing != null) ...[
            const SizedBox(width: 8),
            Text(trailing!, style: context.text.labelMedium?.copyWith(color: color)),
          ],
        ],
      ),
    );
  }
}

class _ReviewsSection extends ConsumerWidget {
  const _ReviewsSection({required this.product});
  final Product product;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(productReviewsProvider(product.id));
    final c = context.colors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(title: 'Sharhlar (${product.reviewCount})'),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: c.surface, borderRadius: BorderRadius.circular(AppRadius.lg)),
            child: Row(
              children: [
                Column(
                  children: [
                    Text(product.rating.toStringAsFixed(1), style: context.text.headlineMedium),
                    RatingStars(rating: product.rating, size: 14),
                    const SizedBox(height: 2),
                    Text('${product.reviewCount} baho', style: context.text.labelSmall),
                  ],
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    children: [
                      for (var s = 5; s >= 1; s--)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2),
                          child: Row(
                            children: [
                              Text('$s', style: context.text.labelSmall),
                              const SizedBox(width: 6),
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(4),
                                  child: LinearProgressIndicator(
                                    value: _share(product.rating, s),
                                    minHeight: 6,
                                    backgroundColor: c.surfaceVariant,
                                    color: AppColors.star,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
        async.when(
          loading: () => const Padding(padding: EdgeInsets.all(16), child: LoadingView()),
          error: (_, __) => const SizedBox.shrink(),
          data: (reviews) => Column(
            children: [
              for (final r in reviews)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(color: c.surface, borderRadius: BorderRadius.circular(AppRadius.md)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 16,
                              backgroundColor: AppColors.primary.withValues(alpha: 0.12),
                              child: Text(
                                r.userName[0],
                                style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w800),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(r.userName, style: context.text.titleSmall),
                                  Text(Formatters.date(r.createdAt), style: context.text.labelSmall),
                                ],
                              ),
                            ),
                            RatingStars(rating: r.rating.toDouble(), size: 14),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(r.comment, style: context.text.bodyMedium?.copyWith(color: c.textSecondary, height: 1.4)),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  static double _share(double rating, int star) {
    // Reytingga qarab taxminiy taqsimot
    final base = switch (star) {
      5 => 0.55 + (rating - 4.5) * 0.6,
      4 => 0.25,
      3 => 0.10,
      2 => 0.05,
      _ => 0.03,
    };
    return base.clamp(0.02, 0.95);
  }
}

class _SimilarSection extends ConsumerWidget {
  const _SimilarSection({required this.productId});
  final String productId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(similarProductsProvider(productId));
    return async.when(
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
      data: (list) => list.isEmpty
          ? const SizedBox.shrink()
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SectionHeader(title: "O'xshash mahsulotlar"),
                ProductHorizontalList(products: list),
              ],
            ),
    );
  }
}
