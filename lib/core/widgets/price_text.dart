import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import '../utils/formatters.dart';

class PriceText extends StatelessWidget {
  const PriceText({
    super.key,
    required this.price,
    this.oldPrice,
    this.large = false,
    this.showBadge = false,
  });

  final int price;
  final int? oldPrice;
  final bool large;
  final bool showBadge;

  @override
  Widget build(BuildContext context) {
    final hasOld = oldPrice != null && oldPrice! > price;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (hasOld)
          Text(
            Formatters.price(oldPrice!),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: (large ? context.text.bodyMedium : context.text.labelSmall)?.copyWith(
              decoration: TextDecoration.lineThrough,
              color: context.colors.textTertiary,
              fontSize: large ? 14 : 11,
            ),
          ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: Text(
                Formatters.price(price),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: (large ? context.text.headlineSmall : context.text.titleSmall)?.copyWith(
                  fontWeight: FontWeight.w800,
                  fontSize: large ? 24 : 14.5,
                ),
              ),
            ),
            if (showBadge && hasOld) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.dangerSoft,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '-${Formatters.discountPercent(price, oldPrice)}%',
                  style: const TextStyle(
                    color: AppColors.danger,
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }
}
