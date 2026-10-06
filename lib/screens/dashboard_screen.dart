import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/enums.dart';
import '../providers/alerts_provider.dart';
import '../providers/energy_provider.dart';
import '../providers/loads_provider.dart';
import '../providers/renewable_provider.dart';
import '../providers/settings_provider.dart';
import '../theme/app_colors.dart';
import '../utils/formatters.dart';
import '../widgets/alert_tile.dart';
import '../widgets/data_state_view.dart';
import '../widgets/metric_card.dart';
import '../widgets/section_header.dart';
import '../widgets/status_pill.dart';
import '../widgets/trend_chart.dart';
import 'alerts_screen.dart';
import 'analytics_screen.dart';
import 'loads_screen.dart';
import 'renewable_energy_screen.dart';

/// The primary screen: answers "what is happening with the electrical
/// system right now?" at a glance (see project brief #6-#10).
class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  Color _gridStatusColor(GridStatus s) {
    switch (s) {
      case GridStatus.normal:
        return AppColors.success;
      case GridStatus.highDemand:
        return AppColors.warning;
      case GridStatus.overload:
        return AppColors.critical;
      case GridStatus.offline:
        return AppColors.textDisabled;
    }
  }

  @override
  Widget build(BuildContext context) {
    final energy = context.watch<EnergyProvider>();
    final alerts = context.watch<AlertsProvider>();
    final settings = context.watch<SettingsProvider>();

    if (energy.state == DataState.loading) {
      return const DataStateView(state: DataState.loading);
    }

    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: () => energy.refreshSummary(),
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        children: [
          if (energy.state == DataState.offline)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: DataStateView(
                state: DataState.offline,
                lastUpdatedLabel: Formatters.relative(energy.lastUpdateTime),
              ),
            ),
          _Header(status: energy.systemStatus),
          const SizedBox(height: 18),
          if (alerts.criticalAndWarning.isNotEmpty) ...[
            SectionHeader(
              title: 'Alerts',
              trailing: TextButton(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const AlertsScreen()),
                ),
                child: const Text('See all'),
              ),
            ),
            ...alerts.criticalAndWarning.map(
              (a) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: AlertTile(alert: a, isRead: alerts.isRead(a.id)),
              ),
            ),
            const SizedBox(height: 8),
          ],
          const SectionHeader(title: 'Live Readings'),
          Row(
            children: [
              Expanded(
                child: MetricCard(
                  label: 'VOLTAGE',
                  value: energy.reading.voltage.toStringAsFixed(1),
                  unit: 'V',
                  icon: Icons.bolt_rounded,
                  accent: AppColors.voltage,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: MetricCard(
                  label: 'CURRENT',
                  value: energy.reading.current.toStringAsFixed(2),
                  unit: 'A',
                  icon: Icons.electric_meter_rounded,
                  accent: AppColors.current,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: MetricCard(
                  label: 'POWER',
                  value: energy.reading.power.toStringAsFixed(0),
                  unit: 'W',
                  icon: Icons.flash_on_rounded,
                  accent: AppColors.power,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SectionHeader(
            title: 'Energy Consumption',
            trailing: TextButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const AnalyticsScreen()),
              ),
              child: const Text('Details'),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.surfaceBorder),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('Today',
                        style: Theme.of(context).textTheme.bodyMedium),
                    const Spacer(),
                  ],
                ),
                Text(
                  Formatters.energy(energy.summary.todayEnergyKwh),
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 12),
                TrendChart(
                  points: energy.summary.powerTrend,
                  color: AppColors.energy,
                  height: 120,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const SectionHeader(title: 'Grid & System Status'),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.surfaceBorder),
            ),
            child: Column(
              children: [
                _StatusRow(
                  label: 'Grid Status',
                  child: StatusPill(
                    label: energy.systemStatus.gridStatus.label,
                    color: _gridStatusColor(energy.systemStatus.gridStatus),
                  ),
                ),
                const Divider(height: 22),
                _StatusRow(
                  label: 'Connection',
                  child: StatusPill(
                    label: energy.systemStatus.isOnline ? 'Online' : 'Offline',
                    color: energy.systemStatus.isOnline
                        ? AppColors.success
                        : AppColors.critical,
                  ),
                ),
                const Divider(height: 22),
                _StatusRow(
                  label: 'Last Updated',
                  child: Text(
                    Formatters.relative(energy.systemStatus.lastUpdated),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                if (energy.optimizationStatus.isActive) ...[
                  const Divider(height: 22),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.auto_fix_high_rounded,
                          size: 18, color: AppColors.warning),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Optimization Active',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: AppColors.warning,
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${energy.optimizationStatus.reason} '
                              '${energy.optimizationStatus.affectedLoadName ?? ''} '
                              '${energy.optimizationStatus.action ?? ''}',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 20),
          SectionHeader(
            title: 'Connected Loads',
            trailing: TextButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const LoadsScreen()),
              ),
              child: const Text('Manage'),
            ),
          ),
          const _LoadsPreview(),
          if (settings.renewableSectionEnabled) ...[
            const SizedBox(height: 20),
            SectionHeader(
              title: 'Renewable Energy',
              icon: Icons.eco_rounded,
              trailing: TextButton(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const RenewableEnergyScreen(),
                  ),
                ),
                child: const Text('View'),
              ),
            ),
            const _RenewablePreview(),
          ],
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final dynamic status;
  const _Header({required this.status});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.14),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.bolt_rounded, color: AppColors.primary),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('SmartFlux',
                  style: Theme.of(context).textTheme.displaySmall),
              Text(
                'Energy Grid Monitor',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
        StatusPill(
          label: status.isOnline ? 'SYSTEM ONLINE' : 'OFFLINE',
          color: status.isOnline ? AppColors.success : AppColors.critical,
        ),
      ],
    );
  }
}

class _StatusRow extends StatelessWidget {
  final String label;
  final Widget child;
  const _StatusRow({required this.label, required this.child});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            child: Text(label, style: Theme.of(context).textTheme.bodyLarge)),
        child,
      ],
    );
  }
}

class _LoadsPreview extends StatelessWidget {
  const _LoadsPreview();

  @override
  Widget build(BuildContext context) {
    final loads = context.watch<LoadsProvider>();
    if (loads.loads.isEmpty) {
      return const DataStateView(state: DataState.loading);
    }
    final preview = loads.loads.take(3).toList();
    return Column(
      children: preview
          .map(
            (l) => Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.surfaceBorder),
              ),
              child: Row(
                children: [
                  Icon(
                    l.isOn ? Icons.power_rounded : Icons.power_off_rounded,
                    size: 16,
                    color: l.isOn ? AppColors.success : AppColors.textDisabled,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(l.name,
                        style: Theme.of(context).textTheme.bodyLarge),
                  ),
                  Text(
                    l.isOn ? Formatters.power(l.powerWatts) : 'Idle',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}

class _RenewablePreview extends StatelessWidget {
  const _RenewablePreview();

  @override
  Widget build(BuildContext context) {
    final renewable = context.watch<RenewableProvider>().data;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.surfaceBorder),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Solar Generation',
                    style: Theme.of(context).textTheme.bodyMedium),
                Text(
                  '${renewable.solarGenerationKw.toStringAsFixed(2)} kW',
                  style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      color: AppColors.solar),
                ),
              ],
            ),
          ),
          Container(width: 1, height: 30, color: AppColors.surfaceBorder),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Battery', style: Theme.of(context).textTheme.bodyMedium),
                Text(
                  '${renewable.batteryPercent}%',
                  style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      color: AppColors.battery),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
