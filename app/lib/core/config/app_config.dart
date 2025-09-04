/// Environment configuration for the Aukrug app
class AppConfig {
  static const String appName = 'Aukrug';
  static const String version = '1.0.0';

  // API Configuration
  static const String apiBase = String.fromEnvironment(
    'API_BASE',
    defaultValue: 'http://git.mioconnex.local/wp-json/aukrug/v1',
  );

  static const Duration apiTimeout = Duration(seconds: 30);
  static const Duration cacheMaxAge = Duration(hours: 24);

  // Feature Flags
  static const bool enableAnalytics = bool.fromEnvironment(
    'ENABLE_ANALYTICS',
    defaultValue: false,
  );

  static const bool enableLogging = bool.fromEnvironment(
    'ENABLE_LOGGING',
    defaultValue: true,
  );

  // Storage Configuration
  static const String isarDbName = 'aukrug_app';
  static const String prefsPrefix = 'aukrug_';

  // Map Configuration
  static const String osmTileUrl =
      'https://tile.openstreetmap.org/{z}/{x}/{y}.png';
  static const String mapAttribution = '© OpenStreetMap contributors';

  // Default coordinates for Aukrug
  static const double defaultLatitude = 54.1347;
  static const double defaultLongitude = 9.7685;
  static const double defaultZoom = 12.0;
}
