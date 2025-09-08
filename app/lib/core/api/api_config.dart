/// API configuration constants
class ApiConfig {
  static const String baseUrl =
      'https://your-wordpress-site.com/wp-json/aukrug/v1';
  static const String marketplaceEndpoint = '/marketplace';
  static const String categoriesEndpoint = '/marketplace/categories';
  static const String verificationEndpoint = '/marketplace/verification';
  static const String rateLimitEndpoint = '/marketplace/rate-limit';

  /// Request timeouts
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration sendTimeout = Duration(seconds: 30);

  /// Rate limits
  static const int maxCreatePerDay = 5;
  static const int maxEditPerDay = 20;

  /// Image constraints
  static const int maxImageSize = 2048; // 2MB
  static const List<String> allowedImageTypes = ['jpg', 'jpeg', 'png', 'webp'];
}
