class ApiConfig {
  static const String baseUrl = 'https://aukrug.mioconnex.com';
  static const String apiPath = '/wp-json/aukrug/v1';

  // API Endpoints
  static const String discoverEndpoint =
      '$apiPath/places'; // maps to discover functionality
  static const String routesEndpoint =
      '$apiPath/events'; // maps to routes (events as routes)
  static const String infoEndpoint =
      '$apiPath/downloads'; // maps to info/downloads
  static const String noticesEndpoint =
      '$apiPath/events'; // maps to notices (reuse events)
  static const String settingsEndpoint =
      '$apiPath/health'; // maps to health/settings

  // Full URLs
  static String get discoverUrl => '$baseUrl$discoverEndpoint';
  static String get routesUrl => '$baseUrl$routesEndpoint';
  static String get infoUrl => '$baseUrl$infoEndpoint';
  static String get noticesUrl => '$baseUrl$noticesEndpoint';
  static String get settingsUrl => '$baseUrl$settingsEndpoint';

  // Request headers
  static Map<String, String> get headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  // Timeout configuration
  static const Duration requestTimeout = Duration(seconds: 30);
  static const Duration connectTimeout = Duration(seconds: 15);
}
