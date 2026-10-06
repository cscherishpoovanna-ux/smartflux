import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../providers/app_provider.dart';

class RenewableScreen extends StatelessWidget {
  final AppProvider provider;

  const RenewableScreen({
    super.key,
    required this.provider,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final onSurface = theme.colorScheme.onSurface;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Renewable Energy'),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        children: [
          // Subsystem Header Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppColors.solar.withValues(alpha: .20),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: AppColors.solar.withValues(alpha: .12),
                        borderRadius: BorderRadius.circular(13),
                      ),
                      child: const Icon(
                        Icons.wb_sunny_outlined,
                        color: AppColors.solar,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Solar & Storage Sub-grid',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Optional clean generation telemetry',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: onSurface.withValues(alpha: .50),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.warning.withValues(alpha: .10),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'Standby',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: AppColors.warning,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Text(
                  'Solar PV generation and battery energy storage (BESS) '
                  'telemetry are automatically integrated when reported '
                  'by the device broker.',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: onSurface.withValues(alpha: .65),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Section Title
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 10),
            child: Text(
              'TELEMETRY CHANNELS',
              style: theme.textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.w800,
                letterSpacing: 0.8,
                color: onSurface.withValues(alpha: .50),
              ),
            ),
          ),

          // Channel Cards
          const _TelemetryPreviewCard(
            icon: Icons.solar_power_outlined,
            accentColor: AppColors.solar,
            title: 'Solar Photovoltaic (PV)',
            value: '0.00 kW',
            status: 'Inverter offline',
            meta: 'String DC Voltage: -- V · Irradiance: -- W/m²',
          ),
          const SizedBox(height: 12),
          const _TelemetryPreviewCard(
            icon: Icons.battery_charging_full_rounded,
            accentColor: AppColors.battery,
            title: 'BESS Battery Storage',
            value: 'Standby',
            status: 'State of Charge: -- %',
            meta: 'Bus Voltage: -- V · Pack Health: 100%',
          ),

          const SizedBox(height: 20),

          // Discovery Card
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(18),
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
                    color: AppColors.info.withValues(alpha: .10),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.sensors_rounded,
                    color: AppColors.info,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Automatic Telemetry Binding',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'When physical solar inverters or BMS controllers publish '
                        'to the configured MQTT topic or Modbus bridge, SmartFlux '
                        'will seamlessly display generation curves and self-consumption ratios.',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: onSurface.withValues(alpha: .55),
                          height: 1.4,
                        ),
                      ),
                    ],
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

class _TelemetryPreviewCard extends StatelessWidget {
  final IconData icon;
  final Color accentColor;
  final String title;
  final String value;
  final String status;
  final String meta;

  const _TelemetryPreviewCard({
    required this.icon,
    required this.accentColor,
    required this.title,
    required this.value,
    required this.status,
    required this.meta,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final onSurface = theme.colorScheme.onSurface;

    return Container(
      padding: const EdgeInsets.all(16),
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
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: .12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  color: accentColor,
                  size: 18,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Text(
                value,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: onSurface.withValues(alpha: .85),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: onSurface.withValues(alpha: .04),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline_rounded,
                  size: 13,
                  color: onSurface.withValues(alpha: .40),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    status,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: onSurface.withValues(alpha: .60),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            meta,
            style: TextStyle(
              fontSize: 10.5,
              fontWeight: FontWeight.w500,
              color: onSurface.withValues(alpha: .40),
            ),
          ),
        ],
      ),
    );
  }
}
