import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_theme.dart';

class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    required this.title,
    this.actionLabel = 'Barchasi',
    this.onAction,
    this.padding = const EdgeInsets.fromLTRB(16, 20, 8, 10),
  });

  final String title;
  final String actionLabel;
  final VoidCallback? onAction;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Row(
        children: [
          Expanded(
            child: Text(title, style: context.text.titleLarge, maxLines: 1, overflow: TextOverflow.ellipsis),
          ),
          if (onAction != null)
            TextButton(
              onPressed: onAction,
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Row(
                children: [
                  Text(actionLabel, style: context.text.labelMedium?.copyWith(color: AppColors.primary)),
                  const Icon(Icons.chevron_right_rounded, size: 18, color: AppColors.primary),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
