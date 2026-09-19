import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/app_snackbar.dart';
import '../../data/sources/local_storage.dart';
import '../../providers/cart_provider.dart';
import '../../providers/search_provider.dart';
import '../../providers/settings_provider.dart';
import '../../providers/wishlist_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(settingsProvider);
    final n = ref.read(settingsProvider.notifier);
    final c = context.colors;
    return Scaffold(
      appBar: AppBar(title: const Text('Sozlamalar')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text("Ko'rinish", style: context.text.labelSmall),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(color: c.surface, borderRadius: BorderRadius.circular(AppRadius.lg)),
            child: Column(
              children: [
                for (final (mode, label, icon) in const [
                  (ThemeMode.light, 'Yorug\' rejim', Icons.light_mode_outlined),
                  (ThemeMode.dark, 'Tungi rejim', Icons.dark_mode_outlined),
                  (ThemeMode.system, 'Tizim bo\'yicha', Icons.settings_suggest_outlined),
                ])
                  RadioListTile<ThemeMode>(
                    value: mode,
                    groupValue: s.themeMode,
                    onChanged: (v) => n.setThemeMode(v!),
                    title: Text(label),
                    secondary: Icon(icon),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Text('Bildirishnomalar', style: context.text.labelSmall),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(color: c.surface, borderRadius: BorderRadius.circular(AppRadius.lg)),
            child: SwitchListTile(
              title: const Text('Push-bildirishnomalar'),
              subtitle: const Text('Buyurtma holati va aksiyalar haqida'),
              value: s.notifications,
              onChanged: n.setNotifications,
            ),
          ),
          const SizedBox(height: 20),
          Text("Ma'lumotlar", style: context.text.labelSmall),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(color: c.surface, borderRadius: BorderRadius.circular(AppRadius.lg)),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.history_rounded),
                  title: const Text('Qidiruv tarixini tozalash'),
                  onTap: () {
                    ref.read(searchHistoryProvider.notifier).clear();
                    showAppSnackBar(context, 'Qidiruv tarixi tozalandi');
                  },
                ),
                const Divider(indent: 56),
                ListTile(
                  leading: const Icon(Icons.delete_sweep_outlined, color: AppColors.danger),
                  title: const Text("Barcha lokal ma'lumotlarni o'chirish", style: TextStyle(color: AppColors.danger)),
                  onTap: () async {
                    final ok = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text("Ma'lumotlarni o'chirish"),
                        content: const Text("Savat, sevimlilar, buyurtmalar tarixi va sozlamalar o'chiriladi."),
                        actions: [
                          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Bekor qilish')),
                          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text("O'chirish", style: TextStyle(color: AppColors.danger))),
                        ],
                      ),
                    );
                    if (ok == true) {
                      await ref.read(localStorageProvider).clearAll();
                      ref.read(cartProvider.notifier).clear();
                      ref.read(wishlistProvider.notifier).clear();
                      ref.invalidate(settingsProvider);
                      if (context.mounted) showAppSnackBar(context, "Ma'lumotlar o'chirildi");
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
