import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/wishlist_provider.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import 'app_snackbar.dart';

/// Yurak tugmasi — bosilganda animatsiya bilan wishlistga qo'shadi/olib tashlaydi.
class WishlistButton extends ConsumerStatefulWidget {
  const WishlistButton({
    super.key,
    required this.productId,
    this.size = 20,
    this.filledBackground = true,
    this.showSnack = true,
  });

  final String productId;
  final double size;
  final bool filledBackground;
  final bool showSnack;

  @override
  ConsumerState<WishlistButton> createState() => _WishlistButtonState();
}

class _WishlistButtonState extends ConsumerState<WishlistButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 320),
  );
  late final Animation<double> _scale = TweenSequence<double>([
    TweenSequenceItem(tween: Tween(begin: 1, end: 1.4), weight: 40),
    TweenSequenceItem(tween: Tween(begin: 1.4, end: 0.9), weight: 30),
    TweenSequenceItem(tween: Tween(begin: 0.9, end: 1), weight: 30),
  ]).animate(CurvedAnimation(parent: _c, curve: Curves.easeOut));

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  void _toggle() {
    HapticFeedback.lightImpact();
    final added = ref.read(wishlistProvider.notifier).toggle(widget.productId);
    if (added) _c.forward(from: 0);
    if (widget.showSnack) {
      showAppSnackBar(
        context,
        added ? "Sevimlilarga qo'shildi" : 'Sevimlilardan olib tashlandi',
        icon: added ? Icons.favorite_rounded : Icons.favorite_border_rounded,
        iconColor: added ? AppColors.danger : Colors.white70,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final fav = ref.watch(isFavoriteProvider(widget.productId));
    final btn = ScaleTransition(
      scale: _scale,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 180),
        transitionBuilder: (child, a) => ScaleTransition(scale: a, child: child),
        child: Icon(
          fav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
          key: ValueKey(fav),
          size: widget.size,
          color: fav ? AppColors.danger : context.colors.textSecondary,
        ),
      ),
    );
    return Material(
      color: widget.filledBackground
          ? context.colors.surface.withValues(alpha: 0.92)
          : Colors.transparent,
      shape: const CircleBorder(),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: _toggle,
        child: Padding(padding: EdgeInsets.all(widget.size * 0.4), child: btn),
      ),
    );
  }
}
