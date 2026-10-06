import '../core/enums.dart';

/// Optional solar + battery storage data.
/// Kept fully separate from the core electrical models so the renewable
/// feature can be hidden/disabled without touching the main dashboard.
class RenewableEnergyData {
  final bool isEnabled;
  final double solarGenerationKw;
  final int batteryPercent;
  final BatteryStatus batteryStatus;

  const RenewableEnergyData({
    required this.isEnabled,
    required this.solarGenerationKw,
    required this.batteryPercent,
    required this.batteryStatus,
  });

  factory RenewableEnergyData.initial() => const RenewableEnergyData(
        isEnabled: true,
        solarGenerationKw: 0,
        batteryPercent: 0,
        batteryStatus: BatteryStatus.idle,
      );

  RenewableEnergyData copyWith({
    bool? isEnabled,
    double? solarGenerationKw,
    int? batteryPercent,
    BatteryStatus? batteryStatus,
  }) {
    return RenewableEnergyData(
      isEnabled: isEnabled ?? this.isEnabled,
      solarGenerationKw: solarGenerationKw ?? this.solarGenerationKw,
      batteryPercent: batteryPercent ?? this.batteryPercent,
      batteryStatus: batteryStatus ?? this.batteryStatus,
    );
  }
}
