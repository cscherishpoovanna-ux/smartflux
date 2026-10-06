import 'dart:math';
import '../core/enums/app_enums.dart';
import '../models/energy_models.dart';

class OptimizationDecision {
  final bool intervene;
  final LoadModel? load;
  final String reason;
  const OptimizationDecision({required this.intervene, this.load, required this.reason});
}

class OptimizationService {
  const OptimizationService();
  OptimizationDecision evaluate({required double demandW, required AppConfig config, required List<LoadModel> loads}) {
    if (demandW < config.overloadW) return const OptimizationDecision(intervene: false, reason: 'Demand is below the overload threshold.');
    LoadModel? candidate;
    for (final load in loads) {
      if (load.controllable && !load.essential && load.state == LoadState.on && (candidate == null || load.powerW > candidate.powerW)) candidate = load;
    }
    if (candidate == null) return const OptimizationDecision(intervene: false, reason: 'No eligible non-essential controllable load is available.');
    return OptimizationDecision(intervene: true, load: candidate, reason: 'Demand exceeded the configured overload threshold.');
  }
  double estimatedCurrent(double powerW, double voltageV) => powerW / max(voltageV, 1);
}
