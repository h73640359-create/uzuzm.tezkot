import 'package:flutter/material.dart';

import '../../core/config/app_config.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/app_snackbar.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  static const _faq = [
    ('Buyurtma qancha vaqtda yetkaziladi?', "Toshkent bo'ylab 1–2 ish kuni, viloyatlarga 2–5 ish kuni ichida."),
    ("Yetkazib berish narxi qancha?", "300 000 so'mdan yuqori buyurtmalar uchun bepul, undan past bo'lsa 15 000 so'm."),
    ('Mahsulotni qaytarish mumkinmi?', "Ha, 14 kun ichida sababsiz qaytarish mumkin. Mahsulot ishlatilmagan va qadog'i buzilmagan bo'lishi kerak."),
    ("Qanday to'lov usullari bor?", "Naqd pul (yetkazilganda), bank kartasi va onlayn to'lov (Payme, Click). Hozirda demo rejimda."),
    ('Buyurtmani bekor qilsam bo\'ladimi?', "Ha, buyurtma \"Kutilmoqda\" yoki \"Tayyorlanmoqda\" holatida bo'lsa, buyurtma sahifasidan bekor qilishingiz mumkin."),
  ];

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Scaffold(
      appBar: AppBar(title: const Text('Yordam')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [AppColors.primary, AppColors.primaryLight]),
              borderRadius: BorderRadius.circular(AppRadius.xl),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Savolingiz bormi?", style: context.text.titleLarge?.copyWith(color: Colors.white)),
                const SizedBox(height: 4),
                Text("Qo'llab-quvvatlash xizmati har kuni 9:00–21:00", style: context.text.bodySmall?.copyWith(color: Colors.white70)),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: _ContactBtn(
                        icon: Icons.call_rounded,
                        label: AppConfig.supportPhone,
                        onTap: () => showAppSnackBar(context, "Qo'ng'iroq: ${AppConfig.supportPhone}", icon: Icons.call_rounded),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _ContactBtn(
                        icon: Icons.chat_rounded,
                        label: 'Chat',
                        onTap: () => showAppSnackBar(context, 'Chat tez orada ishga tushadi', icon: Icons.chat_rounded),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Text("Ko'p so'raladigan savollar", style: context.text.titleMedium),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(color: c.surface, borderRadius: BorderRadius.circular(AppRadius.lg)),
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: [
                for (final (q, a) in _faq)
                  Theme(
                    data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                    child: ExpansionTile(
                      title: Text(q, style: context.text.titleSmall),
                      childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
                      expandedCrossAxisAlignment: CrossAxisAlignment.start,
                      children: [Text(a, style: context.text.bodyMedium?.copyWith(color: c.textSecondary, height: 1.5))],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ContactBtn extends StatelessWidget {
  const _ContactBtn({required this.icon, required this.label, required this.onTap});
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => Material(
        color: Colors.white.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppRadius.md),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: Colors.white, size: 18),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis, style: context.text.labelMedium?.copyWith(color: Colors.white)),
                ),
              ],
            ),
          ),
        ),
      );
}
