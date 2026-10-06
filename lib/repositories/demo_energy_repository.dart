import 'dart:async';
import 'dart:math';
import '../core/enums/app_enums.dart';
import '../models/energy_models.dart';
import '../services/demo_data_engine.dart';
import 'energy_repository.dart';

class DemoEnergyRepository implements EnergyRepository {
  final DemoDataEngine engine;
  final _snapshot = StreamController<SystemSnapshot>.broadcast();
  final _rooms = StreamController<List<RoomModel>>.broadcast();
  final _loads = StreamController<List<LoadModel>>.broadcast();
  final _alerts = StreamController<List<AlertModel>>.broadcast();
  final _events = StreamController<List<OptimizationEvent>>.broadcast();
  Timer? _timer;
  SystemSnapshot? _latest;

  DemoEnergyRepository({DemoDataEngine? engine})
      : engine = engine ?? DemoDataEngine() {
    _timer = Timer.periodic(const Duration(seconds: 2), (_) => _emit());
    _emit();
  }

  void _emit() {
    _latest = engine.tickSnapshot();
    _snapshot.add(_latest!);
    _rooms.add(engine.rooms);
    _loads.add(engine.loads);
    _alerts.add(List.unmodifiable(engine.alerts));
    _events.add(List.unmodifiable(engine.optimizationEvents));
  }

  @override
  AppConfig get config => engine.config;

  @override
  Stream<SystemSnapshot> watchSnapshot() => _snapshot.stream;

  @override
  Stream<List<RoomModel>> watchRooms() => _rooms.stream;

  @override
  Stream<List<LoadModel>> watchLoads() => _loads.stream;

  @override
  Stream<List<AlertModel>> watchAlerts() => _alerts.stream;

  @override
  Stream<List<OptimizationEvent>> watchOptimizationEvents() => _events.stream;

  @override
  Future<List<ReadingPoint>> history({
    required String metric,
    required TimeRange range,
    String? roomId,
  }) async {
    final count = switch (range) {
      TimeRange.today => 24,
      TimeRange.days7 => 28,
      TimeRange.days30 => 30,
      TimeRange.week => 28,
      TimeRange.month => 30,
      TimeRange.hour1 => 12,
      TimeRange.hour6 => 24,
      TimeRange.hour24 => 24,
    };

    final double activeLoadsPower = engine.loads
        .where((l) => l.state == LoadState.on)
        .fold<double>(0.0, (double s, LoadModel l) => s + l.powerW);
    final double basePower = _latest?.powerW ?? activeLoadsPower;
    final double base = basePower > 0 ? basePower : 880.0;
    final now = DateTime.now();

    return List.generate(count, (i) {
      final double hourRatio = (i / max(1, count - 1)) * 24.0;
      final double diurnal = 0.70 +
          0.30 * sin((hourRatio - 6.0) * pi / 12.0).clamp(-0.4, 1.0) +
          0.12 * sin(i * 1.7) +
          0.06 * cos(i * 3.1);
      final double wave = diurnal * base;

      final double v = switch (metric) {
        'voltage' => 228.0 + sin(i / 3.0) * 3.5 + cos(i * 1.1) * 1.5,
        'current' => max(0.2, wave / 230.0),
        'energy' => switch (range) {
            TimeRange.today =>
              max(0.05, (wave / 1000.0) * (0.8 + 0.35 * sin(i / 2.5))),
            TimeRange.days7 =>
              max(1.5, (wave / 1000.0) * 5.8 + sin(i * 0.9) * 1.8),
            TimeRange.days30 =>
              max(1.5, (wave / 1000.0) * 5.5 + sin(i * 0.7) * 2.0),
            _ => max(0.05, wave / 1000.0),
          },
        _ => max(0.0, wave),
      };

      final DateTime timestamp = switch (range) {
        TimeRange.today => now.subtract(Duration(hours: count - 1 - i)),
        TimeRange.days7 => now.subtract(Duration(hours: (count - 1 - i) * 6)),
        TimeRange.days30 => now.subtract(Duration(days: count - 1 - i)),
        _ => now.subtract(Duration(minutes: (count - 1 - i) * 5)),
      };

      return ReadingPoint(timestamp, double.parse(v.toStringAsFixed(2)));
    });
  }

  @override
  Future<CommandStatus> controlLoad(String loadId, bool turnOn) async {
    await Future<void>.delayed(const Duration(milliseconds: 150));
    final success = engine.setLoadState(loadId, turnOn);
    if (!success) return CommandStatus.failed;

    _loads.add(engine.loads);
    _rooms.add(engine.rooms);
    _snapshot.add(engine.tickSnapshot());
    return CommandStatus.executed;
  }

  @override
  Future<void> markAlertRead(String alertId) async {
    final i = engine.alerts.indexWhere((a) => a.id == alertId);
    if (i >= 0) engine.alerts[i] = engine.alerts[i].copyWith(read: true);
    _alerts.add(List.unmodifiable(engine.alerts));
  }

  @override
  Future<void> markAllRead() async {
    for (var i = 0; i < engine.alerts.length; i++) {
      engine.alerts[i] = engine.alerts[i].copyWith(read: true);
    }
    _alerts.add(List.unmodifiable(engine.alerts));
  }

  void dispose() {
    _timer?.cancel();
    _snapshot.close();
    _rooms.close();
    _loads.close();
    _alerts.close();
    _events.close();
  }
}
