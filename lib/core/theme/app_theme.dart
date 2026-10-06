import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

/// Central Material 3 theme definitions for SmartFlux.
///
/// Designed with Apple-like restraint, subtle depth, high readability,
/// and refined industrial technology aesthetics.
class AppTheme {
  AppTheme._();

  // Light theme colors
  static const Color lightBackground = Color(0xFFFFF9FA); // Chill White
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightSurfaceElevated = Color(0xFFFFEDF0);
  static const Color lightBorder = Color(0xFFF3D4DC);
  static const Color lightTextPrimary = Color(0xFF1A1113);
  static const Color lightTextSecondary = Color(0xFF756064);
  static const Color lightTextDisabled = Color(0xFFB39CA1);

  // Dark theme colors (Sophisticated warm charcoal surfaces)
  static const Color darkBackground = Color(0xFF111215);
  static const Color darkSurface = Color(0xFF191B1F);
  static const Color darkSurfaceElevated = Color(0xFF22262C);
  static const Color darkBorder = Color(0xFF2B2F36);
  static const Color darkTextPrimary = Color(0xFFF9F5F6);
  static const Color darkTextSecondary = Color(0xFF9E9699);
  static const Color darkTextDisabled = Color(0xFF5E575A);

  static ThemeData light() => _build(
        brightness: Brightness.light,
        background: lightBackground,
        surface: lightSurface,
        surfaceElevated: lightSurfaceElevated,
        surfaceBorder: lightBorder,
        primary: AppColors.primary,
        primaryMuted: AppColors.primaryMuted,
        textPrimary: lightTextPrimary,
        textSecondary: lightTextSecondary,
        textDisabled: lightTextDisabled,
        error: AppColors.critical,
      );

  static ThemeData dark() => _build(
        brightness: Brightness.dark,
        background: darkBackground,
        surface: darkSurface,
        surfaceElevated: darkSurfaceElevated,
        surfaceBorder: darkBorder,
        primary: AppColors.primary,
        primaryMuted: const Color(0xFF481622),
        textPrimary: darkTextPrimary,
        textSecondary: darkTextSecondary,
        textDisabled: darkTextDisabled,
        error: const Color(0xFFFF4868),
      );

  static ThemeData _build({
    required Brightness brightness,
    required Color background,
    required Color surface,
    required Color surfaceElevated,
    required Color surfaceBorder,
    required Color primary,
    required Color primaryMuted,
    required Color textPrimary,
    required Color textSecondary,
    required Color textDisabled,
    required Color error,
  }) {
    final isDark = brightness == Brightness.dark;

    final colorScheme = ColorScheme(
      brightness: brightness,
      primary: primary,
      onPrimary: Colors.white,
      secondary: AppColors.power,
      onSecondary: Colors.white,
      surface: surface,
      onSurface: textPrimary,
      error: error,
      onError: Colors.white,
      outline: surfaceBorder,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: background,
      cardColor: surface,
      dividerColor: surfaceBorder,
      fontFamily: 'Roboto',
      textTheme: TextTheme(
        headlineMedium: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w800,
          color: textPrimary,
          letterSpacing: -0.5,
        ),
        headlineSmall: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w800,
          color: textPrimary,
          letterSpacing: -0.4,
        ),
        titleLarge: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: textPrimary,
          letterSpacing: -0.2,
        ),
        titleMedium: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w700,
          color: textPrimary,
        ),
        titleSmall: TextStyle(
          fontSize: 13.5,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        bodyLarge: TextStyle(
          fontSize: 14.5,
          fontWeight: FontWeight.w400,
          color: textPrimary,
        ),
        bodyMedium: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w400,
          color: textSecondary,
        ),
        bodySmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: textSecondary,
        ),
        labelLarge: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: textPrimary,
        ),
        labelMedium: TextStyle(
          fontSize: 11.5,
          fontWeight: FontWeight.w600,
          color: textSecondary,
        ),
        labelSmall: TextStyle(
          fontSize: 10.5,
          fontWeight: FontWeight.w500,
          color: textSecondary,
          letterSpacing: 0.3,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: background,
        foregroundColor: textPrimary,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w800,
          color: textPrimary,
          letterSpacing: -0.2,
        ),
        iconTheme: IconThemeData(color: textPrimary),
      ),
      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: surfaceBorder.withValues(alpha: isDark ? 0.6 : 0.7),
            width: 1,
          ),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        height: 68,
        indicatorColor: primary.withValues(alpha: isDark ? 0.16 : 0.12),
        indicatorShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return TextStyle(
            fontSize: 11,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
            color: selected ? primary : textSecondary,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return IconThemeData(
            size: 22,
            color: selected ? primary : textSecondary,
          );
        }),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDark ? surfaceElevated : surface,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        labelStyle: TextStyle(fontSize: 13, color: textSecondary),
        hintStyle: TextStyle(fontSize: 13, color: textDisabled),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: surfaceBorder.withValues(alpha: 0.7)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: surfaceBorder.withValues(alpha: 0.7)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: primary, width: 1.5),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: isDark ? surfaceElevated : surface,
        selectedColor: primary.withValues(alpha: 0.14),
        disabledColor: surfaceBorder.withValues(alpha: 0.3),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(color: surfaceBorder.withValues(alpha: 0.6)),
        ),
        labelStyle: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return Colors.white;
          }
          return textDisabled;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return primary;
          }
          return isDark ? surfaceElevated : const Color(0xFFE8DEE1);
        }),
        trackOutlineColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return Colors.transparent;
          }
          return surfaceBorder.withValues(alpha: 0.6);
        }),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: surface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: surfaceBorder.withValues(alpha: 0.8)),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: surfaceBorder.withValues(alpha: 0.6),
        thickness: 1,
        space: 1,
      ),
    );
  }
}
