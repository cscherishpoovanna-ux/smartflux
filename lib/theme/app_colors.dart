import 'package:flutter/material.dart';

/// "True Pink" + "Chill White" brand palette.
class AppColors {
  AppColors._();

  static const Color background = Color(0xFFFFF9FA); // Chill White
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceElevated = Color(0xFFFFEDF0);
  static const Color surfaceBorder = Color(0xFFFAD6DD);

  static const Color primary = Color(0xFFFD1843); // True Pink
  static const Color primaryMuted = Color(0xFFFFD3DC);

  static const Color textPrimary = Color(0xFF1A1113);
  static const Color textSecondary = Color(0xFF7A6367);
  static const Color textDisabled = Color(0xFFB79BA1);

  static const Color success = Color(0xFF2FA36B);
  static const Color warning = Color(0xFFE0932E);
  static const Color critical = Color(0xFFFD1843);
  static const Color info = Color(0xFF3B7FD1);

  static const Color voltage = Color(0xFFFD1843);
  static const Color current = Color(0xFFE0932E);
  static const Color power = Color(0xFFB2154C);
  static const Color energy = Color(0xFF2FA36B);

  static const Color solar = Color(0xFFE0932E);
  static const Color battery = Color(0xFF3B7FD1);

  static Color severityColor(String severity) {
    switch (severity) {
      case 'critical':
        return critical;
      case 'warning':
        return warning;
      default:
        return info;
    }
  }
}
