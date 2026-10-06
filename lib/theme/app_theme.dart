import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Central Material 3 theme definitions.
///
/// [light] renders using the existing [AppColors] brand palette (True Pink
/// + Chill White) -- this is the exact same look your app already has
/// today, just now reachable as its own named theme.
///
/// [dark] is a new, separate dark palette (dark neutral surfaces, same
/// True Pink accent, Chill-White-tinted text) built per the Dark Mode spec.
///
/// Both are plain `ThemeData` objects built with Flutter's standard
/// `ColorScheme` / `CardThemeData` / etc. -- no custom `ThemeExtension` or
/// `BuildContext` extension is used anywhere. Switching between them is
/// handled entirely by `MaterialApp.theme` / `.darkTheme` / `.themeMode`
/// in lib/app/app.dart.
class AppTheme {
  AppTheme._();

  static ThemeData get light => _build(
        brightness: Brightness.light,
        background: AppColors.background,
        surface: AppColors.surface,
        surfaceElevated: AppColors.surfaceElevated,
        surfaceBorder: AppColors.surfaceBorder,
        primary: AppColors.primary,
        primaryMuted: AppColors.primaryMuted,
        onPrimary: Colors.white,
        secondary: AppColors.power,
        textPrimary: AppColors.textPrimary,
        textSecondary: AppColors.textSecondary,
        textDisabled: AppColors.textDisabled,
        error: AppColors.critical,
      );

  static ThemeData get dark => _build(
        brightness: Brightness.dark,
        background: const Color(0xFF0B0D0E),
        surface: const Color(0xFF151719),
        surfaceElevated: const Color(0xFF1E2124),
        surfaceBorder: const Color(0xFF2A2E32),
        primary: const Color(0xFFFD1843), // same True Pink accent
        primaryMuted: const Color(0xFF5C1524),
        onPrimary: Colors.white,
        secondary: const Color(0xFFB2154C),
        textPrimary: const Color(0xFFFFF9FA), // Chill White text on dark
        textSecondary: const Color(0xFFB6AEB0),
        textDisabled: const Color(0xFF6E6668),
        error: const Color(0xFFFF4D6D),
      );

  static ThemeData _build({
    required Brightness brightness,
    required Color background,
    required Color surface,
    required Color surfaceElevated,
    required Color surfaceBorder,
    required Color primary,
    required Color primaryMuted,
    required Color onPrimary,
    required Color secondary,
    required Color textPrimary,
    required Color textSecondary,
    required Color textDisabled,
    required Color error,
  }) {
    final base = ThemeData(
      brightness: brightness,
      useMaterial3: true,
      colorScheme: ColorScheme(
        brightness: brightness,
        primary: primary,
        onPrimary: onPrimary,
        secondary: secondary,
        onSecondary: Colors.white,
        surface: surface,
        onSurface: textPrimary,
        error: error,
        onError: Colors.white,
      ),
      scaffoldBackgroundColor: background,
      fontFamily: 'Roboto',
    );

    return base.copyWith(
      textTheme: base.textTheme.copyWith(
        displaySmall: TextStyle(
          fontSize: 26,
          fontWeight: FontWeight.w700,
          color: textPrimary,
          letterSpacing: -0.5,
        ),
        titleLarge: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: textPrimary,
        ),
        titleMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        bodyLarge: TextStyle(
          fontSize: 15,
          color: textPrimary,
        ),
        bodyMedium: TextStyle(
          fontSize: 13.5,
          color: textSecondary,
        ),
        labelLarge: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        labelSmall: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: textSecondary,
          letterSpacing: 0.4,
        ),
      ),
      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: surfaceBorder, width: 1),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: surfaceBorder,
        thickness: 1,
        space: 1,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: background,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: textPrimary,
        ),
        iconTheme: IconThemeData(color: textPrimary),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: surface,
        indicatorColor: primary.withValues(alpha: 0.18),
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return TextStyle(
            fontSize: 11.5,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
            color: selected ? primary : textSecondary,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return IconThemeData(
            color: selected ? primary : textSecondary,
          );
        }),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith(
          (states) =>
              states.contains(WidgetState.selected) ? primary : textDisabled,
        ),
        trackColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? primaryMuted
              : surfaceElevated,
        ),
      ),
      listTileTheme: ListTileThemeData(
        iconColor: textSecondary,
        textColor: textPrimary,
        titleTextStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: textPrimary,
        ),
        subtitleTextStyle: TextStyle(
          fontSize: 13.5,
          color: textSecondary,
        ),
      ),
      chipTheme: base.chipTheme.copyWith(
        backgroundColor: surfaceElevated,
        labelStyle: TextStyle(fontSize: 12, color: textPrimary),
        side: BorderSide(color: surfaceBorder),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      ),
    );
  }
}
