import 'package:flutter/material.dart';

import '../core/constants.dart';

/// Holds simple, local, non-account app settings.
/// Deliberately excludes anything resembling a user profile/login.
class SettingsProvider extends ChangeNotifier {
  bool renewableSectionEnabled = true;
  double alertPowerThresholdW = AppConstants.defaultAlertPowerThreshold;
  int refreshIntervalSeconds = AppConstants.demoTickInterval.inSeconds;

  /// Appearance setting: System Default / Light / Dark.
  /// Defaults to following the device/browser theme.
  ThemeMode themeMode = ThemeMode.system;

  void setRenewableEnabled(bool value) {
    renewableSectionEnabled = value;
    notifyListeners();
  }

  void setAlertThreshold(double value) {
    alertPowerThresholdW = value;
    notifyListeners();
  }

  void setRefreshInterval(int seconds) {
    refreshIntervalSeconds = seconds;
    notifyListeners();
  }

  /// Switches the app's appearance immediately (no restart required,
  /// since lib/app/app.dart watches this provider).
  void setThemeMode(ThemeMode mode) {
    themeMode = mode;
    notifyListeners();
  }
}
