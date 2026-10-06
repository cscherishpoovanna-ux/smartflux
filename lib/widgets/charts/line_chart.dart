import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../models/energy_models.dart';

class SmartLineChart extends StatelessWidget {
  final List<ReadingPoint> points;
  final Color color;
  final String unit;

  const SmartLineChart({
    super.key,
    required this.points,
    required this.color,
    required this.unit,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final onSurface = theme.colorScheme.onSurface;
    final dividerColor = theme.dividerColor;

    if (points.isEmpty) {
      return SizedBox(
        height: 230,
        child: Center(
          child: Text(
            'No chart data available.',
            style: TextStyle(
              color: onSurface.withValues(alpha: 0.6),
              fontSize: 13,
            ),
          ),
        ),
      );
    }

    final values = points.map((e) => e.value).toList();
    final minY = values.reduce((a, b) => a < b ? a : b);
    final maxY = values.reduce((a, b) => a > b ? a : b);
    final yRange = (maxY - minY).abs();
    final yPad = yRange < 0.01 ? 1.0 : yRange * 0.18;
    final adjustedMinY = (minY - yPad).clamp(0.0, double.infinity).toDouble();
    final adjustedMaxY = maxY + yPad;
    final interval = max(0.5, (adjustedMaxY - adjustedMinY) / 4);

    final spots = points.asMap().entries.map((e) {
      return FlSpot(e.key.toDouble(), e.value.value);
    }).toList();

    return SizedBox(
      height: 240,
      child: Padding(
        padding: const EdgeInsets.only(top: 14, right: 14, bottom: 6, left: 4),
        child: LineChart(
          LineChartData(
            minY: adjustedMinY,
            maxY: adjustedMaxY,
            gridData: FlGridData(
              show: true,
              drawVerticalLine: false,
              horizontalInterval: interval,
              getDrawingHorizontalLine: (value) => FlLine(
                color: dividerColor.withValues(alpha: 0.12),
                strokeWidth: 1,
              ),
            ),
            titlesData: FlTitlesData(
              show: true,
              topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 42,
                  interval: interval,
                  getTitlesWidget: (value, meta) {
                    if (value == meta.min || value == meta.max) return const SizedBox.shrink();
                    return Padding(
                      padding: const EdgeInsets.only(right: 6),
                      child: Text(
                        value >= 1000
                            ? '${(value / 1000).toStringAsFixed(1)}k'
                            : value.toStringAsFixed(value < 10 ? 1 : 0),
                        style: TextStyle(
                          color: onSurface.withValues(alpha: 0.6),
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.right,
                      ),
                    );
                  },
                ),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 26,
                  interval: _calcBottomInterval(points.length),
                  getTitlesWidget: (value, meta) {
                    final idx = value.toInt();
                    if (idx < 0 || idx >= points.length) return const SizedBox.shrink();
                    final time = points[idx].time;
                    final label = _formatTimeLabel(time, points.length);
                    return Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Text(
                        label,
                        style: TextStyle(
                          color: onSurface.withValues(alpha: 0.65),
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            borderData: FlBorderData(show: false),
            lineTouchData: LineTouchData(
              touchTooltipData: LineTouchTooltipData(
                tooltipBorderRadius: BorderRadius.circular(10),
                getTooltipColor: (_) => theme.cardColor,
                getTooltipItems: (touchedSpots) {
                  return touchedSpots.map((spot) {
                    final idx = spot.x.toInt().clamp(0, points.length - 1);
                    final pt = points[idx];
                    final timeStr =
                        '${pt.time.hour.toString().padLeft(2, '0')}:${pt.time.minute.toString().padLeft(2, '0')}';
                    return LineTooltipItem(
                      '$timeStr\n${spot.y.toStringAsFixed(2)} $unit',
                      TextStyle(
                        color: color,
                        fontWeight: FontWeight.w800,
                        fontSize: 12,
                      ),
                    );
                  }).toList();
                },
              ),
            ),
            lineBarsData: [
              LineChartBarData(
                spots: spots,
                isCurved: true,
                curveSmoothness: 0.28,
                preventCurveOverShooting: true,
                color: color,
                barWidth: 3,
                isStrokeCapRound: true,
                dotData: FlDotData(
                  show: points.length <= 12,
                  getDotPainter: (spot, percent, barData, index) => FlDotCirclePainter(
                    radius: 3.5,
                    color: color,
                    strokeWidth: 2,
                    strokeColor: theme.cardColor,
                  ),
                ),
                belowBarData: BarAreaData(
                  show: true,
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      color.withValues(alpha: 0.28),
                      color.withValues(alpha: 0.0),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static double _calcBottomInterval(int length) {
    if (length <= 7) return 1;
    if (length <= 14) return 2;
    if (length <= 24) return 4;
    return (length / 5).floorToDouble().clamp(1.0, double.infinity);
  }

  static String _formatTimeLabel(DateTime time, int totalPoints) {
    if (totalPoints <= 12) {
      return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
    } else if (totalPoints <= 24) {
      return '${time.hour.toString().padLeft(2, '0')}:00';
    } else if (totalPoints <= 28) {
      const weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
      return weekdays[time.weekday - 1];
    } else {
      return '${time.day}/${time.month}';
    }
  }
}
