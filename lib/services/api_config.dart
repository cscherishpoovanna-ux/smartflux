/// Placeholder REST configuration for future backend integration.
///
/// These endpoints are NOT assumed to exist yet -- they mirror the
/// suggested API surface from the project synopsis / backend teammate's
/// diary (readings, alerts, loads, system status, optimization status).
/// Update [baseUrl] and paths here once the real backend is deployed;
/// nothing else in the app needs to change because all access goes
/// through [ApiEnergyRepository].
class ApiConfig {
  ApiConfig._();

  static const String baseUrl = 'https://REPLACE_WITH_BACKEND_HOST';

  static const String latestReading = '/api/readings/latest';
  static const String readingHistory = '/api/readings/history';
  static const String alerts = '/api/alerts';
  static const String loads = '/api/loads';
  static String loadControl(String id) => '/api/loads/$id/control';
  static const String systemStatus = '/api/system/status';
  static const String optimizationStatus = '/api/optimization/status';
}
