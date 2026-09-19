import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/widgets/product_card.dart';
import '../../core/widgets/state_views.dart';
import '../../data/repositories/product_repository.dart';
import '../../providers/catalog_providers.dart';
import 'category_products_screen.dart';
import 'widgets/filter_sheet.dart';
import 'widgets/sort_sheet.dart';

/// Teg bo'yicha to'plam: mashhur, chegirmalar, yangi, eng ko'p sotilganlar.
class CollectionScreen extends ConsumerStatefulWidget {
  const CollectionScreen({super.key, required this.tag});
  final String tag;

  @override
  ConsumerState<CollectionScreen> createState() => _CollectionScreenState();
}

class _CollectionScreenState extends ConsumerState<CollectionScreen> {
  late ProductFilter _filter = ProductFilter(
    tag: widget.tag,
    sort: switch (widget.tag) {
      'new' => SortOption.newest,
      'rating' => SortOption.rating,
      _ => SortOption.popular,
    },
  );

  String get _title => switch (widget.tag) {
        'popular' => 'Mashhur mahsulotlar',
        'sale' => 'Chegirmalar',
        'new' => 'Yangi mahsulotlar',
        'bestseller' => "Eng ko'p sotilganlar",
        _ => "To'plam",
      };

  @override
  Widget build(BuildContext context) {
    final results = ref.watch(searchResultsProvider(_filter));
    return Scaffold(
      appBar: AppBar(title: Text(_title)),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: FilterSortBar(
              filter: _filter,
              resultCount: results.valueOrNull?.length,
              onFilter: () async {
                final f = await showFilterSheet(context, _filter);
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
                ? const SliverFillRemaining(
                    hasScrollBody: false,
                    child: EmptyView(icon: Icons.inventory_2_outlined, title: 'Mahsulot topilmadi'),
                  )
                : ProductSliverGrid(products: list),
          ),
        ],
      ),
    );
  }
}
