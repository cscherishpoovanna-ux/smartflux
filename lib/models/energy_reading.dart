/// A single point-in-time electrical reading from the grid node.
///
/// In Stage 1 this is produced by [DemoDataEngine]. In the real system this
/// will map 1:1 to a reading published by the ESP32 -> backend -> API layer,
/// e.g. GET /api/readings/latest.
class EnergyReading {
  final DateTime timestamp;
  final double voltage; // Volts
  final double current; // Amperes
  final double power; // Watts (V * I)
  final double energy; // Cumulative kWh for the current session/day

  const EnergyReading({
    required this.timestamp,
    required this.voltage,
    required this.current,
    required this.power,
    required this.energy,
  });

  factory EnergyReading.empty() => EnergyReading(
        timestamp: DateTime.now(),
        voltage: 0,
        current: 0,
        power: 0,
        energy: 0,
      );

  factory EnergyReading.fromJson(Map<String, dynamic> json) => EnergyReading(
        timestamp: DateTime.parse(json['timestamp'] as String),
        voltage: (json['voltage'] as num).toDouble(),
        current: (json['current'] as num).toDouble(),
        power: (json['power'] as num).toDouble(),
        energy: (json['energy'] as num).toDouble(),
      );

  Map<String, dynamic> toJson() => {
        'timestamp': timestamp.toIso8601String(),
        'voltage': voltage,
        'current': current,
        'power': power,
        'energy': energy,
      };

  EnergyReading copyWith({
    DateTime? timestamp,
    double? voltage,
    double? current,
    double? power,
    double? energy,
  }) {
    return EnergyReading(
      timestamp: timestamp ?? this.timestamp,
      voltage: voltage ?? this.voltage,
      current: current ?? this.current,
      power: power ?? this.power,
      energy: energy ?? this.energy,
    );
  }
}
