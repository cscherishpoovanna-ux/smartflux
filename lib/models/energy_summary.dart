/// Aggregated statistics shown on the Dashboard and Analytics screens.
class EnergySummary {
  final double todayEnergyKwh;
  final double peakPowerW;
  final double averagePowerW;
  final double peakCurrentA;
  final List<ChartPoint> powerTrend;
  final List<ChartPoint> voltageTrend;
  final List<ChartPoint> currentTrend;
  final List<ChartPoint> energyTrend;

  const EnergySummary({
    required this.todayEnergyKwh,
    required this.peakPowerW,
    required this.averagePowerW,
    required this.peakCurrentA,
    required this.powerTrend,
    required this.voltageTrend,
    required this.currentTrend,
    required this.energyTrend,
  });

  factory EnergySummary.empty() => const EnergySummary(
        todayEnergyKwh: 0,
        peakPowerW: 0,
        averagePowerW: 0,
        peakCurrentA: 0,
        powerTrend: [],
        voltageTrend: [],
        currentTrend: [],
        energyTrend: [],
      );
}

/// A single (x, y) sample used to feed the fl_chart line charts.
/// [label] is a short axis label (e.g. "10:42" or "Mon").
class ChartPoint {
  final double x;
  final double y;
  final String label;

  const ChartPoint({required this.x, required this.y, required this.label});
}
