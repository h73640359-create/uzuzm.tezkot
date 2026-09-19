import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app_colors.dart';
import 'app_spacing.dart';

/// Tema kengaytmasi: light/dark rejimlarga xos qo'shimcha ranglar.
@immutable
class AppThemeColors extends ThemeExtension<AppThemeColors> {
  const AppThemeColors({
    required this.background,
    required this.surface,
    required this.surfaceVariant,
    required this.border,
    required this.text,
    required this.textSecondary,
    required this.textTertiary,
  });

  final Color background;
  final Color surface;
  final Color surfaceVariant;
  final Color border;
  final Color text;
  final Color textSecondary;
  final Color textTertiary;

  static const light = AppThemeColors(
    background: AppColors.lightBackground,
    surface: AppColors.lightSurface,
    surfaceVariant: AppColors.lightSurfaceVariant,
    border: AppColors.lightBorder,
    text: AppColors.lightText,
    textSecondary: AppColors.lightTextSecondary,
    textTertiary: AppColors.lightTextTertiary,
  );

  static const dark = AppThemeColors(
    background: AppColors.darkBackground,
    surface: AppColors.darkSurface,
    surfaceVariant: AppColors.darkSurfaceVariant,
    border: AppColors.darkBorder,
    text: AppColors.darkText,
    textSecondary: AppColors.darkTextSecondary,
    textTertiary: AppColors.darkTextTertiary,
  );

  @override
  AppThemeColors copyWith({
    Color? background,
    Color? surface,
    Color? surfaceVariant,
    Color? border,
    Color? text,
    Color? textSecondary,
    Color? textTertiary,
  }) {
    return AppThemeColors(
      background: background ?? this.background,
      surface: surface ?? this.surface,
      surfaceVariant: surfaceVariant ?? this.surfaceVariant,
      border: border ?? this.border,
      text: text ?? this.text,
      textSecondary: textSecondary ?? this.textSecondary,
      textTertiary: textTertiary ?? this.textTertiary,
    );
  }

  @override
  AppThemeColors lerp(ThemeExtension<AppThemeColors>? other, double t) {
    if (other is! AppThemeColors) return this;
    return AppThemeColors(
      background: Color.lerp(background, other.background, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      surfaceVariant: Color.lerp(surfaceVariant, other.surfaceVariant, t)!,
      border: Color.lerp(border, other.border, t)!,
      text: Color.lerp(text, other.text, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textTertiary: Color.lerp(textTertiary, other.textTertiary, t)!,
    );
  }
}

extension AppThemeX on BuildContext {
  AppThemeColors get colors => Theme.of(this).extension<AppThemeColors>()!;
  TextTheme get text => Theme.of(this).textTheme;
  bool get isDark => Theme.of(this).brightness == Brightness.dark;
}

class AppTheme {
  AppTheme._();

  static const String fontFamily = 'Manrope';

  static ThemeData light() => _build(Brightness.light, AppThemeColors.light);
  static ThemeData dark() => _build(Brightness.dark, AppThemeColors.dark);

  static ThemeData _build(Brightness brightness, AppThemeColors c) {
    final isDark = brightness == Brightness.dark;
    final scheme = ColorScheme(
      brightness: brightness,
      primary: AppColors.primary,
      onPrimary: Colors.white,
      primaryContainer: isDark ? AppColors.primaryDark : AppColors.primarySoft,
      onPrimaryContainer: isDark ? Colors.white : AppColors.primaryDark,
      secondary: AppColors.accent,
      onSecondary: Colors.black,
      secondaryContainer: AppColors.accentSoft,
      onSecondaryContainer: const Color(0xFF7C4A03),
      error: AppColors.danger,
      onError: Colors.white,
      surface: c.surface,
      onSurface: c.text,
      onSurfaceVariant: c.textSecondary,
      outline: c.border,
      outlineVariant: c.border,
      surfaceContainerHighest: c.surfaceVariant,
    );

    final textTheme = _textTheme(c);

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      fontFamily: fontFamily,
      scaffoldBackgroundColor: c.background,
      textTheme: textTheme,
      splashFactory: InkSparkle.splashFactory,
      visualDensity: VisualDensity.standard,
      extensions: [c],
      appBarTheme: AppBarTheme(
        backgroundColor: c.background,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        foregroundColor: c.text,
        titleTextStyle: textTheme.titleLarge,
        systemOverlayStyle: isDark
            ? SystemUiOverlayStyle.light
            : SystemUiOverlayStyle.dark,
      ),
      cardTheme: CardThemeData(
        color: c.surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
      ),
      dividerTheme: DividerThemeData(color: c.border, thickness: 1, space: 1),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: c.surface,
        hintStyle: textTheme.bodyMedium?.copyWith(color: c.textTertiary),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: BorderSide(color: c.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: BorderSide(color: c.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: const BorderSide(color: AppColors.danger),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: const BorderSide(color: AppColors.danger, width: 1.5),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          disabledBackgroundColor: c.surfaceVariant,
          disabledForegroundColor: c.textTertiary,
          elevation: 0,
          minimumSize: const Size.fromHeight(52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          textStyle: textTheme.labelLarge,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          minimumSize: const Size.fromHeight(52),
          side: const BorderSide(color: AppColors.primary, width: 1.4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          textStyle: textTheme.labelLarge,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          textStyle: textTheme.labelLarge,
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: c.surface,
        selectedColor: AppColors.primary,
        side: BorderSide(color: c.border),
        labelStyle: textTheme.labelMedium,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.pill),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        showCheckmark: false,
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: c.surface,
        surfaceTintColor: Colors.transparent,
        showDragHandle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: c.surface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.xl),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: isDark ? AppColors.darkSurfaceVariant : AppColors.lightText,
        contentTextStyle: textTheme.bodyMedium?.copyWith(color: Colors.white),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected) ? Colors.white : c.textTertiary,
        ),
        trackColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected) ? AppColors.primary : c.surfaceVariant,
        ),
        trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected) ? AppColors.primary : Colors.transparent,
        ),
        side: BorderSide(color: c.textTertiary, width: 1.6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      ),
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected) ? AppColors.primary : c.textTertiary,
        ),
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(color: AppColors.primary),
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: FadeForwardsPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        },
      ),
    );
  }

  static TextTheme _textTheme(AppThemeColors c) {
    final base = TextStyle(color: c.text, fontFamily: fontFamily, height: 1.3);
    return TextTheme(
      displaySmall: base.copyWith(fontSize: 32, fontWeight: FontWeight.w800, letterSpacing: -0.5),
      headlineMedium: base.copyWith(fontSize: 26, fontWeight: FontWeight.w800, letterSpacing: -0.5),
      headlineSmall: base.copyWith(fontSize: 22, fontWeight: FontWeight.w800, letterSpacing: -0.3),
      titleLarge: base.copyWith(fontSize: 19, fontWeight: FontWeight.w700),
      titleMedium: base.copyWith(fontSize: 16, fontWeight: FontWeight.w700),
      titleSmall: base.copyWith(fontSize: 14, fontWeight: FontWeight.w700),
      bodyLarge: base.copyWith(fontSize: 16, fontWeight: FontWeight.w500),
      bodyMedium: base.copyWith(fontSize: 14, fontWeight: FontWeight.w500),
      bodySmall: base.copyWith(fontSize: 12, fontWeight: FontWeight.w500, color: c.textSecondary),
      labelLarge: base.copyWith(fontSize: 15, fontWeight: FontWeight.w700),
      labelMedium: base.copyWith(fontSize: 13, fontWeight: FontWeight.w600),
      labelSmall: base.copyWith(fontSize: 11, fontWeight: FontWeight.w600, color: c.textSecondary),
    );
  }
}
