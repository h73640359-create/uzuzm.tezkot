import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/app_spacing.dart';
import '../theme/app_theme.dart';

class QuantitySelector extends StatelessWidget {
  const QuantitySelector({
    super.key,
    required this.value,
    required this.onChanged,
    this.min = 1,
    this.max = 99,
    this.compact = false,
  });

  final int value;
  final ValueChanged<int> onChanged;
  final int min;
  final int max;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final size = compact ? 30.0 : 38.0;
    return Container(
      decoration: BoxDecoration(
        color: c.surfaceVariant,
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _Btn(
            icon: Icons.remove_rounded,
            size: size,
            enabled: value > min,
            onTap: () => onChanged(value - 1),
          ),
          SizedBox(
            width: compact ? 30 : 40,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 150),
              transitionBuilder: (child, a) => FadeTransition(
                opacity: a,
                child: ScaleTransition(scale: a, child: child),
              ),
              child: Text(
                '$value',
                key: ValueKey(value),
                textAlign: TextAlign.center,
                style: (compact ? context.text.labelMedium : context.text.titleMedium),
              ),
            ),
          ),
          _Btn(
            icon: Icons.add_rounded,
            size: size,
            enabled: value < max,
            onTap: () => onChanged(value + 1),
          ),
        ],
      ),
    );
  }
}

class _Btn extends StatelessWidget {
  const _Btn({required this.icon, required this.size, required this.enabled, required this.onTap});
  final IconData icon;
  final double size;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: enabled
          ? () {
              HapticFeedback.selectionClick();
              onTap();
            }
          : null,
      borderRadius: BorderRadius.circular(AppRadius.sm),
      child: SizedBox(
        width: size,
        height: size,
        child: Icon(
          icon,
          size: size * 0.5,
          color: enabled ? context.colors.text : context.colors.textTertiary,
        ),
      ),
    );
  }
}
