import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/repositories/product_repository.dart';

Future<SortOption?> showSortSheet(BuildContext context, SortOption current) {
  return showModalBottomSheet<SortOption>(
    context: context,
    builder: (context) => SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
            child: Text('Saralash', style: context.text.titleLarge),
          ),
          for (final s in SortOption.values)
            ListTile(
              title: Text(s.label, style: context.text.bodyLarge),
              trailing: s == current
                  ? const Icon(Icons.check_circle_rounded, color: AppColors.primary)
                  : const Icon(Icons.circle_outlined),
              onTap: () => Navigator.of(context).pop(s),
            ),
          const SizedBox(height: 8),
        ],
      ),
    ),
  );
}
