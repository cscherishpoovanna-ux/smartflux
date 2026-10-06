import 'dart:math';

import '../core/enums/app_enums.dart';
import '../models/energy_models.dart';

class DemoDataEngine {
  final Random _random = Random(42);
  final AppConfig config;

  static const Map<String, double> _nominalPowers = {
    'load-motor-1': 650.0,
    'load-led-1': 110.0,
    'load-led-2': 120.0,
    'load-motor-2': 760.0,
  };

  final List<RoomModel> _rooms = [
    const RoomModel(
      id: 'room-1',
      name: 'Room 1',
      type: 'Motor area',
      loadIds: ['load-motor-1'],
      connected: true,
      voltageV: 230.0,
      currentA: 2.83,
      powerW: 650.0,
      energyKwh: 0.42,
    ),
    const RoomModel(
      id: 'room-2',
      name: 'Room 2',
      type: 'Lighting',
      loadIds: ['load-led-1'],
      connected: true,
      voltageV: 230.0,
      currentA: 0.48,
      powerW: 110.0,
      energyKwh: 0.11,
    ),
    const RoomModel(
      id: 'room-3',
      name: 'Room 3',
      type: 'Lighting + Motor',
      loadIds: ['load-led-2', 'load-motor-2'],
      connected: true,
      voltageV: 230.0,
      currentA: 3.83,
      powerW: 880.0,
      energyKwh: 0.64,
    ),
    const RoomModel(
      id: 'room-4',
      name: 'Room 4',
      type: 'Reserved',
      loadIds: [],
      connected: false,
      voltageV: 0.0,
      currentA: 0.0,
      powerW: 0.0,
      energyKwh: 0.0,
    ),
  ];

  final List<LoadModel> _loads = [
    const LoadModel(
      id: 'load-motor-1',
      roomId: 'room-1',
      name: 'Motor',
      category: LoadCategory.motor,
      essential: false,
      controllable: true,
      state: LoadState.on,
      powerW: 650,
      energyKwh: 0.42,
      relayChannel: 1,
    ),
    const LoadModel(
      id: 'load-led-1',
      roomId: 'room-2',
      name: 'LED',
      category: LoadCategory.lighting,
      essential: false,
      controllable: true,
      state: LoadState.on,
      powerW: 110,
      energyKwh: 0.11,
      relayChannel: 2,
    ),
    const LoadModel(
      id: 'load-led-2',
      roomId: 'room-3',
      name: 'LED',
      category: LoadCategory.lighting,
      essential: true,
      controllable: false,
      state: LoadState.on,
      powerW: 120,
      energyKwh: 0.13,
    ),
    const LoadModel(
      id: 'load-motor-2',
      roomId: 'room-3',
      name: 'Motor',
      category: LoadCategory.motor,
      essential: false,
      controllable: true,
      state: LoadState.on,
      powerW: 760,
      energyKwh: 0.51,
      relayChannel: 3,
    ),
  ];

  final List<AlertModel> alerts = [];
  final List<OptimizationEvent> optimizationEvents = [];

  double energy = 1.17;
  int tick = 0;

  SystemStatus _lastStatus = SystemStatus.normal;

  DemoDataEngine({
    this.config = const AppConfig(),
  });

  bool setLoadState(String loadId, bool turnOn) {
    final int index = _loads.indexWhere((l) => l.id == loadId);
    if (index < 0) return false;
    final load = _loads[index];
    if (!load.controllable || load.state == LoadState.unavailable) return false;

    final newState = turnOn ? LoadState.on : LoadState.off;
    final double nominal = _nominalPowers[load.id] ?? (load.category == LoadCategory.motor ? 650.0 : 110.0);

    _loads[index] = load.copyWith(
      state: newState,
      powerW: turnOn ? nominal : 0.0,
    );

    // Update rooms immediately
    for (var i = 0; i < _rooms.length; i++) {
      final room = _rooms[i];
      if (!room.connected) continue;
      final roomLoads = _loads.where((l) => l.roomId == room.id && l.state == LoadState.on);
      final double roomPower = roomLoads.fold(0.0, (sum, l) => sum + l.powerW);
      final double roomVoltage = room.voltageV > 0 ? room.voltageV : 230.0;
      _rooms[i] = room.copyWith(
        powerW: roomPower,
        currentA: roomVoltage > 0 ? roomPower / roomVoltage : 0.0,
      );
    }

    return true;
  }

  SystemSnapshot tickSnapshot() {
    tick++;

    final double voltage =
        228.0 + 5.0 * sin(tick / 6) + (_random.nextDouble() - 0.5) * 3.0;

    final double demandBoost = tick % 37 > 29 ? 700.0 : 0.0;

    for (var i = 0; i < _loads.length; i++) {
      final load = _loads[i];

      if (load.state == LoadState.unavailable || load.state == LoadState.off) {
        if (load.state == LoadState.off && load.powerW != 0) {
          _loads[i] = load.copyWith(powerW: 0.0);
        }
        continue;
      }

      final double nominal = _nominalPowers[load.id] ?? load.powerW;
      final double variation = 1.0 +
          sin(tick / (5 + i)) * 0.10 +
          (_random.nextDouble() - 0.5) * 0.06;

      final double boosted = nominal +
          (load.category == LoadCategory.motor
              ? demandBoost * (i == 0 ? 0.55 : 0.35)
              : demandBoost * 0.08);

      final double adjustedPower = max(
        0.0,
        boosted * variation,
      );

      _loads[i] = load.copyWith(
        powerW: adjustedPower,
        energyKwh: load.energyKwh + adjustedPower / 360000.0,
      );
    }

    final double rawPower =
        _loads.where((load) => load.state == LoadState.on).fold(
              0.0,
              (sum, load) => sum + load.powerW,
            );

    final double power = rawPower;

    final double current = power / max(voltage, 1.0);

    energy += power / 3600000.0;

    final SystemStatus status = power >= config.overloadW
        ? SystemStatus.overload
        : power >= config.highDemandW
            ? SystemStatus.highDemand
            : SystemStatus.normal;

    // Check for state transitions and generate alerts only on meaningful changes
    if (status == SystemStatus.overload && _lastStatus != SystemStatus.overload) {
      _optimize(power);
    } else if (status == SystemStatus.highDemand && _lastStatus != SystemStatus.highDemand) {
      _addAlert(
        AlertSeverity.warning,
        'High demand',
        'Demand is above the configured high-demand threshold.',
      );
    } else if (status == SystemStatus.normal && (_lastStatus == SystemStatus.highDemand || _lastStatus == SystemStatus.overload)) {
      _addAlert(
        AlertSeverity.info,
        'System normal',
        'Demand returned to the configured normal range.',
      );
    }

    _lastStatus = status;

    for (final room in _rooms) {
      final roomLoads = _loads.where(
        (load) => load.roomId == room.id && load.state == LoadState.on,
      );

      final double roomPower = roomLoads.fold(
        0.0,
        (sum, load) => sum + load.powerW,
      );

      final double roomVoltage = room.connected
          ? voltage +
              sin(
                    tick / 9 + room.id.hashCode,
                  ) *
                  1.2
          : 0.0;

      final double roomCurrent =
          roomVoltage > 0.0 ? roomPower / roomVoltage : 0.0;

      final int index = _rooms.indexOf(room);

      _rooms[index] = room.copyWith(
        voltageV: roomVoltage,
        currentA: roomCurrent,
        powerW: roomPower,
        energyKwh: roomPower / 3600000.0 + room.energyKwh,
      );
    }

    return SystemSnapshot(
      voltageV: voltage,
      currentA: current,
      powerW: power,
      energyKwh: energy,
      status: status,
      demoMode: true,
      backendConnected: false,
    );
  }

  void _addAlert(
    AlertSeverity severity,
    String title,
    String description,
  ) {
    alerts.insert(
      0,
      AlertModel(
        id: 'a-${DateTime.now().microsecondsSinceEpoch}',
        title: title,
        description: description,
        severity: severity,
        timestamp: DateTime.now(),
        read: false,
      ),
    );

    if (alerts.length > 30) {
      alerts.removeLast();
    }
  }

  void _optimize(double before) {
    final int candidateIndex = _loads.indexWhere(
      (load) =>
          load.controllable && !load.essential && load.state == LoadState.on,
    );

    if (candidateIndex < 0) {
      return;
    }

    final candidate = _loads[candidateIndex];

    _loads[candidateIndex] = candidate.copyWith(
      state: LoadState.off,
      powerW: 0.0,
    );

    final double after = max(
      0.0,
      before - candidate.powerW,
    );

    optimizationEvents.insert(
      0,
      OptimizationEvent(
        id: 'o-${DateTime.now().microsecondsSinceEpoch}',
        reason: 'Demand exceeded overload threshold',
        action: '${candidate.name} disconnected in '
            '${candidate.roomId} to reduce demand.',
        timestamp: DateTime.now(),
        demandBeforeW: before,
        demandAfterW: after,
        loadId: candidate.id,
      ),
    );

    _addAlert(
      AlertSeverity.critical,
      'Load optimized',
      '${candidate.name} was disconnected automatically '
          'to reduce demand.',
    );
  }

  List<RoomModel> get rooms => List.unmodifiable(_rooms);

  List<LoadModel> get loads => List.unmodifiable(_loads);
}
