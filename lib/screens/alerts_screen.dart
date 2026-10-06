import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/enums.dart';
import '../models/alert.dart';
import '../providers/alerts_provider.dart';
import '../theme/app_colors.dart';
import '../utils/formatters.dart';
import '../widgets/alert_tile.dart';
import '../widgets/data_state_view.dart';

/// Full alert history with severity + timestamps, and a detail view
/// (see project brief #15).
class AlertsScreen extends StatelessWidget {
  const AlertsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final alerts = context.watch<AlertsProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Alerts'),
        actions: [
          if (alerts.alerts.isNotEmpty)
            TextButton(
              onPressed: alerts.markAllRead,
              child: const Text('Mark all read'),
            ),
        ],
      ),
      body: alerts.state != DataState.success
          ? DataStateView(state: alerts.state)
          : ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
              itemCount: alerts.alerts.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, i) {
                final dynamic alert = alerts.alerts[i];
                return AlertTile(
                  alert: alert,
                  isRead: alerts.isRead(alert.id),
                  onTap: () {
                    alerts.markRead(alert.id);
                    _showDetail(context, alert);
                  },
                );
              },
            ),
    );
  }

  void _showDetail(BuildContext context, dynamic alert) {
    final severity = alert.severity as AlertSeverity;
    final title = alert.title.toString();
    final message = alert is Alert
        ? alert.message.toString()
        : alert.description.toString();
    final timestamp = alert.timestamp as DateTime;

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surfaceElevated,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        final color = severityColor(severity);
        return Padding(
          padding: const EdgeInsets.all(22),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(severityIcon(severity), color: color),
                  const SizedBox(width: 10),
                  Text(severity.label.toUpperCase(),
                      style: TextStyle(
                          color: color,
                          fontWeight: FontWeight.w800,
                          fontSize: 12)),
                ],
              ),
              const SizedBox(height: 10),
              Text(title, style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 8),
              Text(message, style: Theme.of(context).textTheme.bodyLarge),
              const SizedBox(height: 12),
              Text(
                Formatters.dayTime(timestamp),
                style: const TextStyle(
                    color: AppColors.textDisabled, fontSize: 12),
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }
}
