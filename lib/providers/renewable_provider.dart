import 'package:flutter/foundation.dart';

import '../models/renewable_energy_data.dart';
import '../repositories/energy_repository.dart';

class RenewableProvider extends ChangeNotifier {
  final EnergyRepository _repository;

  RenewableProvider(this._repository);

  RenewableEnergyData data = RenewableEnergyData.initial();

  EnergyRepository get repository => _repository;
  bool get isConfigured => data.isEnabled;
}
