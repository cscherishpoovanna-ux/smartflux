import 'package:flutter/material.dart';

import '../core/constants.dart';
import '../theme/app_colors.dart';

/// Static project-identity screen (see project brief #33). No account or
/// author authentication information -- purely descriptive.
class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('About Project')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
        children: [
          Center(
            child: Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.14),
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Icon(Icons.bolt_rounded,
                  color: AppColors.primary, size: 34),
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: Text(AppConstants.appName,
                style: Theme.of(context).textTheme.displaySmall),
          ),
          const SizedBox(height: 4),
          Center(
            child: Text(
              AppConstants.appSubtitle,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.surfaceBorder),
            ),
            child: const Text(
              'IoT SmartFlux simulates a mini smart energy grid. IoT sensor '
              'nodes monitor voltage, current and power, and a centralized '
              'optimization engine applies rule-based automation to balance '
              'load and protect the grid during high-demand or overload '
              'conditions. This mobile application is the monitoring and '
              'control interface for the system, and is currently running '
              'in demo mode with simulated live data.',
              style: TextStyle(
                  color: AppColors.textSecondary, height: 1.5, fontSize: 13.5),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.surfaceBorder),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Project Modules',
                    style: TextStyle(fontWeight: FontWeight.w700)),
                SizedBox(height: 10),
                _ModuleRow(
                    'IoT & Hardware', 'ESP32, voltage/current sensors, relay'),
                _ModuleRow(
                    'Communication & Database', 'MQTT/HTTP, Firebase/MongoDB'),
                _ModuleRow(
                    'Backend & Optimization', 'Rule-based load balancing'),
                _ModuleRow(
                    'Mobile Application', 'This app -- monitoring & control'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ModuleRow extends StatelessWidget {
  final String title;
  final String subtitle;
  const _ModuleRow(this.title, this.subtitle);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 5),
            child: Icon(Icons.circle, size: 6, color: AppColors.primary),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 13.5)),
                Text(subtitle, style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
