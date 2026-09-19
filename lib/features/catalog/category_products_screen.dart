import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/product_card.dart';
import '../../core/widgets/state_views.dart';
import '../../data/repositories/product_repository.dart';
import '../../navigation/app_routes.dart';
import '../../providers/catalog_providers.dart';
import '../../providers/repository_providers.dart';
import 'widgets/filter_sheet.dart';
import 'widgets/sort_sheet.dart';

class CategoryProductsScreen extends ConsumerStatefulWidget {
  const CategoryProductsScreen({super.key, required this.categoryId, this.subcategory});
  final String categoryId;
  final String? subcategory;

  @override
  ConsumerState<CategoryProductsScreen> createState() => _CategoryProductsScreenState();
}

class _CategoryProductsScreenState extends ConsumerState<CategoryProductsScreen> {
  late ProductFilter _filter = ProductFilter(
    categoryId: widget.categoryId,
    subcategory: widget.subcategory,
  );

  @override
  Widget build(BuildContext context) {
    final category = ref.read(categoryRepositoryProvider).byId(widget.categoryId);
    final results = ref.watch(searchResultsProvider(_filter));
    final c = context.colors;

    return Scaffold(
      appBar: AppBar(
        title: Text(category?.name ?? 'Kategoriya'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search_rounded),
            onPressed: () => context.push(AppRoutes.search),
          ),
        ],
      ),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          if (category != null && category.subcategories.isNotEmpty)
            SliverToBoxAdapter(
              child: SizedBox(
                height: 44,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: category.subcategories.length + 1,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (context, i) {
                    final label = i == 0 ? 'Barchasi' : category.subcategories[i - 1];
                    final selected = i == 0 ? _filter.subcategory == null : _filter.subcategory == label;
                    return ChoiceChip(
                      label: Text(label),
                      selected: selected,
                      labelStyle: context.text.labelMedium?.copyWith(
                        color: selected ? Colors.white : c.text,
                      ),
                      onSelected: (_) => setState(() {
                        _filter = i == 0
                            ? _filter.copyWith(clearSubcategory: true)
                            : _filter.copyWith(subcategory: label);
                      }),
                    );
                  },
                ),
              ),
            ),
          SliverToBoxAdapter(
            child: FilterSortBar(
              filter: _filter,
              resultCount: results.valueOrNull?.length,
              onFilter: () async {
                final f = await showFilterSheet(context, _filter, lockCategory: true);
                if (f != null) setState(() => _filter = f);
              },
              onSort: () async {
                final s = await showSortSheet(context, _filter.sort);
                if (s != null) setState(() => _filter = _filter.copyWith(sort: s));
              },
            ),
          ),
          results.when(
            loading: () => const ProductSliverGridSkeleton(),
            error: (e, _) => SliverFillRemaining(
              child: ErrorView(onRetry: () => ref.invalidate(searchResultsProvider(_filter))),
            ),
            data: (list) => list.isEmpty
                ? SliverFillRemaining(
                    hasScrollBody: false,
                    child: EmptyView(
                      icon: Icons.inventory_2_outlined,
                      title: 'Mahsulot topilmadi',
                      subtitle: "Filtrlarni o'zgartirib ko'ring",
                      actionLabel: 'Filtrlarni tozalash',
                      onAction: () => setState(
                        () => _filter = ProductFilter(categoryId: widget.categoryId),
                      ),
                    ),
                  )
                : ProductSliverGrid(products: list),
          ),
        ],
      ),
    );
  }
}

/// Filtr va saralash tugmalari qatori (qidiruv, kategoriya, kolleksiya sahifalarida).
class FilterSortBar extends StatelessWidget {
  const FilterSortBar({
    super.key,
    required this.filter,
    required this.onFilter,
    required this.onSort,
    this.resultCount,
  });

  final ProductFilter filter;
  final VoidCallback onFilter;
  final VoidCallback onSort;
  final int? resultCount;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 2),
      child: Row(
        children: [
          _Pill(
            icon: Icons.tune_rounded,
            label: 'Filtr',
            badge: filter.activeCount,
            onTap: onFilter,
          ),
          const SizedBox(width: 8),
          _Pill(
            icon: Icons.swap_vert_rounded,
            label: filter.sort.label,
            onTap: onSort,
          ),
          const Spacer(),
          if (resultCount != null)
            Text(
              '$resultCount ta',
              style: context.text.labelSmall?.copyWith(color: c.textSecondary),
            ),
        ],
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({required this.icon, required this.label, required this.onTap, this.badge = 0});
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final int badge;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final active = badge > 0;
    return Material(
      color: active ? AppColors.primary.withValues(alpha: 0.12) : c.surface,
      borderRadius: BorderRadius.circular(999),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: active ? AppColors.primary : c.border),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 16, color: active ? AppColors.primary : c.text),
              const SizedBox(width: 6),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 150),
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.text.labelMedium?.copyWith(
                    color: active ? AppColors.primary : c.text,
                  ),
                ),
              ),
              if (active) ...[
                const SizedBox(width: 6),
                CircleAvatar(
                  radius: 9,
                  backgroundColor: AppColors.primary,
                  child: Text(
                    '$badge',
                    style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w800),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
