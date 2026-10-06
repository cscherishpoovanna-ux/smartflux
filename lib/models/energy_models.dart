import '../core/enums/app_enums.dart';

class SensorChannel {
  final String id, roomId;
  final int? voltageAdc, currentAdc, relayChannel;
  final bool connected;
  const SensorChannel(
      {required this.id,
      required this.roomId,
      this.voltageAdc,
      this.currentAdc,
      this.relayChannel,
      this.connected = false});
}

class LoadModel {
  final String id, roomId, name;
  final LoadCategory category;
  final bool essential, controllable;
  final LoadState state;
  final double powerW, energyKwh;
  final int? relayChannel;
  final bool connected;
  const LoadModel(
      {required this.id,
      required this.roomId,
      required this.name,
      required this.category,
      required this.essential,
      required this.controllable,
      required this.state,
      required this.powerW,
      required this.energyKwh,
      this.relayChannel,
      this.connected = true});

  bool get isOn => state == LoadState.on;
  double get powerWatts => powerW;

  LoadModel copyWith(
          {LoadState? state,
          double? powerW,
          double? energyKwh,
          bool? connected}) =>
      LoadModel(
          id: id,
          roomId: roomId,
          name: name,
          category: category,
          essential: essential,
          controllable: controllable,
          state: state ?? this.state,
          powerW: powerW ?? this.powerW,
          energyKwh: energyKwh ?? this.energyKwh,
          relayChannel: relayChannel,
          connected: connected ?? this.connected);
}

class RoomModel {
  final String id, name, type;
  final bool enabled;
  final List<String> loadIds;
  final double voltageV, currentA, powerW, energyKwh;
  final bool connected;
  const RoomModel(
      {required this.id,
      required this.name,
      required this.type,
      this.enabled = true,
      this.loadIds = const [],
      this.voltageV = 0,
      this.currentA = 0,
      this.powerW = 0,
      this.energyKwh = 0,
      this.connected = true});
  RoomModel copyWith(
          {double? voltageV,
          double? currentA,
          double? powerW,
          double? energyKwh,
          bool? connected}) =>
      RoomModel(
          id: id,
          name: name,
          type: type,
          enabled: enabled,
          loadIds: loadIds,
          voltageV: voltageV ?? this.voltageV,
          currentA: currentA ?? this.currentA,
          powerW: powerW ?? this.powerW,
          energyKwh: energyKwh ?? this.energyKwh,
          connected: connected ?? this.connected);
}

class ReadingPoint {
  final DateTime time;
  final double value;
  const ReadingPoint(this.time, this.value);
}

class AlertModel {
  final String id, title, description;
  final AlertSeverity severity;
  final DateTime timestamp;
  final String? roomId, loadId;
  final bool read;
  const AlertModel(
      {required this.id,
      required this.title,
      required this.description,
      required this.severity,
      required this.timestamp,
      this.roomId,
      this.loadId,
      this.read = false});
  AlertModel copyWith({bool? read}) => AlertModel(
      id: id,
      title: title,
      description: description,
      severity: severity,
      timestamp: timestamp,
      roomId: roomId,
      loadId: loadId,
      read: read ?? this.read);
}

class OptimizationEvent {
  final String id, reason, action;
  final DateTime timestamp;
  final double demandBeforeW, demandAfterW;
  final String? loadId;
  const OptimizationEvent(
      {required this.id,
      required this.reason,
      required this.action,
      required this.timestamp,
      required this.demandBeforeW,
      required this.demandAfterW,
      this.loadId});
}

class SystemSnapshot {
  final double voltageV, currentA, powerW, energyKwh;
  final SystemStatus status;
  final bool demoMode, backendConnected;
  const SystemSnapshot(
      {required this.voltageV,
      required this.currentA,
      required this.powerW,
      required this.energyKwh,
      required this.status,
      required this.demoMode,
      required this.backendConnected});
}

class AppConfig {
  final double highDemandW, overloadW;
  const AppConfig({this.highDemandW = 1800, this.overloadW = 2400});
}
