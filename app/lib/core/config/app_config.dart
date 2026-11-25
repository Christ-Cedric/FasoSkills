/// Configuration de l'application via --dart-define (Exigence F13)
class AppConfig {
  AppConfig._();

  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://127.0.0.1:5001/api',
  );

  static const String wsUrl = String.fromEnvironment(
    'WS_URL',
    defaultValue: 'ws://127.0.0.1:5001/ws',
  );

  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 15);
}
