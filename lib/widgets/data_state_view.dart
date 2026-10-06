import 'package:flutter/material.dart';

import '../core/enums.dart';
import '../theme/app_colors.dart';

/// Standard Loading / Empty / Error / Offline placeholder used wherever a
/// screen depends on data that may not be ready yet (see project brief #27).
/// Success is intentionally NOT handled here -- the caller renders its own
/// content in that case.
class DataStateView extends StatelessWidget {
  final DataState state;
  final String? lastUpdatedLabel;
  final VoidCallback? onRetry;

  const DataStateView({
    super.key,
    required this.state,
    this.lastUpdatedLabel,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    switch (state) {
      case DataState.loading:
        return const Padding(
          padding: EdgeInsets.symmetric(vertical: 48),
          child: Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          ),
        );
      case DataState.empty:
        return const _Message(
          icon: Icons.inbox_outlined,
          title: 'Nothing to show yet',
          subtitle: 'Data will appear here once available.',
        );
      case DataState.error:
        return _Message(
          icon: Icons.error_outline_rounded,
          title: 'Something went wrong',
          subtitle: 'Unable to load data right now.',
          onRetry: onRetry,
        );
      case DataState.offline:
        return _Message(
          icon: Icons.cloud_off_rounded,
          title: 'Connection Lost',
          subtitle: lastUpdatedLabel != null
              ? 'Last updated: $lastUpdatedLabel'
              : 'Waiting to reconnect...',
          onRetry: onRetry,
        );
      case DataState.success:
        return const SizedBox.shrink();
    }
  }
}

class _Message extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onRetry;

  const _Message({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
      child: Column(
        children: [
          Icon(icon, size: 36, color: AppColors.textDisabled),
          const SizedBox(height: 12),
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 4),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          if (onRetry != null) ...[
            const SizedBox(height: 14),
            OutlinedButton(onPressed: onRetry, child: const Text('Retry')),
          ],
        ],
      ),
    );
  }
}
