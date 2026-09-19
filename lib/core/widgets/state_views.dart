import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_theme.dart';

/// Bo'sh holat ekrani.
class EmptyView extends StatelessWidget {
  const EmptyView({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.actionLabel,
    this.onAction,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.6, end: 1),
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeOutBack,
              builder: (_, v, child) => Transform.scale(scale: v, child: child),
              child: Container(
                width: 112,
                height: 112,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 52, color: AppColors.primary),
              ),
            ),
            const SizedBox(height: 20),
            Text(title, style: context.text.titleLarge, textAlign: TextAlign.center),
            if (subtitle != null) ...[
              const SizedBox(height: 8),
              Text(
                subtitle!,
                style: context.text.bodyMedium?.copyWith(color: context.colors.textSecondary),
                textAlign: TextAlign.center,
              ),
            ],
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: 24),
              SizedBox(
                width: 220,
                child: ElevatedButton(onPressed: onAction, child: Text(actionLabel!)),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Xatolik holati ekrani.
class ErrorView extends StatelessWidget {
  const ErrorView({super.key, this.message, this.onRetry});
  final String? message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return EmptyView(
      icon: Icons.wifi_off_rounded,
      title: 'Xatolik yuz berdi',
      subtitle: message ?? "Ma'lumotlarni yuklab bo'lmadi. Qayta urinib ko'ring.",
      actionLabel: onRetry != null ? 'Qayta urinish' : null,
      onAction: onRetry,
    );
  }
}

/// Yuklanish indikatori.
class LoadingView extends StatelessWidget {
  const LoadingView({super.key});
  @override
  Widget build(BuildContext context) => const Center(
        child: SizedBox(
          width: 28,
          height: 28,
          child: CircularProgressIndicator(strokeWidth: 2.5),
        ),
      );
}
