// Functional Result Typ (Erfolg oder Fehler) für klare Fehlerbehandlung.
// Vereinheitlicht Rückgaben in Repositories (Success|Error) statt Exceptions.
// Beispiel:
// final result = await repo.load();
// result.when(
//   success: (data) => ...,
//   failure: (f) => log(f.message),
// );
import 'failure.dart';

sealed class Result<T> {
  const Result();
  R when<R>({
    required R Function(T data) success,
    required R Function(Failure f) failure,
  }) {
    final self = this;
    if (self is Success<T>) return success(self.data);
    return failure((self as Error<T>).failure);
  }

  bool get isSuccess => this is Success<T>;
  bool get isFailure => this is Error<T>;
  T? get dataOrNull => this is Success<T> ? (this as Success<T>).data : null;
  Failure? get failureOrNull =>
      this is Error<T> ? (this as Error<T>).failure : null;
}

class Success<T> extends Result<T> {
  final T data;
  const Success(this.data);
  @override
  String toString() => 'Success($data)';
}

class Error<T> extends Result<T> {
  final Failure failure;
  const Error(this.failure);
  @override
  String toString() => 'Error(${failure.message})';
}
