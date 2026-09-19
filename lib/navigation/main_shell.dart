import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_theme.dart';
import '../providers/cart_provider.dart';

class MainShell extends ConsumerWidget {
  const MainShell({super.key, required this.shell});
  final StatefulNavigationShell shell;

  static const _items = [
    _NavItem('Bosh sahifa', Icons.home_outlined, Icons.home_rounded),
    _NavItem('Kategoriyalar', Icons.grid_view_outlined, Icons.grid_view_rounded),
    _NavItem('Savat', Icons.shopping_bag_outlined, Icons.shopping_bag_rounded),
    _NavItem('Buyurtmalar', Icons.receipt_long_outlined, Icons.receipt_long_rounded),
    _NavItem('Profil', Icons.person_outline_rounded, Icons.person_rounded),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartCount = ref.watch(cartProvider.select((c) => c.count));
    final c = context.colors;
    return Scaffold(
      body: shell,
      bottomNavigationBar: DecoratedBox(
        decoration: BoxDecoration(
          color: c.surface,
          border: Border(top: BorderSide(color: c.border)),
        ),
        child: SafeArea(
          top: false,
          child: SizedBox(
            height: 64,
            child: Row(
              children: [
                for (var i = 0; i < _items.length; i++)
                  Expanded(
                    child: _NavButton(
                      item: _items[i],
                      selected: shell.currentIndex == i,
                      badge: i == 2 ? cartCount : 0,
                      onTap: () {
                        HapticFeedback.selectionClick();
                        shell.goBranch(i, initialLocation: i == shell.currentIndex);
                      },
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  const _NavItem(this.label, this.icon, this.activeIcon);
  final String label;
  final IconData icon;
  final IconData activeIcon;
}

class _NavButton extends StatelessWidget {
  const _NavButton({
    required this.item,
    required this.selected,
    required this.onTap,
    this.badge = 0,
  });

  final _NavItem item;
  final bool selected;
  final VoidCallback onTap;
  final int badge;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final color = selected ? AppColors.primary : c.textTertiary;
    return InkResponse(
      onTap: onTap,
      radius: 36,
      highlightShape: BoxShape.rectangle,
      containedInkWell: true,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOutBack,
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 3),
            decoration: BoxDecoration(
              color: selected ? AppColors.primary.withValues(alpha: 0.12) : Colors.transparent,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  transitionBuilder: (child, anim) =>
                      ScaleTransition(scale: anim, child: child),
                  child: Icon(
                    selected ? item.activeIcon : item.icon,
                    key: ValueKey(selected),
                    color: color,
                    size: 24,
                  ),
                ),
                if (badge > 0)
                  Positioned(
                    right: -10,
                    top: -6,
                    child: AnimatedScale(
                      scale: 1,
                      duration: const Duration(milliseconds: 200),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                        constraints: const BoxConstraints(minWidth: 18),
                        decoration: BoxDecoration(
                          color: AppColors.accent,
                          borderRadius: BorderRadius.circular(9),
                          border: Border.all(color: c.surface, width: 1.5),
                        ),
                        child: Text(
                          badge > 99 ? '99+' : '$badge',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            height: 1.2,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 3),
          Text(
            item.label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: context.text.labelSmall?.copyWith(
              color: color,
              fontSize: 10.5,
              fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
