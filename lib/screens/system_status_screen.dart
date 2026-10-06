import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/energy_provider.dart';
import '../theme/app_colors.dart';
import '../widgets/status_pill.dart';

/// Read-only monitoring screen for hardware/communication connectivity
/// (see project brief #16). Not a configuration screen.
class SystemStatusScreen extends StatelessWidget {
  const SystemStatusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final status = context.watch<EnergyProvider>().systemStatus;

    final items = <_StatusItem>[
      _StatusItem('ESP32', status.esp32Connected, Icons.memory_rounded),
      _StatusItem(
          'Voltage Sensor', status.voltageSensorActive, Icons.bolt_rounded),
      _StatusItem('Current Sensor', status.currentSensorActive,
          Icons.electric_meter_rounded),
      _StatusItem('Relay', status.relayConnected, Icons.settings_input_component_rounded),
      _StatusItem('Communication', status.communicationConnected,
          Icons.wifi_rounded),
      _StatusItem('Backend', status.backendOnline, Icons.dns_rounded),
      _StatusItem('Database', status.databaseConnected, Icons.storage_rounded),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('System Status')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.surfaceBorder),
            ),
            child: Column(
              children: List.generate(items.length, (i) {
                final item = items[i];
                return Column(
                  children: [
                    ListTile(
                      leading: Icon(item.icon, color: AppColors.textSecondary),
                      title: Text(item.label),
                      trailing: StatusPill(
                        label: item.connected ? 'Connected' : 'Offline',
                        color: item.connected ? AppColors.success : AppColors.critical,
                      ),
                    ),
                    if (i != items.length - 1)
                      const Divider(height: 1, indent: 16, endIndent: 16),
                  ],
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusItem {
  final String label;
  final bool connected;
  final IconData icon;
  _StatusItem(this.label, this.connected, this.icon);
}
