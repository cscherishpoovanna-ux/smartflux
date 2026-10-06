import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../models/energy_models.dart';

class RoomCard extends StatelessWidget {
  final RoomModel room;
  const RoomCard({super.key, required this.room});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final onSurface = theme.colorScheme.onSurface;

    if (!room.connected) {
      return _cardShell(
        context,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: AppColors.disabled.withValues(alpha: .10),
                    borderRadius: BorderRadius.circular(11),
                  ),
                  child: const Icon(
                    Icons.link_off_rounded,
                    color: AppColors.disabled,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    room.name,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: onSurface.withValues(alpha: .5),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.disabled.withValues(alpha: .10),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text(
                    'Not connected',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: AppColors.disabled,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Available for future configuration',
              style: theme.textTheme.bodySmall?.copyWith(
                color: onSurface.withValues(alpha: .40),
              ),
            ),
          ],
        ),
      );
    }

    final isActive = room.powerW > 500;
    final statusColor = isActive ? AppColors.warning : AppColors.success;
    final statusLabel = isActive ? 'Active' : 'Normal';

    return _cardShell(
      context,
      accentColor: isActive ? AppColors.warning : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: .12),
                  borderRadius: BorderRadius.circular(11),
                ),
                child: Icon(
                  Icons.home_outlined,
                  color: statusColor,
                  size: 18,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  room.name,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: .10),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  statusLabel,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: statusColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Metrics
          Row(
            children: [
              _Metric(label: 'Voltage', value: '${room.voltageV.toStringAsFixed(0)} V'),
              const _Divider(),
              _Metric(label: 'Current', value: '${room.currentA.toStringAsFixed(2)} A'),
              const _Divider(),
              _Metric(label: 'Power', value: '${room.powerW.toStringAsFixed(0)} W'),
            ],
          ),
          const SizedBox(height: 12),
          // Footer
          Text(
            '${room.loadIds.length} configured load${room.loadIds.length == 1 ? '' : 's'}',
            style: theme.textTheme.bodySmall?.copyWith(
              color: onSurface.withValues(alpha: .45),
            ),
          ),
        ],
      ),
    );
  }

  Widget _cardShell(
    BuildContext context, {
    required Widget child,
    Color? accentColor,
  }) {
    final theme = Theme.of(context);
    return Container(
      width: 240,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: accentColor != null
              ? accentColor.withValues(alpha: .20)
              : theme.dividerColor.withValues(alpha: .45),
        ),
      ),
      child: child,
    );
  }
}

class _Metric extends StatelessWidget {
  final String label;
  final String value;
  const _Metric({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final onSurface = theme.colorScheme.onSurface;
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: onSurface.withValues(alpha: .45),
            ),
          ),
          const SizedBox(height: 3),
          Text(
            value,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w800,
              color: onSurface.withValues(alpha: .85),
            ),
          ),
        ],
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 28,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      color: Theme.of(context).dividerColor.withValues(alpha: .35),
    );
  }
}
