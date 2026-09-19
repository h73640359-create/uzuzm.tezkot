import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

/// Bosilganda yengil "press" animatsiyasi beradigan asosiy tugma.
class AppButton extends StatefulWidget {
  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.loading = false,
    this.outlined = false,
    this.color,
    this.height = 52,
    this.expanded = true,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool loading;
  final bool outlined;
  final Color? color;
  final double height;
  final bool expanded;

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> {
  bool _down = false;

  @override
  Widget build(BuildContext context) {
    final enabled = widget.onPressed != null && !widget.loading;
    final color = widget.color ?? AppColors.primary;
    final fg = widget.outlined ? color : Colors.white;

    final content = widget.loading
        ? SizedBox(
            width: 22,
            height: 22,
            child: CircularProgressIndicator(strokeWidth: 2.4, color: fg),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (widget.icon != null) ...[
                Icon(widget.icon, size: 20, color: fg),
                const SizedBox(width: 8),
              ],
              Flexible(
                child: Text(
                  widget.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(color: fg),
                ),
              ),
            ],
          );

    return GestureDetector(
      onTapDown: enabled ? (_) => setState(() => _down = true) : null,
      onTapCancel: () => setState(() => _down = false),
      onTapUp: (_) => setState(() => _down = false),
      onTap: enabled
          ? () {
              HapticFeedback.lightImpact();
              widget.onPressed!();
            }
          : null,
      child: AnimatedScale(
        scale: _down ? 0.97 : 1,
        duration: AppDurations.fast,
        child: AnimatedOpacity(
          duration: AppDurations.fast,
          opacity: enabled ? 1 : 0.55,
          child: Container(
            height: widget.height,
            width: widget.expanded ? double.infinity : null,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: widget.outlined ? Colors.transparent : color,
              borderRadius: BorderRadius.circular(AppRadius.md),
              border: widget.outlined ? Border.all(color: color, width: 1.5) : null,
            ),
            child: Center(child: content),
          ),
        ),
      ),
    );
  }
}
