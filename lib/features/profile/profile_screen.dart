import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/config/app_config.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/formatters.dart';
import '../../core/widgets/app_snackbar.dart';
import '../../navigation/app_routes.dart';
import '../../providers/cart_provider.dart';
import '../../providers/orders_provider.dart';
import '../../providers/settings_provider.dart';
import '../../providers/user_provider.dart';
import '../../providers/wishlist_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    final settings = ref.watch(settingsProvider);
    final ordersCount = ref.watch(ordersProvider).valueOrNull?.length ?? 0;
    final wishCount = ref.watch(wishlistProvider).length;
    final addressCount = ref.watch(addressesProvider).length;
    final c = context.colors;

    return Scaffold(
      appBar: AppBar(title: const Text('Profil')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
        physics: const BouncingScrollPhysics(),
        children: [
          // ---- Avatar / ism ----
          Material(
            color: c.surface,
            borderRadius: BorderRadius.circular(AppRadius.xl),
            child: InkWell(
              onTap: () => context.push(AppRoutes.editProfile),
              borderRadius: BorderRadius.circular(AppRadius.xl),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [AppColors.primary, AppColors.primaryLight],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        user.initials,
                        style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w800),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(user.name, style: context.text.titleMedium, maxLines: 1, overflow: TextOverflow.ellipsis),
                          const SizedBox(height: 2),
                          Text(Formatters.phone(user.phone), style: context.text.bodySmall),
                          Text(user.email, style: context.text.bodySmall, maxLines: 1, overflow: TextOverflow.ellipsis),
                        ],
                      ),
                    ),
                    Icon(Icons.edit_outlined, color: c.textSecondary, size: 20),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          // ---- Statistika ----
          Row(
            children: [
              _Stat(icon: Icons.receipt_long_rounded, label: 'Buyurtmalar', value: '$ordersCount', onTap: () => context.go(AppRoutes.orders)),
              const SizedBox(width: 10),
              _Stat(icon: Icons.favorite_rounded, label: 'Sevimlilar', value: '$wishCount', color: AppColors.danger, onTap: () => context.push(AppRoutes.wishlist)),
              const SizedBox(width: 10),
              _Stat(icon: Icons.location_on_rounded, label: 'Manzillar', value: '$addressCount', color: AppColors.info, onTap: () => context.push(AppRoutes.addresses)),
            ],
          ),
          const SizedBox(height: 20),
          _Group(
            title: 'Xaridlar',
            items: [
              _Item(Icons.receipt_long_outlined, 'Buyurtmalarim', onTap: () => context.go(AppRoutes.orders)),
              _Item(Icons.favorite_border_rounded, 'Sevimlilar', onTap: () => context.push(AppRoutes.wishlist)),
              _Item(Icons.location_on_outlined, 'Manzillarim', onTap: () => context.push(AppRoutes.addresses)),
            ],
          ),
          const SizedBox(height: 14),
          _Group(
            title: 'Sozlamalar',
            items: [
              _Item(Icons.settings_outlined, 'Sozlamalar', onTap: () => context.push(AppRoutes.settings)),
              _Item(
                Icons.notifications_none_rounded,
                'Bildirishnomalar',
                trailing: Switch(
                  value: settings.notifications,
                  onChanged: (v) => ref.read(settingsProvider.notifier).setNotifications(v),
                ),
                onTap: () => context.push(AppRoutes.notifications),
              ),
              _Item(
                Icons.language_rounded,
                'Til',
                value: settings.language == 'uz' ? "O'zbekcha" : settings.language == 'ru' ? 'Русский' : 'English',
                onTap: () => _pickLanguage(context, ref, settings.language),
              ),
              _Item(
                Icons.dark_mode_outlined,
                'Tungi rejim',
                trailing: Switch(
                  value: settings.themeMode == ThemeMode.dark,
                  onChanged: (v) => ref.read(settingsProvider.notifier).toggleDark(v),
                ),
                onTap: () => ref.read(settingsProvider.notifier).toggleDark(settings.themeMode != ThemeMode.dark),
              ),
            ],
          ),
          const SizedBox(height: 14),
          _Group(
            title: "Ma'lumot",
            items: [
              _Item(Icons.help_outline_rounded, 'Yordam', onTap: () => context.push(AppRoutes.help)),
              _Item(Icons.info_outline_rounded, 'Ilova haqida', value: 'v${AppConfig.version}', onTap: () => context.push(AppRoutes.about)),
            ],
          ),
          const SizedBox(height: 14),
          _Group(
            items: [
              _Item(Icons.logout_rounded, 'Chiqish', color: AppColors.danger, onTap: () => _logout(context, ref)),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _pickLanguage(BuildContext context, WidgetRef ref, String current) async {
    final picked = await showModalBottomSheet<String>(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
              child: Align(alignment: Alignment.centerLeft, child: Text('Tilni tanlang', style: context.text.titleLarge)),
            ),
            for (final (code, label) in const [('uz', "O'zbekcha"), ('ru', 'Русский'), ('en', 'English')])
              ListTile(
                title: Text(label),
                trailing: code == current ? const Icon(Icons.check_circle_rounded, color: AppColors.primary) : null,
                onTap: () => Navigator.pop(context, code),
              ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
    if (picked != null && context.mounted) {
      ref.read(settingsProvider.notifier).setLanguage(picked);
      if (picked != 'uz') {
        showAppSnackBar(context, "Hozircha faqat o'zbek tili to'liq qo'llab-quvvatlanadi", icon: Icons.info_outline_rounded);
      }
    }
  }

  Future<void> _logout(BuildContext context, WidgetRef ref) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Chiqish'),
        content: const Text('Hisobdan chiqmoqchimisiz? Savat va sevimlilar tozalanadi.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Bekor qilish')),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Chiqish', style: TextStyle(color: AppColors.danger)),
          ),
        ],
      ),
    );
    if (ok == true) {
      await ref.read(userProvider.notifier).logout();
      ref.read(cartProvider.notifier).clear();
      ref.read(wishlistProvider.notifier).clear();
      if (context.mounted) {
        showAppSnackBar(context, 'Hisobdan chiqdingiz', icon: Icons.logout_rounded);
        context.go(AppRoutes.home);
      }
    }
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.icon, required this.label, required this.value, required this.onTap, this.color = AppColors.primary});
  final IconData icon;
  final String label;
  final String value;
  final VoidCallback onTap;
  final Color color;

  @override
  Widget build(BuildContext context) => Expanded(
        child: Material(
          color: context.colors.surface,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(AppRadius.lg),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 14),
              child: Column(
                children: [
                  Icon(icon, color: color, size: 22),
                  const SizedBox(height: 6),
                  Text(value, style: context.text.titleMedium),
                  Text(label, style: context.text.labelSmall, maxLines: 1, overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
          ),
        ),
      );
}

class _Item {
  const _Item(this.icon, this.title, {required this.onTap, this.value, this.trailing, this.color});
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final String? value;
  final Widget? trailing;
  final Color? color;
}

class _Group extends StatelessWidget {
  const _Group({this.title, required this.items});
  final String? title;
  final List<_Item> items;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null)
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 8),
            child: Text(title!, style: context.text.labelSmall?.copyWith(letterSpacing: 0.4)),
          ),
        Material(
          color: c.surface,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: [
              for (final (i, it) in items.indexed)
                InkWell(
                  onTap: it.onTap,
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(14, 4, 8, 4),
                    decoration: BoxDecoration(
                      border: i == 0 ? null : Border(top: BorderSide(color: c.border)),
                    ),
                    child: Row(
                      children: [
                        Icon(it.icon, size: 22, color: it.color ?? c.textSecondary),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: Text(it.title, style: context.text.bodyLarge?.copyWith(color: it.color)),
                          ),
                        ),
                        if (it.value != null) Text(it.value!, style: context.text.bodySmall),
                        it.trailing ?? Icon(Icons.chevron_right_rounded, color: c.textTertiary),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
