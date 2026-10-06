import '../core/enums.dart';

/// A system-generated alert (overload, abnormal voltage, etc).
class Alert {
  final String id;
  final String title;
  final String message;
  final AlertSeverity severity;
  final DateTime timestamp;
  final bool isRead;

  const Alert({
    required this.id,
    required this.title,
    required this.message,
    required this.severity,
    required this.timestamp,
    this.isRead = false,
  });

  factory Alert.fromJson(Map<String, dynamic> json) => Alert(
        id: json['id'] as String,
        title: json['title'] as String,
        message: json['message'] as String,
        severity: AlertSeverity.values.firstWhere(
          (e) => e.name == json['severity'],
          orElse: () => AlertSeverity.info,
        ),
        timestamp: DateTime.parse(json['timestamp'] as String),
        isRead: json['isRead'] as bool? ?? false,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'message': message,
        'severity': severity.name,
        'timestamp': timestamp.toIso8601String(),
        'isRead': isRead,
      };

  Alert copyWith({bool? isRead}) => Alert(
        id: id,
        title: title,
        message: message,
        severity: severity,
        timestamp: timestamp,
        isRead: isRead ?? this.isRead,
      );
}
