import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/enums/app_enums.dart';
import '../../models/energy_models.dart';
import '../../providers/app_provider.dart';
import '../../widgets/common/app_header.dart';

String _roomName(AppProvider provider, String id) {
  for (final room in provider.rooms) {
    if (room.id == id) return room.name;
  }
  return 'Unknown';
}

class LoadsScreen extends StatelessWidget {
  final AppProvider provider;
  const LoadsScreen({super.key, required this.provider});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final onLoads = provider.loads.where((l) => l.state == LoadState.on).length;
    final totalLoads = provider.loads.length;

    return ListView(
      padding: const EdgeInsets.only(bottom: 32),
      children: [
        const AppHeader(
          title: 'Loads',
          subtitle: 'Configured devices and controllable channels',
        ),
        // Summary strip
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 16),
          child: Row(
            children: [
              _SummaryPill(
                label: 'Active',
                value: '$onLoads',
                color: AppColors.success,
              ),
              const SizedBox(width: 10),
              _SummaryPill(
                label: 'Total',
                value: '$totalLoads',
                color: AppColors.info,
              ),
              const SizedBox(width: 10),
              _SummaryPill(
                label: 'Controllable',
                value: '${provider.loads.where((l) => l.controllable).length}',
                color: AppColors.primary,
              ),
            ],
          ),
        ),
        if (provider.error != null)
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
            child: _ErrorBanner(provider.error!),
          ),
        if (provider.loads.isEmpty)
          Padding(
            padding: const EdgeInsets.all(40),
            child: Center(
              child: Text(
                'No loads configured.',
                style: theme.textTheme.bodyMedium,
              ),
            ),
          ),
        ...provider.loads.map(
          (l) => _LoadCard(
            load: l,
            roomName: _roomName(provider, l.roomId),
            provider: provider,
          ),
        ),
      ],
    );
  }
}

class _SummaryPill extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  const _SummaryPill({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .10),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: .18)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w800,
              fontSize: 13,
            ),
          ),
          const SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(
              color: color.withValues(alpha: .75),
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class _LoadCard extends StatefulWidget {
  final LoadModel load;
  final String roomName;
  final AppProvider provider;

  const _LoadCard({
    required this.load,
    required this.roomName,
    required this.provider,
  });

  @override
  State<_LoadCard> createState() => _LoadCardState();
}

class _LoadCardState extends State<_LoadCard> {
  bool _waiting = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l = widget.load;
    final isOn = l.state == LoadState.on;
    final onSurface = theme.colorScheme.onSurface;
    final categoryIcon = l.category == LoadCategory.motor
        ? Icons.settings_rounded
        : Icons.lightbulb_outline_rounded;

    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 12),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isOn && l.connected
              ? AppColors.primary.withValues(alpha: .18)
              : theme.dividerColor.withValues(alpha: .45),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon container
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: isOn && l.connected
                    ? AppColors.primary.withValues(alpha: .12)
                    : AppColors.disabled.withValues(alpha: .10),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                categoryIcon,
                color: isOn && l.connected ? AppColors.primary : AppColors.disabled,
                size: 22,
              ),
            ),
            const SizedBox(width: 14),
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l.name,
                              style: theme.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${widget.roomName} · ${l.essential ? 'Essential' : 'Non-essential'}',
                              style: theme.textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Control
                      if (l.controllable)
                        _waiting
                            ? const Padding(
                                padding: EdgeInsets.all(6),
                                child: SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: AppColors.primary,
                                  ),
                                ),
                              )
                            : Switch(
                                value: isOn,
                                onChanged: l.connected
                                    ? (v) async {
                                        setState(() => _waiting = true);
                                        await widget.provider.controlLoad(l, v);
                                        if (mounted) setState(() => _waiting = false);
                                      }
                                    : null,
                              )
                      else
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Icon(
                            Icons.lock_outline_rounded,
                            size: 18,
                            color: onSurface.withValues(alpha: .35),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  // Metrics row
                  if (l.connected)
                    Row(
                      children: [
                        _MetricBadge(
                          label: 'Power',
                          value: '${l.powerW.toStringAsFixed(0)} W',
                          active: isOn,
                        ),
                        const SizedBox(width: 8),
                        _MetricBadge(
                          label: 'Energy',
                          value: '${l.energyKwh.toStringAsFixed(2)} kWh',
                          active: isOn,
                        ),
                        if (!isOn) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.disabled.withValues(alpha: .10),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              'Off',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: AppColors.disabled,
                              ),
                            ),
                          ),
                        ],
                      ],
                    )
                  else
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.warning.withValues(alpha: .10),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'Connection unavailable',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppColors.warning,
                        ),
                      ),
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

class _MetricBadge extends StatelessWidget {
  final String label;
  final String value;
  final bool active;

  const _MetricBadge({
    required this.label,
    required this.value,
    required this.active,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final onSurface = theme.colorScheme.onSurface;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: onSurface.withValues(alpha: .05),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: onSurface.withValues(alpha: .50),
            ),
          ),
          const SizedBox(width: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              color: active
                  ? onSurface.withValues(alpha: .85)
                  : onSurface.withValues(alpha: .40),
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorBanner extends StatelessWidget {
  final String text;
  const _ErrorBanner(this.text);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.critical.withValues(alpha: .08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.critical.withValues(alpha: .18)),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline_rounded,
              color: AppColors.critical, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                  fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.critical),
            ),
          ),
        ],
      ),
    );
  }
}
