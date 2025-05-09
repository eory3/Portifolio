sealed class Result<T> {
  const Result();

  const factory Result.ok(T value) = Ok._;

  const factory Result.error(String message) = Error._;
}

final class Ok<T> extends Result<T> {
  const Ok._(this.value);

  final T value;

  @override
  String toString() => '$value';
}

final class Error<T> extends Result<T> {
  const Error._(this.error);

  final String error;

  @override
  String toString() => error;
}
