import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/enums.dart';
import '../providers/renewable_provider.dart';
import '../theme/app_colors.dart';

/// OPTIONAL solar + battery storage screen. Kept fully separate from the
/// core electrical dashboard (see project brief #17).
class RenewableEnergyScreen extends StatelessWidget {
  const RenewableEnergyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final data = context.watch<RenewableProvider>().data;

    return Scaffold(
      appBar: AppBar(title: const Text('Renewable Energy')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: AppColors.info.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.info.withValues(alpha: 0.3)),
            ),
            child: const Row(
              children: [
                Icon(Icons.info_outline_rounded,
                    color: AppColors.info, size: 18),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Optional feature. Values shown depend on solar panel and '
                    'battery hardware being present in the deployed system.',
                    style: TextStyle(
                        color: AppColors.textSecondary, fontSize: 12.5),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.solar.withValues(alpha: 0.18),
                  AppColors.surface
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: AppColors.surfaceBorder),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.wb_sunny_rounded, color: AppColors.solar),
                    SizedBox(width: 8),
                    Text('Solar Generation',
                        style: TextStyle(
                            color: AppColors.textSecondary, fontSize: 13)),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  '${data.solarGenerationKw.toStringAsFixed(2)} kW',
                  style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: AppColors.surfaceBorder),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.battery_charging_full_rounded,
                        color: AppColors.battery),
                    const SizedBox(width: 8),
                    const Text('Battery',
                        style: TextStyle(
                            color: AppColors.textSecondary, fontSize: 13)),
                    const Spacer(),
                    Text(
                      data.batteryStatus.label,
                      style: const TextStyle(
                          color: AppColors.battery,
                          fontWeight: FontWeight.w700,
                          fontSize: 12),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: data.batteryPercent / 100,
                    minHeight: 12,
                    backgroundColor: AppColors.surfaceElevated,
                    valueColor: const AlwaysStoppedAnimation(AppColors.battery),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${data.batteryPercent}%',
                  style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
