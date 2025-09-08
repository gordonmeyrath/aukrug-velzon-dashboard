/// Domänen-Neutrale Fehlerrepräsentation (leicht serialisierbar, testbar)
class Failure {
  final String message;
  final String? code;
  final StackTrace? stackTrace;
  final Object? cause;
  const Failure(this.message, {this.code, this.stackTrace, this.cause});

  Failure copyWith({
    String? message,
    String? code,
    StackTrace? stackTrace,
    Object? cause,
  }) => Failure(
    message ?? this.message,
    code: code ?? this.code,
    stackTrace: stackTrace ?? this.stackTrace,
    cause: cause ?? this.cause,
  );

  @override
  String toString() => 'Failure(code=$code, message=$message)';
}

Failure networkFailure(String msg, {Object? cause, StackTrace? st}) =>
    Failure(msg, code: 'NETWORK', cause: cause, stackTrace: st);
Failure storageFailure(String msg, {Object? cause, StackTrace? st}) =>
    Failure(msg, code: 'STORAGE', cause: cause, stackTrace: st);
Failure validationFailure(String msg) => Failure(msg, code: 'VALIDATION');
Failure permissionFailure(String msg) => Failure(msg, code: 'PERMISSION');
Failure unknownFailure(String msg, {Object? cause, StackTrace? st}) =>
    Failure(msg, code: 'UNKNOWN', cause: cause, stackTrace: st);
