import 'package:flutter/material.dart';
import '../core/enums/app_enums.dart';
import '../core/theme/app_theme.dart';
import '../providers/app_provider.dart';
import '../screens/about/about_screen.dart';
import '../screens/alerts/alerts_screen.dart';
import '../screens/analytics/analytics_screen.dart';
import '../screens/dashboard/dashboard_screen.dart';
import '../screens/loads/loads_screen.dart';
import '../screens/renewable/renewable_screen.dart';
import '../screens/settings/settings_screen.dart';
import '../widgets/common/startup_screen.dart';

class SmartFluxApp extends StatefulWidget {
  final AppProvider provider;
  const SmartFluxApp({super.key, required this.provider});

  @override
  State<SmartFluxApp> createState() => _SmartFluxAppState();
}

class _SmartFluxAppState extends State<SmartFluxApp> {
  int index = 0;
  bool started = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.provider,
      builder: (_, __) {
        final p = widget.provider;
        final themeMode = switch (p.themePreference) {
          ThemePreference.system => ThemeMode.system,
          ThemePreference.dark => ThemeMode.dark,
          ThemePreference.light => ThemeMode.light,
        };

        return MaterialApp(
          title: 'IoT SmartFlux',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light(),
          darkTheme: AppTheme.dark(),
          themeMode: themeMode,
          home: started
              ? _Shell(
                  provider: p,
                  index: index,
                  onIndex: (i) => setState(() => index = i),
                )
              : StartupScreen(onFinished: () => setState(() => started = true)),
          routes: {
            '/renewable': (_) => RenewableScreen(provider: p),
            '/settings': (_) => SettingsScreen(provider: p),
            '/about': (_) => const AboutScreen(),
          },
        );
      },
    );
  }
}

class _Shell extends StatelessWidget {
  final AppProvider provider;
  final int index;
  final ValueChanged<int> onIndex;

  const _Shell({
    required this.provider,
    required this.index,
    required this.onIndex,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screens = [
      DashboardScreen(provider: provider),
      AnalyticsScreen(provider: provider),
      LoadsScreen(provider: provider),
      AlertsScreen(provider: provider),
      SettingsScreen(provider: provider),
    ];

    return Scaffold(
      body: SafeArea(child: screens[index]),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: theme.dividerColor.withValues(alpha: .40),
              width: 1,
            ),
          ),
        ),
        child: NavigationBar(
          selectedIndex: index,
          onDestinationSelected: onIndex,
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.dashboard_outlined),
              selectedIcon: Icon(Icons.dashboard_rounded),
              label: 'Dashboard',
            ),
            NavigationDestination(
              icon: Icon(Icons.analytics_outlined),
              selectedIcon: Icon(Icons.analytics_rounded),
              label: 'Analytics',
            ),
            NavigationDestination(
              icon: Icon(Icons.power_outlined),
              selectedIcon: Icon(Icons.power_rounded),
              label: 'Loads',
            ),
            NavigationDestination(
              icon: Icon(Icons.notifications_none_rounded),
              selectedIcon: Icon(Icons.notifications_rounded),
              label: 'Alerts',
            ),
            NavigationDestination(
              icon: Icon(Icons.more_horiz_rounded),
              selectedIcon: Icon(Icons.more_horiz_rounded),
              label: 'More',
            ),
          ],
        ),
      ),
    );
  }
}
