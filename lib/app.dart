import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/config/app_config.dart';
import 'core/theme/app_theme.dart';
import 'navigation/app_router.dart';
import 'providers/settings_provider.dart';

class BozorGoApp extends ConsumerWidget {
  const BozorGoApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final router = ref.watch(appRouterProvider);
    return MaterialApp.router(
      title: AppConfig.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: settings.themeMode,
      routerConfig: router,
      builder: (context, child) {
        // Matnlar juda katta font sozlamalarida ham ekrandan chiqib ketmasligi uchun
        final media = MediaQuery.of(context);
        final scale = media.textScaler.clamp(minScaleFactor: 0.9, maxScaleFactor: 1.2);
        return MediaQuery(
          data: media.copyWith(textScaler: scale),
          child: child ?? const SizedBox.shrink(),
        );
      },
    );
  }
}
