import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/enums/app_enums.dart';
import '../../providers/app_provider.dart';
import '../../widgets/common/app_header.dart';
import '../about/about_screen.dart';
import '../renewable/renewable_screen.dart';

class SettingsScreen extends StatelessWidget {
  final AppProvider provider;

  const SettingsScreen({
    super.key,
    required this.provider,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final onSurface = theme.colorScheme.onSurface;

    return ListView(
      padding: const EdgeInsets.only(bottom: 36),
      children: [
        const AppHeader(
          title: 'More',
          subtitle: 'Preferences and system configuration',
        ),

        // Appearance section
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 10),
          child: Text(
            'APPEARANCE & THEME',
            style: theme.textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.w800,
              letterSpacing: 0.8,
              color: onSurface.withValues(alpha: .50),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: theme.dividerColor.withValues(alpha: .45),
              ),
            ),
            child: Row(
              children: [
                _ThemeOption(
                  label: 'System',
                  icon: Icons.brightness_auto_outlined,
                  selected: provider.themePreference == ThemePreference.system,
                  onTap: () => provider.setTheme(ThemePreference.system),
                ),
                const SizedBox(width: 8),
                _ThemeOption(
                  label: 'Light',
                  icon: Icons.light_mode_outlined,
                  selected: provider.themePreference == ThemePreference.light,
                  onTap: () => provider.setTheme(ThemePreference.light),
                ),
                const SizedBox(width: 8),
                _ThemeOption(
                  label: 'Dark',
                  icon: Icons.dark_mode_outlined,
                  selected: provider.themePreference == ThemePreference.dark,
                  onTap: () => provider.setTheme(ThemePreference.dark),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 24),

        // Subsystems section
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
          child: Text(
            'SUBSYSTEMS & HARDWARE',
            style: theme.textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.w800,
              letterSpacing: 0.8,
              color: onSurface.withValues(alpha: .50),
            ),
          ),
        ),
        _SettingsTile(
          icon: Icons.solar_power_outlined,
          accentColor: AppColors.solar,
          title: 'Renewable energy',
          subtitle: 'Solar PV telemetry and battery storage state',
          badgeText: 'Standby',
          badgeColor: AppColors.solar,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => RenewableScreen(
                  provider: provider,
                ),
              ),
            );
          },
        ),

        const SizedBox(height: 16),

        // System information section
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
          child: Text(
            'SYSTEM & ARCHITECTURE',
            style: theme.textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.w800,
              letterSpacing: 0.8,
              color: onSurface.withValues(alpha: .50),
            ),
          ),
        ),
        _SettingsTile(
          icon: Icons.security_outlined,
          accentColor: AppColors.success,
          title: 'Security architecture',
          subtitle: 'Zero-trust perimeter & hardware relay protection',
          badgeText: 'Verified',
          badgeColor: AppColors.success,
          onTap: () => _showSecurityDialog(context),
        ),
        _SettingsTile(
          icon: Icons.info_outline_rounded,
          accentColor: AppColors.primary,
          title: 'About SmartFlux',
          subtitle: 'IoT Based Energy Grid Optimization System',
          badgeText: 'v1.0.0',
          badgeColor: AppColors.primary,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const AboutScreen(),
              ),
            );
          },
        ),

        const SizedBox(height: 20),

        // System Status Footer Card
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.cardColor.withValues(alpha: .6),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: theme.dividerColor.withValues(alpha: .35),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: AppColors.success,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Node Gateway Active · Simulated Data Engine',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: onSurface.withValues(alpha: .55),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showSecurityDialog(BuildContext context) {
    final theme = Theme.of(context);
    final onSurface = theme.colorScheme.onSurface;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: theme.cardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: theme.dividerColor.withValues(alpha: .45)),
        ),
        title: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: AppColors.success.withValues(alpha: .12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.shield_outlined,
                color: AppColors.success,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'Security Architecture',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Physical control boundary is strictly isolated behind '
              'the backend and edge device gateway.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: onSurface.withValues(alpha: .85),
              ),
            ),
            const SizedBox(height: 14),
            const _SecurityBullet(
              title: 'No Client Credentials',
              detail: 'Mobile and web UI contains no direct device keys.',
            ),
            const SizedBox(height: 10),
            const _SecurityBullet(
              title: 'Relay Safety Envelope',
              detail: 'Physical toggles require broker-enforced hysteresis.',
            ),
            const SizedBox(height: 10),
            const _SecurityBullet(
              title: 'Demo Environment',
              detail: 'Current runtime operates on synthetic simulation only.',
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text(
              'Acknowledge',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SecurityBullet extends StatelessWidget {
  final String title;
  final String detail;

  const _SecurityBullet({required this.title, required this.detail});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final onSurface = theme.colorScheme.onSurface;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 4),
          child: Icon(
            Icons.check_circle_outline_rounded,
            size: 15,
            color: AppColors.success,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                detail,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: onSurface.withValues(alpha: .55),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ThemeOption extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _ThemeOption({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final onSurface = theme.colorScheme.onSurface;

    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: selected
                ? AppColors.primary.withValues(alpha: .12)
                : onSurface.withValues(alpha: .04),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: selected
                  ? AppColors.primary.withValues(alpha: .35)
                  : Colors.transparent,
              width: 1.5,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 20,
                color: selected
                    ? AppColors.primary
                    : onSurface.withValues(alpha: .60),
              ),
              const SizedBox(height: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
                  color: selected
                      ? AppColors.primary
                      : onSurface.withValues(alpha: .75),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final Color accentColor;
  final String title;
  final String subtitle;
  final String? badgeText;
  final Color? badgeColor;
  final VoidCallback onTap;

  const _SettingsTile({
    required this.icon,
    required this.accentColor,
    required this.title,
    required this.subtitle,
    this.badgeText,
    this.badgeColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final onSurface = theme.colorScheme.onSurface;

    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 10),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: theme.dividerColor.withValues(alpha: .45),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: accentColor.withValues(alpha: .12),
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: Icon(
                    icon,
                    color: accentColor,
                    size: 21,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              title,
                              style: theme.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w800,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (badgeText != null) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: (badgeColor ?? AppColors.primary)
                                    .withValues(alpha: .10),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                badgeText!,
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color: badgeColor ?? AppColors.primary,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 3),
                      Text(
                        subtitle,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: onSurface.withValues(alpha: .50),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 13,
                  color: onSurface.withValues(alpha: .30),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
