import 'package:flutter/material.dart';

import '../core/enums.dart';
import '../theme/app_colors.dart';
import '../utils/formatters.dart';

/// A single connected-load row on the Load Control screen: name, category
/// badge, live power draw, and an on/off switch wired to the provider.
class LoadTile extends StatelessWidget {
  final dynamic load;
  final bool isPending;
  final ValueChanged<bool>? onChanged;

  const LoadTile({
    super.key,
    required this.load,
    this.isPending = false,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final category = load.category as LoadCategory;
    final title = load.name.toString();
    final isOn = load.isOn as bool;
    final powerWatts = load.powerWatts as double;
    final essential = category == LoadCategory.essential;
    final badgeColor = essential ? AppColors.success : AppColors.warning;

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
                Text(title, style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: badgeColor.withValues(alpha: 0.14),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        category.label,
                        style: TextStyle(
                          color: badgeColor,
                          fontSize: 10.5,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      isOn ? Formatters.power(powerWatts) : 'Idle',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (isPending)
            const SizedBox(
              width: 22,
              height: 22,
              child: CircularProgressIndicator(strokeWidth: 2.4),
            )
          else
            Switch(value: isOn, onChanged: onChanged),
        ],
      ),
    );
  }
}
