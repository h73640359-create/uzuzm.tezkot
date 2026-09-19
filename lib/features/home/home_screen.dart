import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/config/app_config.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/product_card.dart';
import '../../core/widgets/section_header.dart';
import '../../core/widgets/state_views.dart';
import '../../data/models/models.dart';
import '../../navigation/app_routes.dart';
import '../../providers/catalog_providers.dart';
import '../../providers/wishlist_provider.dart';
import 'widgets/banner_carousel.dart';
import 'widgets/category_chips.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    return Scaffold(
      body: RefreshIndicator(
        color: AppColors.primary,
        onRefresh: () async {
          ref.invalidate(allProductsProvider);
          ref.invalidate(productsByTagProvider);
          ref.invalidate(recommendedProductsProvider);
          await ref.read(allProductsProvider.future);
        },
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          slivers: [
            SliverAppBar(
              floating: true,
              snap: true,
              backgroundColor: c.background,
              toolbarHeight: 60,
              titleSpacing: 16,
              title: const _Logo(),
              actions: [
                _RoundIconButton(
                  icon: Icons.favorite_border_rounded,
                  badge: ref.watch(wishlistProvider).length,
                  onTap: () => context.push(AppRoutes.wishlist),
                ),
                const SizedBox(width: 8),
                _RoundIconButton(
                  icon: Icons.notifications_none_rounded,
                  onTap: () => context.push(AppRoutes.notifications),
                ),
                const SizedBox(width: 16),
              ],
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(60),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
                  child: _SearchBar(onTap: () => context.push(AppRoutes.search)),
                ),
              ),
            ),
            const SliverToBoxAdapter(child: BannerCarousel()),
            const SliverToBoxAdapter(child: SizedBox(height: 4)),
            SliverToBoxAdapter(
              child: SectionHeader(
                title: 'Kategoriyalar',
                onAction: () => context.go(AppRoutes.categories),
              ),
            ),
            const SliverToBoxAdapter(child: CategoryChips()),
            _TagSection(
              title: 'Mashhur mahsulotlar',
              tag: 'popular',
              onAll: () => context.push(AppRoutes.collectionPath('popular')),
            ),
            const _RecommendedSection(),
            _TagSection(
              title: 'Chegirmalar',
              tag: 'sale',
              accent: true,
              onAll: () => context.push(AppRoutes.collectionPath('sale')),
            ),
            _TagSection(
              title: 'Yangi mahsulotlar',
              tag: 'new',
              onAll: () => context.push(AppRoutes.collectionPath('new')),
            ),
            _TagSection(
              title: "Eng ko'p sotilganlar",
              tag: 'bestseller',
              onAll: () => context.push(AppRoutes.collectionPath('bestseller')),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 24)),
          ],
        ),
      ),
    );
  }
}

class _Logo extends StatelessWidget {
  const _Logo();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 36,
          height: 36,
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(11),
          ),
          child: Image.asset('assets/images/logo_mark.png'),
        ),
        const SizedBox(width: 10),
        RichText(
          text: TextSpan(
            style: context.text.titleLarge?.copyWith(fontWeight: FontWeight.w800, letterSpacing: -0.5),
            children: const [
              TextSpan(text: 'Bozor'),
              TextSpan(text: 'Go', style: TextStyle(color: AppColors.primary)),
            ],
          ),
        ),
      ],
    );
  }
}

class _RoundIconButton extends StatelessWidget {
  const _RoundIconButton({required this.icon, required this.onTap, this.badge = 0});
  final IconData icon;
  final VoidCallback onTap;
  final int badge;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Material(
      color: c.surface,
      shape: CircleBorder(side: BorderSide(color: c.border)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          width: 40,
          height: 40,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Icon(icon, size: 22, color: c.text),
              if (badge > 0)
                Positioned(
                  right: 7,
                  top: 7,
                  child: Container(
                    width: 9,
                    height: 9,
                    decoration: BoxDecoration(
                      color: AppColors.danger,
                      shape: BoxShape.circle,
                      border: Border.all(color: c.surface, width: 1.5),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Hero(
      tag: 'search-bar',
      child: Material(
        color: c.surface,
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppRadius.md),
          child: Container(
            height: 46,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppRadius.md),
              border: Border.all(color: c.border),
            ),
            child: Row(
              children: [
                Icon(Icons.search_rounded, color: c.textSecondary),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Mahsulot yoki brend qidirish',
                    style: context.text.bodyMedium?.copyWith(color: c.textTertiary),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(9),
                  ),
                  child: const Icon(Icons.tune_rounded, size: 16, color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TagSection extends ConsumerWidget {
  const _TagSection({
    required this.title,
    required this.tag,
    required this.onAll,
    this.accent = false,
  });

  final String title;
  final String tag;
  final VoidCallback onAll;
  final bool accent;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(productsByTagProvider(tag));
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(
            title: accent ? '🔥 $title' : title,
            onAction: onAll,
          ),
          async.when(
            loading: () => const ProductHorizontalList(products: [], loading: true),
            error: (e, _) => SizedBox(
              height: 140,
              child: ErrorView(onRetry: () => ref.invalidate(productsByTagProvider(tag))),
            ),
            data: (list) => list.isEmpty
                ? const SizedBox.shrink()
                : ProductHorizontalList(products: list),
          ),
        ],
      ),
    );
  }
}

class _RecommendedSection extends ConsumerWidget {
  const _RecommendedSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(recommendedProductsProvider);
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(
            title: 'Siz uchun',
            onAction: () => context.push(AppRoutes.searchPath()),
          ),
          async.when(
            loading: () => const ProductHorizontalList(products: [], loading: true),
            error: (e, _) => const SizedBox.shrink(),
            data: (List<Product> list) => ProductHorizontalList(products: list),
          ),
          const SizedBox(height: 8),
          const _DeliveryPromo(),
        ],
      ),
    );
  }
}

class _DeliveryPromo extends StatelessWidget {
  const _DeliveryPromo();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.accentSoft,
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(color: AppColors.accent, shape: BoxShape.circle),
              child: const Icon(Icons.local_shipping_rounded, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Bepul yetkazib berish',
                    style: context.text.titleSmall?.copyWith(color: const Color(0xFF7C4A03)),
                  ),
                  Text(
                    "${(AppConfig.freeDeliveryThreshold / 1000).round()} ming so'mdan yuqori buyurtmalar uchun",
                    style: context.text.bodySmall?.copyWith(color: const Color(0xFF9A6B1F)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
