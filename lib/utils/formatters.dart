import 'package:intl/intl.dart';

/// Small formatting helpers shared across dashboard/analytics widgets.
class Formatters {
  Formatters._();

  static String voltage(double v) => '${v.toStringAsFixed(1)} V';
  static String current(double a) => '${a.toStringAsFixed(2)} A';
  static String power(double w) => '${w.toStringAsFixed(0)} W';
  static String energy(double kwh) => '${kwh.toStringAsFixed(2)} kWh';

  static String time(DateTime dt) => DateFormat('h:mm a').format(dt);
  static String dayTime(DateTime dt) => DateFormat('MMM d, h:mm a').format(dt);

  static String relative(DateTime? dt) {
    if (dt == null) return '--';
    final diff = DateTime.now().difference(dt);
    if (diff.inSeconds < 5) return 'Just now';
    if (diff.inSeconds < 60) return '${diff.inSeconds}s ago';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    return time(dt);
  }
}
