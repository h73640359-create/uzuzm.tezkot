import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/product_card.dart';
import '../../core/widgets/state_views.dart';
import '../../data/repositories/product_repository.dart';
import '../../providers/catalog_providers.dart';
import '../../providers/search_provider.dart';
import '../catalog/category_products_screen.dart';
import '../catalog/widgets/filter_sheet.dart';
import '../catalog/widgets/sort_sheet.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key, this.initialQuery});
  final String? initialQuery;

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  late final TextEditingController _controller =
      TextEditingController(text: widget.initialQuery ?? '');
  final _focus = FocusNode();
  Timer? _debounce;
  ProductFilter _filter = const ProductFilter();
  bool _submitted = false;

  @override
  void initState() {
    super.initState();
    if ((widget.initialQuery ?? '').isNotEmpty) {
      _filter = _filter.copyWith(query: widget.initialQuery);
      _submitted = true;
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) => _focus.requestFocus());
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    _focus.dispose();
    super.dispose();
  }

  void _onChanged(String v) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 350), () {
      if (!mounted) return;
      setState(() {
        _filter = _filter.copyWith(query: v);
        _submitted = v.trim().isNotEmpty;
      });
    });
  }

  void _submit(String v) {
    final q = v.trim();
    _controller.text = q;
    _controller.selection = TextSelection.collapsed(offset: q.length);
    _debounce?.cancel();
    if (q.isNotEmpty) ref.read(searchHistoryProvider.notifier).add(q);
    setState(() {
      _filter = _filter.copyWith(query: q);
      _submitted = q.isNotEmpty;
    });
    _focus.unfocus();
  }

  void _clear() {
    _controller.clear();
    setState(() {
      _filter = _filter.copyWith(query: '');
      _submitted = false;
    });
    _focus.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final showResults = _submitted || _filter.activeCount > 0;

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        leading: const BackButton(),
        title: Hero(
          tag: 'search-bar',
          child: Material(
            color: Colors.transparent,
            child: Container(
              height: 44,
              margin: const EdgeInsets.only(right: 16),
              decoration: BoxDecoration(
                color: c.surface,
                borderRadius: BorderRadius.circular(AppRadius.md),
                border: Border.all(color: _focus.hasFocus ? AppColors.primary : c.border),
              ),
              child: TextField(
                controller: _controller,
                focusNode: _focus,
                textInputAction: TextInputAction.search,
                onChanged: _onChanged,
                onSubmitted: _submit,
                style: context.text.bodyMedium,
                decoration: InputDecoration(
                  hintText: 'Qidirish',
                  filled: false,
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  prefixIcon: Icon(Icons.search_rounded, color: c.textSecondary),
                  suffixIcon: ValueListenableBuilder(
                    valueListenable: _controller,
                    builder: (_, v, __) => v.text.isEmpty
                        ? const SizedBox.shrink()
                        : IconButton(
                            icon: Icon(Icons.close_rounded, size: 20, color: c.textSecondary),
                            onPressed: _clear,
                          ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      body: showResults ? _buildResults() : _buildSuggestions(),
    );
  }

  Widget _buildSuggestions() {
    final history = ref.watch(searchHistoryProvider);
    final popular = ref.watch(popularSearchesProvider).valueOrNull ?? const [];
    final c = context.colors;
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      physics: const BouncingScrollPhysics(),
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      children: [
        if (history.isNotEmpty) ...[
          Row(
            children: [
              Text('Qidiruv tarixi', style: context.text.titleMedium),
              const Spacer(),
              TextButton(
                onPressed: () => ref.read(searchHistoryProvider.notifier).clear(),
                child: const Text('Tozalash'),
              ),
            ],
          ),
          for (final h in history)
            ListTile(
              contentPadding: EdgeInsets.zero,
              dense: true,
              leading: Icon(Icons.history_rounded, color: c.textSecondary),
              title: Text(h, style: context.text.bodyLarge),
              trailing: IconButton(
                icon: Icon(Icons.close_rounded, size: 18, color: c.textTertiary),
                onPressed: () => ref.read(searchHistoryProvider.notifier).remove(h),
              ),
              onTap: () => _submit(h),
            ),
          const SizedBox(height: 16),
        ],
        Text('Mashhur qidiruvlar', style: context.text.titleMedium),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final p in popular)
              ActionChip(
                avatar: const Icon(Icons.trending_up_rounded, size: 16, color: AppColors.primary),
                label: Text(p),
                onPressed: () => _submit(p),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildResults() {
    final results = ref.watch(searchResultsProvider(_filter));
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
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
              ? SliverFillRemaining(
                  hasScrollBody: false,
                  child: EmptyView(
                    icon: Icons.search_off_rounded,
                    title: 'Hech narsa topilmadi',
                    subtitle: _filter.query.isNotEmpty
                        ? '"${_filter.query}" bo\'yicha natija yo\'q. Boshqa so\'z bilan urinib ko\'ring.'
                        : "Filtrlarni o'zgartirib ko'ring",
                    actionLabel: 'Filtrlarni tozalash',
                    onAction: () => setState(() => _filter = ProductFilter(query: _filter.query)),
                  ),
                )
              : ProductSliverGrid(products: list),
        ),
      ],
    );
  }
}
