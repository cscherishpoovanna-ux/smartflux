enum GridStatus { normal, highDemand, overload, offline }

enum AlertSeverity { info, warning, critical }

enum LoadCategory {
  essential,
  nonEssential,
  lighting,
  motor,
  appliance,
  hvac,
  other,
}

enum BatteryStatus { charging, discharging, full, idle }

enum DataState { loading, success, empty, error, offline }

enum TimeRange {
  today,
  week,
  month,
  hour1,
  hour6,
  hour24,
  days7,
  days30,
}

enum SystemStatus { normal, highDemand, overload, offline }

enum LoadState { on, off, unavailable }

enum ThemePreference { system, light, dark }

enum CommandStatus { sent, acknowledged, executed, failed, timeout }

extension AlertSeverityX on AlertSeverity {
  String get label {
    switch (this) {
      case AlertSeverity.info:
        return 'Info';
      case AlertSeverity.warning:
        return 'Warning';
      case AlertSeverity.critical:
        return 'Critical';
    }
  }
}

extension LoadCategoryX on LoadCategory {
  String get label {
    switch (this) {
      case LoadCategory.essential:
        return 'Essential';
      case LoadCategory.nonEssential:
        return 'Non-Essential';
      case LoadCategory.lighting:
        return 'Lighting';
      case LoadCategory.motor:
        return 'Motor';
      case LoadCategory.appliance:
        return 'Appliance';
      case LoadCategory.hvac:
        return 'HVAC';
      case LoadCategory.other:
        return 'Other';
    }
  }
}

extension GridStatusX on GridStatus {
  String get label {
    switch (this) {
      case GridStatus.normal:
        return 'Normal';
      case GridStatus.highDemand:
        return 'High Demand';
      case GridStatus.overload:
        return 'Overload';
      case GridStatus.offline:
        return 'Offline';
    }
  }
}

extension BatteryStatusX on BatteryStatus {
  String get label {
    switch (this) {
      case BatteryStatus.charging:
        return 'Charging';
      case BatteryStatus.discharging:
        return 'Discharging';
      case BatteryStatus.full:
        return 'Full';
      case BatteryStatus.idle:
        return 'Idle';
    }
  }
}

extension TimeRangeX on TimeRange {
  String get label {
    switch (this) {
      case TimeRange.today:
        return 'Today';
      case TimeRange.week:
        return 'Week';
      case TimeRange.month:
        return 'Month';
      case TimeRange.hour1:
        return '1H';
      case TimeRange.hour6:
        return '6H';
      case TimeRange.hour24:
        return '24H';
      case TimeRange.days7:
        return '7D';
      case TimeRange.days30:
        return '30D';
    }
  }
}
