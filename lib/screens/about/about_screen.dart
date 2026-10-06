import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final onSurface = theme.colorScheme.onSurface;

    return Scaffold(
      appBar: AppBar(
        title: const Text('About SmartFlux'),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        children: [
          // Hero Branding Card
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                color: theme.dividerColor.withValues(alpha: .45),
              ),
            ),
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    'assets/branding/smartflux_logo.png',
                    width: 96,
                    height: 96,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'SmartFlux',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'IoT Based Energy Grid Optimization System',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: onSurface.withValues(alpha: .70),
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: .10),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'v1.0.0 · Core Platform',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Overview Card
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: theme.dividerColor.withValues(alpha: .45),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'SYSTEM PURPOSE',
                  style: theme.textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.8,
                    color: onSurface.withValues(alpha: .50),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'SmartFlux is designed to monitor electrical energy conditions in real-time, '
                  'visualize circuit telemetry, surface anomalous consumption spikes, and execute '
                  'transparent, rule-based load optimization across micro-grid and facility circuits.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    height: 1.5,
                    color: onSurface.withValues(alpha: .80),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Core Architectural Pillars
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 10),
            child: Text(
              'ARCHITECTURAL PRINCIPLES',
              style: theme.textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.w800,
                letterSpacing: 0.8,
                color: onSurface.withValues(alpha: .50),
              ),
            ),
          ),

          const _PillarTile(
            icon: Icons.alt_route_rounded,
            title: 'Explainable Rule Engine',
            description:
                'Optimization actions are governed by deterministic rules rather than opaque models, ensuring full operational auditability.',
          ),
          const SizedBox(height: 10),
          const _PillarTile(
            icon: Icons.verified_user_outlined,
            title: 'Hardware Isolation Boundary',
            description:
                'The client maintains zero direct device keys. Actuation passes through edge broker validation with built-in relay hysteresis.',
          ),
          const SizedBox(height: 10),
          const _PillarTile(
            icon: Icons.speed_rounded,
            title: 'Live Telemetry Engine',
            description:
                'High-frequency voltage, current, and active power telemetry with multi-range historical trend analysis and anomaly detection.',
          ),

          const SizedBox(height: 24),

          // Footer
          Center(
            child: Text(
              'SmartFlux Industrial Energy Solutions\nDesigned for Commercial & Micro-Grid Deployment',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall?.copyWith(
                color: onSurface.withValues(alpha: .40),
                height: 1.4,
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _PillarTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _PillarTile({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final onSurface = theme.colorScheme.onSurface;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.dividerColor.withValues(alpha: .40),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: .10),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: AppColors.primary,
              size: 18,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: onSurface.withValues(alpha: .60),
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
