import 'dart:async';

import 'package:flutter/foundation.dart';

import '../core/enums.dart';
import '../core/enums/app_enums.dart';
import '../models/energy_models.dart';
import '../repositories/energy_repository.dart';

class AlertsProvider extends ChangeNotifier {
  final EnergyRepository _repository;

  AlertsProvider(this._repository) {
    _sub = _repository.watchAlerts().listen(
      (list) {
        alerts = list;
        state = alerts.isEmpty ? DataState.empty : DataState.success;
        notifyListeners();
      },
      onError: (_) {
        state = DataState.error;
        notifyListeners();
      },
    );
  }

  DataState state = DataState.loading;
  List<AlertModel> alerts = const [];

  int get unreadCount => alerts.where((a) => !a.read).length;

  bool isRead(String id) =>
      alerts.any((a) => a.id == id && a.read);

  void markRead(String id) {
    _repository.markAlertRead(id);
  }

  Future<void> markAllRead() async {
    for (final alert in alerts.where((a) => !a.read)) {
      await _repository.markAlertRead(alert.id);
    }
  }

  List<AlertModel> get criticalAndWarning => alerts
      .where(
        (a) =>
            a.severity == AlertSeverity.critical ||
            a.severity == AlertSeverity.warning,
      )
      .take(3)
      .toList();

  late final StreamSubscription<List<AlertModel>> _sub;

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }
}
