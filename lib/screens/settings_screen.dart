import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/constants.dart';
import '../providers/settings_provider.dart';
import '../theme/app_colors.dart';
import 'about_screen.dart';
import 'system_status_screen.dart';

/// Simple, non-account settings (see project brief #18). No profile,
/// login or authentication options are present by design.
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        children: [
          _SettingsGroup(
            title: 'Monitoring',
            children: [
              ListTile(
                leading: const Icon(Icons.info_outline_rounded),
                title: const Text('System Information'),
                subtitle: const Text('View hardware & connectivity status'),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const SystemStatusScreen()),
                ),
              ),
              const Divider(height: 1, indent: 16, endIndent: 16),
              ListTile(
                leading: const Icon(Icons.timer_outlined),
                title: const Text('Monitoring Interval'),
                subtitle: Text(
                    'Every ${settings.refreshIntervalSeconds}s (demo mode)'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _SettingsGroup(
            title: 'Alerts',
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                child: Row(
                  children: [
                    const Icon(Icons.notifications_active_outlined),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Alert Threshold',
                              style: TextStyle(fontWeight: FontWeight.w600)),
                          Text(
                            'Trigger overload alert above ${settings.alertPowerThresholdW.toStringAsFixed(0)} W',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Slider(
                value: settings.alertPowerThresholdW,
                min: AppConstants.minPower,
                max: AppConstants.maxPower,
                divisions: 30,
                activeColor: AppColors.primary,
                label: settings.alertPowerThresholdW.toStringAsFixed(0),
                onChanged: settings.setAlertThreshold,
              ),
            ],
          ),
          const SizedBox(height: 16),
          _SettingsGroup(
            title: 'Features',
            children: [
              SwitchListTile(
                secondary: const Icon(Icons.eco_rounded),
                title: const Text('Renewable Energy Section'),
                subtitle: const Text('Show optional solar & battery data'),
                value: settings.renewableSectionEnabled,
                onChanged: settings.setRenewableEnabled,
              ),
            ],
          ),
          const SizedBox(height: 16),
          _SettingsGroup(
            title: 'Appearance',
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                child: SegmentedButton<ThemeMode>(
                  segments: const [
                    ButtonSegment<ThemeMode>(
                      value: ThemeMode.system,
                      label: Text('System'),
                    ),
                    ButtonSegment<ThemeMode>(
                      value: ThemeMode.light,
                      label: Text('Light'),
                    ),
                    ButtonSegment<ThemeMode>(
                      value: ThemeMode.dark,
                      label: Text('Dark'),
                    ),
                  ],
                  selected: {settings.themeMode},
                  onSelectionChanged: (selection) {
                    if (selection.isNotEmpty) {
                      settings.setThemeMode(selection.first);
                    }
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _SettingsGroup(
            title: 'About',
            children: [
              ListTile(
                leading: const Icon(Icons.description_outlined),
                title: const Text('About Project'),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const AboutScreen()),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SettingsGroup extends StatelessWidget {
  final String title;
  final List<Widget> children;
  const _SettingsGroup({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(title.toUpperCase(),
              style: Theme.of(context).textTheme.labelSmall),
        ),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.surfaceBorder),
          ),
          child: Column(children: children),
        ),
      ],
    );
  }
}
