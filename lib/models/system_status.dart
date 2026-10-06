import '../core/enums.dart';

/// Snapshot of the overall grid + hardware connectivity status.
class SystemStatus {
  final GridStatus gridStatus;
  final bool isOnline;
  final DateTime lastUpdated;

  // Device / connectivity monitoring (System Status screen).
  final bool esp32Connected;
  final bool voltageSensorActive;
  final bool currentSensorActive;
  final bool relayConnected;
  final bool communicationConnected;
  final bool backendOnline;
  final bool databaseConnected;

  const SystemStatus({
    required this.gridStatus,
    required this.isOnline,
    required this.lastUpdated,
    required this.esp32Connected,
    required this.voltageSensorActive,
    required this.currentSensorActive,
    required this.relayConnected,
    required this.communicationConnected,
    required this.backendOnline,
    required this.databaseConnected,
  });

  factory SystemStatus.initial() => SystemStatus(
        gridStatus: GridStatus.normal,
        isOnline: true,
        lastUpdated: DateTime.now(),
        esp32Connected: true,
        voltageSensorActive: true,
        currentSensorActive: true,
        relayConnected: true,
        communicationConnected: true,
        backendOnline: true,
        databaseConnected: true,
      );

  SystemStatus copyWith({
    GridStatus? gridStatus,
    bool? isOnline,
    DateTime? lastUpdated,
    bool? esp32Connected,
    bool? voltageSensorActive,
    bool? currentSensorActive,
    bool? relayConnected,
    bool? communicationConnected,
    bool? backendOnline,
    bool? databaseConnected,
  }) {
    return SystemStatus(
      gridStatus: gridStatus ?? this.gridStatus,
      isOnline: isOnline ?? this.isOnline,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      esp32Connected: esp32Connected ?? this.esp32Connected,
      voltageSensorActive: voltageSensorActive ?? this.voltageSensorActive,
      currentSensorActive: currentSensorActive ?? this.currentSensorActive,
      relayConnected: relayConnected ?? this.relayConnected,
      communicationConnected:
          communicationConnected ?? this.communicationConnected,
      backendOnline: backendOnline ?? this.backendOnline,
      databaseConnected: databaseConnected ?? this.databaseConnected,
    );
  }
}

/// Result of the backend's rule-based optimization engine, as displayed
/// (not computed) by the mobile app.
class OptimizationStatus {
  final bool isActive;
  final String reason;
  final String? affectedLoadName;
  final String? action;
  final DateTime timestamp;

  const OptimizationStatus({
    required this.isActive,
    required this.reason,
    this.affectedLoadName,
    this.action,
    required this.timestamp,
  });

  factory OptimizationStatus.idle() => OptimizationStatus(
        isActive: false,
        reason: 'Power usage within safe limits.',
        timestamp: DateTime.now(),
      );
}
