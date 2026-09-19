import 'package:flutter/material.dart';

import '../../core/config/app_config.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_theme.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Scaffold(
      appBar: AppBar(title: const Text('Ilova haqida')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Center(
            child: Container(
              width: 96,
              height: 96,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(28)),
              child: Image.asset('assets/images/logo_mark.png'),
            ),
          ),
          const SizedBox(height: 16),
          Text(AppConfig.appName, textAlign: TextAlign.center, style: context.text.headlineSmall),
          Text(AppConfig.appTagline, textAlign: TextAlign.center, style: context.text.bodySmall),
          const SizedBox(height: 4),
          Text('Versiya ${AppConfig.version}', textAlign: TextAlign.center, style: context.text.labelSmall),
          const SizedBox(height: 28),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: c.surface, borderRadius: BorderRadius.circular(AppRadius.lg)),
            child: Text(
              "BozorGo — O'zbekiston bozori uchun yaratilgan zamonaviy marketplace. "
              "Elektronikadan tortib meva-sabzavotgacha minglab mahsulotlar, tez yetkazib berish va qulay to'lov.\n\n"
              "${AppConfig.isDemoMode ? 'Hozirda ilova DEMO rejimida ishlamoqda: mahsulotlar lokal ma\'lumotlar bazasidan yuklanadi, to\'lovlar real emas.' : ''}",
              style: context.text.bodyMedium?.copyWith(color: c.textSecondary, height: 1.5),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(color: c.surface, borderRadius: BorderRadius.circular(AppRadius.lg)),
            child: Column(
              children: [
                ListTile(leading: const Icon(Icons.mail_outline_rounded), title: const Text('Email'), subtitle: const Text(AppConfig.supportEmail)),
                const Divider(indent: 56),
                ListTile(leading: const Icon(Icons.call_outlined), title: const Text('Telefon'), subtitle: const Text(AppConfig.supportPhone)),
                const Divider(indent: 56),
                const ListTile(leading: Icon(Icons.description_outlined), title: Text('Foydalanish shartlari')),
                const Divider(indent: 56),
                const ListTile(leading: Icon(Icons.privacy_tip_outlined), title: Text('Maxfiylik siyosati')),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text('© 2026 BozorGo', textAlign: TextAlign.center, style: context.text.labelSmall),
        ],
      ),
    );
  }
}
