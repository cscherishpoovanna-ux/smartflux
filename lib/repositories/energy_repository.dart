import '../models/energy_models.dart';
import '../core/enums/app_enums.dart';

abstract class EnergyRepository {
  Stream<SystemSnapshot> watchSnapshot();
  Stream<List<RoomModel>> watchRooms();
  Stream<List<LoadModel>> watchLoads();
  Stream<List<AlertModel>> watchAlerts();
  Stream<List<OptimizationEvent>> watchOptimizationEvents();
  Future<List<ReadingPoint>> history({required String metric, required TimeRange range, String? roomId});
  Future<CommandStatus> controlLoad(String loadId, bool turnOn);
  Future<void> markAlertRead(String alertId);
  Future<void> markAllRead();
  AppConfig get config;
}
