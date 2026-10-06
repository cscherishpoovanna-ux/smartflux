class MqttCommand {
  final String deviceId, commandId, loadId, state;
  const MqttCommand({required this.deviceId, required this.commandId, required this.loadId, required this.state});
}

abstract class MqttService {
  Future<void> publishLoadCommand(MqttCommand command);
}

class UnconfiguredMqttService implements MqttService {
  const UnconfiguredMqttService();
  @override Future<void> publishLoadCommand(MqttCommand command) async => throw StateError('MQTT is not configured in this client.');
}
