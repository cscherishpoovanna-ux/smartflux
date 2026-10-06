import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/enums.dart';
import '../providers/energy_provider.dart';
import '../providers/loads_provider.dart';
import '../theme/app_colors.dart';
import '../widgets/data_state_view.dart';
import '../widgets/load_tile.dart';
import '../widgets/section_header.dart';

/// Relay-based load control: shows every connected load, lets the user
/// switch them, and explains essential vs non-essential priority
/// (see project brief #11-#13).
class LoadsScreen extends StatelessWidget {
  const LoadsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final loadsProvider = context.watch<LoadsProvider>();
    final energy = context.watch<EnergyProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Load Control')),
      body: loadsProvider.state == DataState.loading
          ? const DataStateView(state: DataState.loading)
          : ListView(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
              children: [
                if (energy.optimizationStatus.isActive)
                  Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.warning.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                          color: AppColors.warning.withValues(alpha: 0.4)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.auto_fix_high_rounded,
                            color: AppColors.warning, size: 20),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Optimization Active',
                                style: TextStyle(
                                  color: AppColors.warning,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Text(
                                '${energy.optimizationStatus.reason} '
                                '${energy.optimizationStatus.affectedLoadName != null ? "Non-essential load: ${energy.optimizationStatus.affectedLoadName} - ${energy.optimizationStatus.action}." : ""}',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.surfaceBorder),
                  ),
                  child: Row(
                    children: [
                      const Expanded(
                        child: _PriorityNote(
                          icon: Icons.shield_rounded,
                          color: AppColors.success,
                          title: 'Essential',
                          subtitle: 'Protected during overload',
                        ),
                      ),
                      Container(
                          width: 1, height: 34, color: AppColors.surfaceBorder),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: _PriorityNote(
                          icon: Icons.priority_high_rounded,
                          color: AppColors.warning,
                          title: 'Non-Essential',
                          subtitle: 'First to be controlled',
                        ),
                      ),
                    ],
                  ),
                ),
                SectionHeader(
                  title: 'Connected Loads',
                  trailing: Text(
                    '${loadsProvider.loads.where((l) => l.isOn).length}/${loadsProvider.loads.length} ON',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                ...loadsProvider.loads.map(
                  (l) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: LoadTile(
                      load: l,
                      isPending: loadsProvider.isPending(l.id),
                      onChanged: (_) => loadsProvider.toggleLoad(l.id),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}

class _PriorityNote extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  const _PriorityNote({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: color, size: 18),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: TextStyle(
                      color: color, fontWeight: FontWeight.w700, fontSize: 13)),
              Text(subtitle, style: Theme.of(context).textTheme.labelSmall),
            ],
          ),
        ),
      ],
    );
  }
}
