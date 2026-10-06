import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import 'about_screen.dart';
import 'renewable_energy_screen.dart';
import 'settings_screen.dart';
import 'system_status_screen.dart';

/// Secondary navigation hub (see project brief #19).
class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final items = [
      _MoreItem('System Status', Icons.dns_rounded,
          (c) => const SystemStatusScreen()),
      _MoreItem('Renewable Energy', Icons.eco_rounded,
          (c) => const RenewableEnergyScreen()),
      _MoreItem(
          'Settings', Icons.settings_rounded, (c) => const SettingsScreen()),
      _MoreItem(
          'About', Icons.info_outline_rounded, (c) => const AboutScreen()),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('More')),
      body: ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (context, i) {
          final item = items[i];
          return Material(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(14),
            child: InkWell(
              borderRadius: BorderRadius.circular(14),
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: item.builder),
              ),
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.surfaceBorder),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child:
                          Icon(item.icon, color: AppColors.primary, size: 18),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Text(item.label,
                          style: Theme.of(context).textTheme.titleMedium),
                    ),
                    const Icon(Icons.chevron_right_rounded,
                        color: AppColors.textSecondary),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _MoreItem {
  final String label;
  final IconData icon;
  final WidgetBuilder builder;
  _MoreItem(this.label, this.icon, this.builder);
}
