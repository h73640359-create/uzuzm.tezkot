import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/app_button.dart';
import '../../../data/repositories/product_repository.dart';
import '../../../providers/catalog_providers.dart';

Future<ProductFilter?> showFilterSheet(
  BuildContext context,
  ProductFilter current, {
  bool lockCategory = false,
}) {
  return showModalBottomSheet<ProductFilter>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (context) => _FilterSheet(initial: current, lockCategory: lockCategory),
  );
}

class _FilterSheet extends ConsumerStatefulWidget {
  const _FilterSheet({required this.initial, required this.lockCategory});
  final ProductFilter initial;
  final bool lockCategory;

  @override
  ConsumerState<_FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends ConsumerState<_FilterSheet> {
  static const double _maxPrice = 20000000;
  late ProductFilter _f = widget.initial;
  late RangeValues _price = RangeValues(
    (widget.initial.minPrice ?? 0).toDouble(),
    (widget.initial.maxPrice ?? _maxPrice).toDouble(),
  );

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final categories = ref.watch(categoriesProvider).valueOrNull ?? const [];
    final brands = ref.watch(brandsProvider(_f.categoryId)).valueOrNull ?? const [];

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.85,
      maxChildSize: 0.95,
      minChildSize: 0.5,
      builder: (context, controller) => Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 8, 4),
            child: Row(
              children: [
                Text('Filtr', style: context.text.titleLarge),
                const Spacer(),
                TextButton(
                  onPressed: () => setState(() {
                    _f = ProductFilter(
                      query: _f.query,
                      tag: _f.tag,
                      sort: _f.sort,
                      categoryId: widget.lockCategory ? _f.categoryId : null,
                      subcategory: widget.lockCategory ? _f.subcategory : null,
                    );
                    _price = const RangeValues(0, _maxPrice);
                  }),
                  child: const Text('Tozalash'),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              controller: controller,
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              children: [
                // ---- Narx ----
                _Title('Narx'),
                Row(
                  children: [
                    Expanded(child: _PriceBox(label: 'dan', value: _price.start)),
                    const SizedBox(width: 10),
                    Expanded(child: _PriceBox(label: 'gacha', value: _price.end)),
                  ],
                ),
                RangeSlider(
                  values: _price,
                  min: 0,
                  max: _maxPrice,
                  divisions: 200,
                  activeColor: AppColors.primary,
                  onChanged: (v) => setState(() => _price = v),
                ),
                // ---- Kategoriya ----
                if (!widget.lockCategory) ...[
                  _Title('Kategoriya'),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _Chip(
                        label: 'Barchasi',
                        selected: _f.categoryId == null,
                        onTap: () => setState(() => _f = _f.copyWith(clearCategory: true, brands: {})),
                      ),
                      for (final cat in categories)
                        _Chip(
                          label: '${cat.emoji} ${cat.name}',
                          selected: _f.categoryId == cat.id,
                          onTap: () => setState(() => _f = _f.copyWith(categoryId: cat.id, brands: {})),
                        ),
                    ],
                  ),
                ],
                // ---- Reyting ----
                _Title('Reyting'),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _Chip(
                      label: 'Istalgan',
                      selected: _f.minRating == null,
                      onTap: () => setState(() => _f = _f.copyWith(clearRating: true)),
                    ),
                    for (final r in const [4.0, 4.5, 4.8])
                      _Chip(
                        label: '★ $r va yuqori',
                        selected: _f.minRating == r,
                        onTap: () => setState(() => _f = _f.copyWith(minRating: r)),
                      ),
                  ],
                ),
                // ---- Brend ----
                if (brands.isNotEmpty) ...[
                  _Title('Brend'),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final b in brands)
                        _Chip(
                          label: b,
                          selected: _f.brands.contains(b),
                          onTap: () => setState(() {
                            final s = Set<String>.from(_f.brands);
                            if (!s.remove(b)) s.add(b);
                            _f = _f.copyWith(brands: s);
                          }),
                        ),
                    ],
                  ),
                ],
                const SizedBox(height: 16),
                // ---- Switchlar ----
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text('Faqat chegirmadagilar', style: context.text.bodyLarge),
                  value: _f.onlyDiscount,
                  onChanged: (v) => setState(() => _f = _f.copyWith(onlyDiscount: v)),
                ),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text('Faqat mavjudlari', style: context.text.bodyLarge),
                  value: _f.onlyInStock,
                  onChanged: (v) => setState(() => _f = _f.copyWith(onlyInStock: v)),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
            decoration: BoxDecoration(
              color: c.surface,
              border: Border(top: BorderSide(color: c.border)),
            ),
            child: AppButton(
              label: "Qo'llash",
              onPressed: () {
                final minP = _price.start <= 0 ? null : _price.start.round();
                final maxP = _price.end >= _maxPrice ? null : _price.end.round();
                Navigator.of(context).pop(
                  _f.copyWith(clearPrice: true).copyWith(minPrice: minP, maxPrice: maxP),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _Title extends StatelessWidget {
  const _Title(this.text);
  final String text;
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(top: 14, bottom: 10),
        child: Text(text, style: context.text.titleMedium),
      );
}

class _PriceBox extends StatelessWidget {
  const _PriceBox({required this.label, required this.value});
  final String label;
  final double value;
  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: c.surfaceVariant,
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: context.text.labelSmall),
          Text(
            Formatters.price(value, withCurrency: false),
            style: context.text.titleSmall,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({required this.label, required this.selected, required this.onTap});
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return AnimatedContainer(
      duration: AppDurations.fast,
      decoration: BoxDecoration(
        color: selected ? AppColors.primary : c.surface,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: selected ? AppColors.primary : c.border),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(999),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Text(
              label,
              style: context.text.labelMedium?.copyWith(color: selected ? Colors.white : c.text),
            ),
          ),
        ),
      ),
    );
  }
}
