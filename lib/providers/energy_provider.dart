import 'dart:async';

import 'package:flutter/foundation.dart';

import '../core/enums/app_enums.dart';
import '../models/energy_models.dart';
import '../models/energy_summary.dart';
import '../repositories/energy_repository.dart';

class EnergyProvider extends ChangeNotifier {
  final EnergyRepository _repository;

  EnergyProvider(this._repository) {
    _init();
  }

  DataState state = DataState.loading;

  EnergyReadingData reading = EnergyReadingData.empty();
  SystemStatusData systemStatus = SystemStatusData.initial();
  OptimizationStatusData optimizationStatus = OptimizationStatusData.idle();

  TimeRange selectedRange = TimeRange.hour24;

  DateTime? _lastUpdateTime;
  bool _offline = false;

  bool get isOffline => _offline;
  DateTime? get lastUpdateTime => _lastUpdateTime;

  EnergySummary get summary => EnergySummary(
        todayEnergyKwh: reading.energy,
        peakPowerW: reading.power,
        averagePowerW: reading.power,
        peakCurrentA: reading.current,
        powerTrend: const [],
        voltageTrend: const [],
        currentTrend: const [],
        energyTrend: const [],
      );

  StreamSubscription<SystemSnapshot>? _snapshotSub;
  StreamSubscription<List<OptimizationEvent>>? _optimizationSub;
  Timer? _offlineWatchdog;

  void _init() {
    _snapshotSub = _repository.watchSnapshot().listen(
      (snapshot) {
        reading = EnergyReadingData(
          timestamp: DateTime.now(),
          voltage: snapshot.voltageV,
          current: snapshot.currentA,
          power: snapshot.powerW,
          energy: snapshot.energyKwh,
        );

        systemStatus = SystemStatusData(
          status: snapshot.status,
          isOnline: snapshot.backendConnected || snapshot.demoMode,
          demoMode: snapshot.demoMode,
          backendConnected: snapshot.backendConnected,
          lastUpdated: DateTime.now(),
        );

        _lastUpdateTime = DateTime.now();
        _offline = false;
        state = DataState.success;

        notifyListeners();
        _resetOfflineWatchdog();
      },
      onError: (_) {
        state = DataState.error;
        notifyListeners();
      },
    );

    _optimizationSub = _repository.watchOptimizationEvents().listen((events) {
      if (events.isEmpty) {
        optimizationStatus = OptimizationStatusData.idle();
      } else {
        final event = events.last;

        optimizationStatus = OptimizationStatusData(
          isActive: true,
          reason: event.reason,
          action: event.action,
          timestamp: event.timestamp,
        );
      }

      notifyListeners();
    });

    _resetOfflineWatchdog();
  }

  void _resetOfflineWatchdog() {
    _offlineWatchdog?.cancel();

    _offlineWatchdog = Timer(
      const Duration(seconds: 12),
      () {
        _offline = true;
        state = DataState.offline;
        notifyListeners();
      },
    );
  }

  Future<List<ReadingPoint>> getHistory({
    String metric = 'power',
    TimeRange? range,
  }) {
    final selected = range ?? selectedRange;

    if (range != null) {
      selectedRange = range;
      notifyListeners();
    }

    return _repository.history(
      metric: metric,
      range: selected,
    );
  }

  Future<void> refreshSummary({TimeRange? range}) async {
    if (range != null) {
      selectedRange = range;
    }
    notifyListeners();
  }

  @override
  void dispose() {
    _snapshotSub?.cancel();
    _optimizationSub?.cancel();
    _offlineWatchdog?.cancel();
    super.dispose();
  }
}

class EnergyReadingData {
  final DateTime timestamp;
  final double voltage;
  final double current;
  final double power;
  final double energy;

  const EnergyReadingData({
    required this.timestamp,
    required this.voltage,
    required this.current,
    required this.power,
    required this.energy,
  });

  factory EnergyReadingData.empty() {
    return EnergyReadingData(
      timestamp: DateTime.now(),
      voltage: 0,
      current: 0,
      power: 0,
      energy: 0,
    );
  }
}

class SystemStatusData {
  final SystemStatus status;
  final bool isOnline;
  final bool demoMode;
  final bool backendConnected;
  final DateTime lastUpdated;

  const SystemStatusData({
    required this.status,
    required this.isOnline,
    required this.demoMode,
    required this.backendConnected,
    required this.lastUpdated,
  });

  factory SystemStatusData.initial() {
    return SystemStatusData(
      status: SystemStatus.offline,
      isOnline: false,
      demoMode: false,
      backendConnected: false,
      lastUpdated: DateTime.now(),
    );
  }

  GridStatus get gridStatus => switch (status) {
        SystemStatus.normal => GridStatus.normal,
        SystemStatus.highDemand => GridStatus.highDemand,
        SystemStatus.overload => GridStatus.overload,
        SystemStatus.offline => GridStatus.offline,
      };

  bool get esp32Connected => isOnline || demoMode;
  bool get voltageSensorActive => true;
  bool get currentSensorActive => true;
  bool get relayConnected => true;
  bool get communicationConnected => isOnline || demoMode;
  bool get backendOnline => isOnline || demoMode;
  bool get databaseConnected => backendConnected || demoMode;
}

class OptimizationStatusData {
  final bool isActive;
  final String reason;
  final String? action;
  final DateTime timestamp;

  const OptimizationStatusData({
    required this.isActive,
    required this.reason,
    required this.action,
    required this.timestamp,
  });

  factory OptimizationStatusData.idle() {
    return OptimizationStatusData(
      isActive: false,
      reason: 'No optimization action',
      action: null,
      timestamp: DateTime.now(),
    );
  }

  String? get affectedLoadName => null;
}
