import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Yengil shimmer (yuklanish) effekti — tashqi paketlarsiz.
class ShimmerBox extends StatefulWidget {
  const ShimmerBox({
    super.key,
    this.width,
    this.height,
    this.radius = 12,
    this.child,
  });

  final double? width;
  final double? height;
  final double radius;
  final Widget? child;

  @override
  State<ShimmerBox> createState() => _ShimmerBoxState();
}

class _ShimmerBoxState extends State<ShimmerBox> with SingleTickerProviderStateMixin {
  late final AnimationController _c =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 1300))..repeat();

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final base = context.colors.surfaceVariant;
    final hi = context.isDark ? Colors.white.withValues(alpha: 0.06) : Colors.white.withValues(alpha: 0.7);
    return AnimatedBuilder(
      animation: _c,
      builder: (context, _) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.radius),
            gradient: LinearGradient(
              begin: Alignment(-1 - 2 * (1 - _c.value), 0),
              end: Alignment(1 + 2 * _c.value, 0),
              colors: [base, hi, base],
              stops: const [0.35, 0.5, 0.65],
            ),
          ),
          child: widget.child,
        );
      },
    );
  }
}
