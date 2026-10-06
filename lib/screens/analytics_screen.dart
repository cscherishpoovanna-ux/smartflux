import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/enums.dart';
import '../models/energy_summary.dart';
import '../providers/energy_provider.dart';
import '../theme/app_colors.dart';
import '../utils/formatters.dart';
import '../widgets/section_header.dart';
import '../widgets/trend_chart.dart';

/// Detailed analytics beyond the dashboard: usage by period, and
/// power/voltage/current trends (see project brief #14).
class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final energy = context.watch<EnergyProvider>();
    final summary = energy.summary;

    return Scaffold(
      appBar: AppBar(title: const Text('Analytics')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        children: [
          Row(
            children: TimeRange.values.map((r) {
              final selected = energy.selectedRange == r;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: Text(r.label),
                  selected: selected,
                  onSelected: (_) => energy.refreshSummary(range: r),
                  selectedColor: AppColors.primary.withValues(alpha: 0.2),
                  labelStyle: TextStyle(
                    color:
                        selected ? AppColors.primary : AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 18),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 2.3,
            children: [
              _StatBox(
                label: "Today's Energy",
                value: Formatters.energy(summary.todayEnergyKwh),
                color: AppColors.energy,
              ),
              _StatBox(
                label: 'Peak Power',
                value: '${(summary.peakPowerW / 1000).toStringAsFixed(2)} kW',
                color: AppColors.power,
              ),
              _StatBox(
                label: 'Average Power',
                value:
                    '${(summary.averagePowerW / 1000).toStringAsFixed(2)} kW',
                color: AppColors.info,
              ),
              _StatBox(
                label: 'Peak Current',
                value: Formatters.current(summary.peakCurrentA),
                color: AppColors.current,
              ),
            ],
          ),
          const SizedBox(height: 20),
          const SectionHeader(title: 'Power Trend'),
          _ChartCard(points: summary.powerTrend, color: AppColors.power),
          const SizedBox(height: 20),
          const SectionHeader(title: 'Voltage Trend'),
          _ChartCard(points: summary.voltageTrend, color: AppColors.voltage),
          const SizedBox(height: 20),
          const SectionHeader(title: 'Current Trend'),
          _ChartCard(points: summary.currentTrend, color: AppColors.current),
        ],
      ),
    );
  }
}

class _StatBox extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  const _StatBox(
      {required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.surfaceBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(label, style: Theme.of(context).textTheme.labelSmall),
          const SizedBox(height: 4),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              value,
              style: TextStyle(
                  fontSize: 18, fontWeight: FontWeight.w800, color: color),
            ),
          ),
        ],
      ),
    );
  }
}

class _ChartCard extends StatelessWidget {
  final List<ChartPoint> points;
  final Color color;
  const _ChartCard({required this.points, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.surfaceBorder),
      ),
      child: TrendChart(points: points, color: color, showGrid: true),
    );
  }
}
