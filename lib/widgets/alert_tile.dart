import 'package:flutter/material.dart';

import '../core/enums.dart';
import '../models/alert.dart';
import '../theme/app_colors.dart';
import '../utils/formatters.dart';

Color severityColor(AlertSeverity s) {
  switch (s) {
    case AlertSeverity.critical:
      return AppColors.critical;
    case AlertSeverity.warning:
      return AppColors.warning;
    case AlertSeverity.info:
      return AppColors.info;
  }
}

IconData severityIcon(AlertSeverity s) {
  switch (s) {
    case AlertSeverity.critical:
      return Icons.error_rounded;
    case AlertSeverity.warning:
      return Icons.warning_rounded;
    case AlertSeverity.info:
      return Icons.info_rounded;
  }
}

/// A single alert row used on the Dashboard's top alert banner and the
/// full Alerts screen history list.
class AlertTile extends StatelessWidget {
  final dynamic alert;
  final bool isRead;
  final VoidCallback? onTap;

  const AlertTile({
    super.key,
    required this.alert,
    this.isRead = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final severity = alert.severity as AlertSeverity;
    final title = alert.title.toString();
    final message = alert is Alert
        ? alert.message.toString()
        : alert.description.toString();
    final timestamp = alert.timestamp as DateTime;
    final color = severityColor(severity);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color:
                isRead ? AppColors.surfaceBorder : color.withValues(alpha: 0.5),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.14),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(severityIcon(severity), color: color, size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                      if (!isRead)
                        Container(
                          width: 7,
                          height: 7,
                          margin: const EdgeInsets.only(left: 6, top: 4),
                          decoration: const BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(message, style: Theme.of(context).textTheme.bodyMedium),
                  const SizedBox(height: 6),
                  Text(
                    Formatters.relative(timestamp),
                    style: const TextStyle(
                        fontSize: 11, color: AppColors.textDisabled),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
