import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

void showAppSnackBar(
  BuildContext context,
  String message, {
  IconData icon = Icons.check_circle_rounded,
  Color iconColor = AppColors.primaryLight,
  String? actionLabel,
  VoidCallback? onAction,
}) {
  final messenger = ScaffoldMessenger.maybeOf(context);
  if (messenger == null) return;
  messenger
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        duration: const Duration(milliseconds: 1800),
        content: Row(
          children: [
            Icon(icon, color: iconColor, size: 20),
            const SizedBox(width: 10),
            Expanded(child: Text(message, maxLines: 2, overflow: TextOverflow.ellipsis)),
          ],
        ),
        action: actionLabel != null && onAction != null
            ? SnackBarAction(label: actionLabel, textColor: AppColors.accent, onPressed: onAction)
            : null,
      ),
    );
}
