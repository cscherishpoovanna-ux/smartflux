import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../models/energy_summary.dart';
import '../theme/app_colors.dart';

/// Reusable line chart for energy/power/voltage/current trends, driven
/// entirely by data supplied from the repository layer (never hardcoded).
class TrendChart extends StatelessWidget {
  final List<ChartPoint> points;
  final Color color;
  final double height;
  final bool showGrid;

  const TrendChart({
    super.key,
    required this.points,
    required this.color,
    this.height = 160,
    this.showGrid = false,
  });

  @override
  Widget build(BuildContext context) {
    if (points.isEmpty) {
      return SizedBox(
        height: height,
        child: const Center(
          child: Text(
            'No data yet',
            style: TextStyle(color: AppColors.textDisabled, fontSize: 12),
          ),
        ),
      );
    }

    final minY = points.map((p) => p.y).reduce((a, b) => a < b ? a : b);
    final maxY = points.map((p) => p.y).reduce((a, b) => a > b ? a : b);
    final padding =
        ((maxY - minY).abs() * 0.15).clamp(1, double.infinity).toDouble();

    return SizedBox(
      height: height,
      child: LineChart(
        LineChartData(
          minY: minY - padding,
          maxY: maxY + padding,
          gridData: FlGridData(
            show: showGrid,
            drawVerticalLine: false,
            horizontalInterval:
                ((maxY - minY) / 3).clamp(1, double.infinity).toDouble(),
            getDrawingHorizontalLine: (_) => const FlLine(
              color: AppColors.surfaceBorder,
              strokeWidth: 1,
            ),
          ),
          titlesData: const FlTitlesData(show: false),
          borderData: FlBorderData(show: false),
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              getTooltipColor: (_) => AppColors.surfaceElevated,
              getTooltipItems: (spots) => spots.map((s) {
                final idx = s.x.toInt().clamp(0, points.length - 1).toInt();
                return LineTooltipItem(
                  '${points[idx].label}\n${s.y.toStringAsFixed(1)}',
                  const TextStyle(color: AppColors.textPrimary, fontSize: 11),
                );
              }).toList(),
            ),
          ),
          lineBarsData: [
            LineChartBarData(
              spots: points.map((p) => FlSpot(p.x, p.y)).toList(),
              isCurved: true,
              curveSmoothness: 0.25,
              color: color,
              barWidth: 2.4,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    color.withValues(alpha: 0.28),
                    color.withValues(alpha: 0.0)
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
