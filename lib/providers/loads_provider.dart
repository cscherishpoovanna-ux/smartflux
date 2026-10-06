import 'dart:async';

import 'package:flutter/foundation.dart';

import '../core/enums/app_enums.dart';
import '../models/energy_models.dart';
import '../repositories/energy_repository.dart';

class LoadsProvider extends ChangeNotifier {
  final EnergyRepository _repository;

  LoadsProvider(this._repository) {
    _sub = _repository.watchLoads().listen(
      (list) {
        loads = list;
        state = loads.isEmpty ? DataState.empty : DataState.success;
        notifyListeners();
      },
      onError: (_) {
        state = DataState.error;
        notifyListeners();
      },
    );
  }

  DataState state = DataState.loading;

  List<LoadModel> loads = const [];

  final Set<String> _pendingIds = {};

  bool isPending(String id) => _pendingIds.contains(id);

  double get totalActivePower =>
      loads.where((load) => load.state == LoadState.on).fold<double>(
            0,
            (sum, load) => sum + load.powerW,
          );

  Future<void> toggleLoad(String id) async {
    final index = loads.indexWhere((load) => load.id == id);

    if (index == -1) {
      return;
    }

    final target = loads[index];

    if (!target.controllable) {
      return;
    }

    final newState = target.state != LoadState.on;

    _pendingIds.add(id);
    notifyListeners();

    try {
      await _repository.controlLoad(id, newState);
    } finally {
      _pendingIds.remove(id);
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }

  late final StreamSubscription<List<LoadModel>> _sub;
}
