import 'package:flutter/material.dart';
import '../core/enums/app_enums.dart';
import '../models/energy_models.dart';
import '../repositories/energy_repository.dart';

class AppProvider extends ChangeNotifier {
  final EnergyRepository repository;
  ThemePreference themePreference = ThemePreference.system;
  SystemSnapshot? snapshot;
  List<RoomModel> rooms = const [];
  List<LoadModel> loads = const [];
  List<AlertModel> alerts = const [];
  List<OptimizationEvent> optimizationEvents = const [];
  bool busy = false;
  String? error;
  AppProvider(this.repository) {
    repository.watchSnapshot().listen((v) { snapshot = v; notifyListeners(); });
    repository.watchRooms().listen((v) { rooms = v; notifyListeners(); });
    repository.watchLoads().listen((v) { loads = v; notifyListeners(); });
    repository.watchAlerts().listen((v) { alerts = v; notifyListeners(); });
    repository.watchOptimizationEvents().listen((v) { optimizationEvents = v; notifyListeners(); });
  }
  void setTheme(ThemePreference value) { themePreference = value; notifyListeners(); }
  Future<bool> controlLoad(LoadModel load, bool state) async { busy = true; error = null; notifyListeners(); final result = await repository.controlLoad(load.id, state); busy = false; if (result == CommandStatus.failed || result == CommandStatus.timeout) error = 'The command could not be completed.'; notifyListeners(); return result == CommandStatus.executed || result == CommandStatus.acknowledged; }
  Future<void> markAlertRead(String id) => repository.markAlertRead(id);

  Future<void> markAllRead() async {
    await repository.markAllRead();
    notifyListeners();
  }
}
