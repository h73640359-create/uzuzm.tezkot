import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/state_views.dart';
import '../../data/models/category.dart';
import '../../navigation/app_routes.dart';
import '../../providers/catalog_providers.dart';

class CategoriesScreen extends ConsumerWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(categoriesProvider);
    final width = MediaQuery.sizeOf(context).width;
    final cols = width >= 900 ? 4 : width >= 600 ? 3 : 2;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kategoriyalar'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search_rounded),
            onPressed: () => context.push(AppRoutes.search),
          ),
        ],
      ),
      body: async.when(
        loading: () => const LoadingView(),
        error: (e, _) => ErrorView(onRetry: () => ref.invalidate(categoriesProvider)),
        data: (cats) => GridView.builder(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
          physics: const BouncingScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: cols,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.25,
          ),
          itemCount: cats.length,
          itemBuilder: (context, i) => _CategoryCard(category: cats[i], index: i),
        ),
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  const _CategoryCard({required this.category, required this.index});
  final Category category;
  final int index;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 250 + (index % 8) * 40),
      curve: Curves.easeOutCubic,
      builder: (_, v, child) => Opacity(
        opacity: v,
        child: Transform.translate(offset: Offset(0, 12 * (1 - v)), child: child),
      ),
      child: Material(
        color: c.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => context.push(AppRoutes.categoryPath(category.id)),
          child: Stack(
            children: [
              Positioned(
                right: -14,
                bottom: -14,
                child: Icon(
                  category.icon,
                  size: 88,
                  color: category.color.withValues(alpha: context.isDark ? 0.18 : 0.10),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: category.color.withValues(alpha: context.isDark ? 0.25 : 0.14),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(category.icon, color: category.color, size: 22),
                    ),
                    const Spacer(),
                    Text(
                      category.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: context.text.titleSmall,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${category.subcategories.length} ta bo\'lim',
                      style: context.text.labelSmall,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
