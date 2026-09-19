import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/shimmer_box.dart';
import '../../../data/models/category.dart';
import '../../../navigation/app_routes.dart';
import '../../../providers/catalog_providers.dart';

/// Bosh sahifadagi gorizontal kategoriyalar qatori.
class CategoryChips extends ConsumerWidget {
  const CategoryChips({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(categoriesProvider);
    return SizedBox(
      height: 96,
      child: async.when(
        loading: () => ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: 6,
          separatorBuilder: (_, __) => const SizedBox(width: 14),
          itemBuilder: (_, __) => const Column(
            children: [
              ShimmerBox(width: 60, height: 60, radius: 20),
              SizedBox(height: 8),
              ShimmerBox(width: 50, height: 10, radius: 5),
            ],
          ),
        ),
        error: (_, __) => const SizedBox.shrink(),
        data: (cats) => ListView.separated(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: cats.length,
          separatorBuilder: (_, __) => const SizedBox(width: 12),
          itemBuilder: (context, i) => CategoryTile(category: cats[i]),
        ),
      ),
    );
  }
}

class CategoryTile extends StatelessWidget {
  const CategoryTile({super.key, required this.category, this.size = 60});
  final Category category;
  final double size;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.push(AppRoutes.categoryPath(category.id)),
      borderRadius: BorderRadius.circular(16),
      child: SizedBox(
        width: size + 12,
        child: Column(
          children: [
            Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                color: category.color.withValues(alpha: context.isDark ? 0.22 : 0.12),
                borderRadius: BorderRadius.circular(size * 0.33),
              ),
              alignment: Alignment.center,
              child: Icon(category.icon, color: category.color, size: size * 0.47),
            ),
            const SizedBox(height: 6),
            Text(
              category.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: context.text.labelSmall?.copyWith(color: context.colors.text, fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }
}
