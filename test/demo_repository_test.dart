import 'package:flutter_test/flutter_test.dart';
import 'package:smartflux/core/enums/app_enums.dart';
import 'package:smartflux/repositories/demo_energy_repository.dart';

void main() {
  test('demo repository exposes dynamic prototype rooms including reserved room', () async {
    final repo = DemoEnergyRepository();
    final rooms = await repo.watchRooms().first;
    expect(rooms.length, 4);
    expect(rooms.last.connected, isFalse);
    expect(rooms.last.loadIds, isEmpty);
    repo.dispose();
  });

  test('demo history has consistent power/current scale', () async {
    final repo = DemoEnergyRepository();
    final points = await repo.history(metric: 'current', range: TimeRange.hour1);
    expect(points.length, greaterThan(10));
    expect(points.every((p) => p.value > 0), isTrue);
    repo.dispose();
  });

  test('controlLoad successfully toggles controllable load ON and OFF', () async {
    final repo = DemoEnergyRepository();
    final initialLoads = await repo.watchLoads().first;
    final motor = initialLoads.firstWhere((l) => l.id == 'load-motor-1');
    expect(motor.controllable, isTrue);
    expect(motor.state, LoadState.on);

    // Turn OFF
    final offStatus = await repo.controlLoad('load-motor-1', false);
    expect(offStatus, CommandStatus.executed);
    final loadsAfterOff = await repo.watchLoads().first;
    final motorAfterOff = loadsAfterOff.firstWhere((l) => l.id == 'load-motor-1');
    expect(motorAfterOff.state, LoadState.off);
    expect(motorAfterOff.powerW, 0.0);

    // Turn ON
    final onStatus = await repo.controlLoad('load-motor-1', true);
    expect(onStatus, CommandStatus.executed);
    final loadsAfterOn = await repo.watchLoads().first;
    final motorAfterOn = loadsAfterOn.firstWhere((l) => l.id == 'load-motor-1');
    expect(motorAfterOn.state, LoadState.on);
    expect(motorAfterOn.powerW, greaterThan(0));

    // Non-controllable load must fail
    final nonControllable = await repo.controlLoad('load-led-2', false);
    expect(nonControllable, CommandStatus.failed);

    repo.dispose();
  });

  test('demo history returns multi-point variations for today, 7 days, and 30 days', () async {
    final repo = DemoEnergyRepository();

    final todayPoints = await repo.history(metric: 'energy', range: TimeRange.today);
    expect(todayPoints.length, 24);
    expect(todayPoints.every((p) => p.value > 0), isTrue);

    final days7Points = await repo.history(metric: 'energy', range: TimeRange.days7);
    expect(days7Points.length, 28);
    expect(days7Points.every((p) => p.value > 0), isTrue);

    final days30Points = await repo.history(metric: 'energy', range: TimeRange.days30);
    expect(days30Points.length, 30);
    expect(days30Points.every((p) => p.value > 0), isTrue);

    repo.dispose();
  });
}
