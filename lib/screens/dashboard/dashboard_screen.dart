import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/app_provider.dart';
import '../../widgets/common/app_header.dart';
import '../../widgets/common/status_chip.dart';
import '../../widgets/metric_cards/metric_card.dart';
import '../../widgets/room_cards/room_card.dart';

class DashboardScreen extends StatelessWidget {
  final AppProvider provider;
  const DashboardScreen({super.key, required this.provider});
  @override
  Widget build(BuildContext context) {
    final s = provider.snapshot;
    return RefreshIndicator(
        onRefresh: () async {
          await Future<void>.delayed(const Duration(milliseconds: 400));
        },
        child: ListView(padding: const EdgeInsets.only(bottom: 28), children: [
          const AppHeader(
              title: 'SmartFlux',
              subtitle: 'Energy monitoring & grid optimization'),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Wrap(spacing: 8, runSpacing: 8, children: [
                if (s != null) StatusChip(status: s.status),
                _DemoChip(),
                _ConnectionChip(connected: s?.backendConnected == true)
              ])),
          if (provider.alerts.where((a) => !a.read).isNotEmpty)
            Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: _AlertBanner(
                    alert: provider.alerts.firstWhere((a) => !a.read))),
          Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
              child: Text('System overview',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.w800))),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: LayoutBuilder(builder: (c, bc) {
                final w = bc.maxWidth;
                final n = w > 850
                    ? 4
                    : w > 540
                        ? 2
                        : 2;
                final itemW = (w - (n - 1) * 12) / n;
                return Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      MetricCard(
                          label: 'Voltage',
                          value: s?.voltageV.toStringAsFixed(1) ?? '—',
                          unit: 'V',
                          icon: Icons.bolt,
                          accent: AppColors.voltage),
                      MetricCard(
                          label: 'Current',
                          value: s?.currentA.toStringAsFixed(2) ?? '—',
                          unit: 'A',
                          icon: Icons.electric_meter,
                          accent: AppColors.current),
                      MetricCard(
                          label: 'Power',
                          value: s?.powerW.toStringAsFixed(0) ?? '—',
                          unit: 'W',
                          icon: Icons.flash_on,
                          accent: AppColors.power),
                      MetricCard(
                          label: 'Energy',
                          value: s?.energyKwh.toStringAsFixed(2) ?? '—',
                          unit: 'kWh',
                          icon: Icons.energy_savings_leaf,
                          accent: AppColors.energy)
                    ].map((x) => SizedBox(width: itemW, child: x)).toList());
              })),
          Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 10),
              child: Row(children: [
                Expanded(
                    child: Text('Rooms & zones',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(fontWeight: FontWeight.w800))),
                Text('${provider.rooms.length} configured',
                    style: Theme.of(context).textTheme.bodySmall)
              ])),
          SizedBox(
              height: 220,
              child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  scrollDirection: Axis.horizontal,
                  itemCount: provider.rooms.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (_, i) => RoomCard(room: provider.rooms[i]))),
          Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 10),
              child: Text('Optimization',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.w800))),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _OptimizationCard(provider: provider))
        ]));
  }
}

class _DemoChip extends StatelessWidget {
  @override
  Widget build(BuildContext c) => Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
          color: AppColors.primaryMuted.withValues(alpha: .35),
          borderRadius: BorderRadius.circular(20)),
      child: const Text('Demo / Simulated data',
          style: TextStyle(
              color: AppColors.power,
              fontSize: 12,
              fontWeight: FontWeight.w700)));
}

class _ConnectionChip extends StatelessWidget {
  final bool connected;
  const _ConnectionChip({required this.connected});
  @override
  Widget build(BuildContext c) =>
      Text(connected ? 'Backend connected' : 'Backend unavailable',
          style: TextStyle(
              fontSize: 12,
              color: connected ? AppColors.success : AppColors.disabled,
              fontWeight: FontWeight.w600));
}

class _AlertBanner extends StatelessWidget {
  final dynamic alert;

  const _AlertBanner({required this.alert});

  @override
  Widget build(BuildContext c) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.critical.withValues(alpha: .08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.critical.withValues(alpha: .2),
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: AppColors.critical,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  alert.title,
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 2),
                Text(
                  alert.description,
                  style: Theme.of(c).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _OptimizationCard extends StatelessWidget {
  final AppProvider provider;
  const _OptimizationCard({required this.provider});
  @override
  Widget build(BuildContext c) {
    final e = provider.optimizationEvents.isEmpty
        ? null
        : provider.optimizationEvents.first;
    return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
            color: Theme.of(c).cardColor,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
                color: Theme.of(c).dividerColor.withValues(alpha: .4))),
        child: e == null
            ? const Row(children: [
                Icon(Icons.shield_outlined, color: AppColors.success),
                SizedBox(width: 10),
                Expanded(
                    child: Text(
                        'Rule-based optimization is monitoring demand. No intervention required.'))
              ])
            : Row(children: [
                const Icon(Icons.auto_awesome, color: AppColors.warning),
                const SizedBox(width: 10),
                Expanded(
                    child: Text(e.action,
                        style: const TextStyle(fontWeight: FontWeight.w600)))
              ]));
  }
}
