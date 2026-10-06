/// App-wide constants. Centralizing these makes it easy to retune the
/// demo simulation or swap in real backend limits later.
class AppConstants {
  AppConstants._();

  static const String appName = 'IoT SmartFlux';
  static const String appSubtitle = 'IoT Based Energy Grid Optimization System';

  // Realistic simulated operating ranges (Stage 1 demo mode).
  static const double minVoltage = 229.0;
  static const double maxVoltage = 241.0;
  static const double nominalVoltage = 230.0;

  static const double minCurrent = 1.0;
  static const double maxCurrent = 8.0;

  static const double minPower = 300.0;
  static const double maxPower = 1800.0;

  // Thresholds used by the rule-based optimization simulation.
  static const double highDemandPowerLimit = 1300.0;
  static const double overloadPowerLimit = 1650.0;

  // How often the demo engine ticks and pushes new readings.
  static const Duration demoTickInterval = Duration(seconds: 3);

  // Default configurable alert threshold shown in Settings.
  static const double defaultAlertPowerThreshold = 1600.0;
}
