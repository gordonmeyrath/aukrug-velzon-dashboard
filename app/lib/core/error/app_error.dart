/// Custom error class for the Aukrug app
class AppError implements Exception {
  final String message;
  final String? code;
  final dynamic originalError;

  const AppError({
    required this.message,
    this.code,
    this.originalError,
  });

  /// Network-related error
  factory AppError.network(String message) {
    return AppError(
      message: message,
      code: 'NETWORK_ERROR',
    );
  }

  /// Local storage error
  factory AppError.storage(String message) {
    return AppError(
      message: message,
      code: 'STORAGE_ERROR',
    );
  }

  /// Validation error
  factory AppError.validation(String message) {
    return AppError(
      message: message,
      code: 'VALIDATION_ERROR',
    );
  }

  /// Permission error
  factory AppError.permission(String message) {
    return AppError(
      message: message,
      code: 'PERMISSION_ERROR',
    );
  }

  /// Unknown error
  factory AppError.unknown(String message) {
    return AppError(
      message: message,
      code: 'UNKNOWN_ERROR',
    );
  }

  @override
  String toString() {
    return 'AppError: $message${code != null ? ' (Code: $code)' : ''}';
  }
}
