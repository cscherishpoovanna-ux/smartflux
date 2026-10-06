import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/enums/app_enums.dart';
import '../../models/energy_models.dart';
import '../../providers/app_provider.dart';
import '../../widgets/common/app_header.dart';

class AlertsScreen extends StatelessWidget {
  final AppProvider provider;

  const AlertsScreen({
    super.key,
    required this.provider,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final unread = provider.alerts.where((a) => !a.read).toList();
    final read = provider.alerts.where((a) => a.read).toList();
    final hasUnread = unread.isNotEmpty;

    return ListView(
      padding: const EdgeInsets.only(bottom: 32),
      children: [
        AppHeader(
          title: 'Alerts',
          subtitle: 'System events and abnormal conditions',
          trailing: hasUnread
              ? TextButton.icon(
                  onPressed: () async => provider.markAllRead(),
                  icon: const Icon(Icons.done_all_rounded, size: 16),
                  label: const Text('Mark all read'),
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    ),
                  ),
                )
              : null,
        ),
        if (provider.alerts.isEmpty)
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 40, 20, 40),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: AppColors.success.withValues(alpha: .10),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_circle_outline_rounded,
                    color: AppColors.success,
                    size: 32,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'All clear',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'No alerts. The system is operating normally.',
                  style: theme.textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        if (hasUnread) ...[
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 8),
            child: Text(
              '${unread.length} unread',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w800,
                color: AppColors.primary,
              ),
            ),
          ),
          ...unread.map(
            (a) => _AlertTile(
              alert: a,
              onRead: () => provider.markAlertRead(a.id),
              isRead: false,
            ),
          ),
          if (read.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: Text(
                'Earlier',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: theme.colorScheme.onSurface.withValues(alpha: .5),
                ),
              ),
            ),
        ],
        ...read.map(
          (a) => _AlertTile(
            alert: a,
            onRead: () => provider.markAlertRead(a.id),
            isRead: true,
          ),
        ),
        if (!hasUnread && read.isNotEmpty)
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 8),
            child: Text(
              '${read.length} alerts',
              style: theme.textTheme.bodySmall,
            ),
          ),
      ],
    );
  }
}

class _AlertTile extends StatelessWidget {
  final AlertModel alert;
  final VoidCallback onRead;
  final bool isRead;

  const _AlertTile({
    required this.alert,
    required this.onRead,
    required this.isRead,
  });

  Color _severityColor() => switch (alert.severity) {
        AlertSeverity.critical => AppColors.critical,
        AlertSeverity.warning => AppColors.warning,
        AlertSeverity.info => AppColors.info,
      };

  IconData _severityIcon() => switch (alert.severity) {
        AlertSeverity.critical => Icons.error_rounded,
        AlertSeverity.warning => Icons.warning_rounded,
        AlertSeverity.info => Icons.info_rounded,
      };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = _severityColor();
    final onSurface = theme.colorScheme.onSurface;
    final ts = alert.timestamp;
    final timeStr =
        '${ts.hour.toString().padLeft(2, '0')}:${ts.minute.toString().padLeft(2, '0')}';
    final dateStr = _dateLabel(ts);

    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 10),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isRead
              ? theme.dividerColor.withValues(alpha: .4)
              : color.withValues(alpha: .22),
          width: isRead ? 1 : 1.5,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: color.withValues(alpha: isRead ? .07 : .12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                _severityIcon(),
                color: color.withValues(alpha: isRead ? .6 : 1),
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          alert.title,
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w800,
                            color: isRead
                                ? onSurface.withValues(alpha: .6)
                                : onSurface,
                          ),
                        ),
                      ),
                      if (!isRead) ...[
                        const SizedBox(width: 6),
                        Container(
                          width: 7,
                          height: 7,
                          margin: const EdgeInsets.only(top: 5),
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(
                    alert.description,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: onSurface.withValues(alpha: isRead ? .45 : .70),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time_rounded,
                        size: 11,
                        color: onSurface.withValues(alpha: .35),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '$dateStr $timeStr',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: onSurface.withValues(alpha: .40),
                        ),
                      ),
                      const Spacer(),
                      if (!isRead)
                        GestureDetector(
                          onTap: onRead,
                          child: const Text(
                            'Mark read',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _dateLabel(DateTime ts) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final alertDay = DateTime(ts.year, ts.month, ts.day);
    final diff = today.difference(alertDay).inDays;
    if (diff == 0) return 'Today';
    if (diff == 1) return 'Yesterday';
    return '${ts.day}/${ts.month}';
  }
}
