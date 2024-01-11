part 'exceptions.dart';

/// Signature for transforming a value [A] into a value [B].
typedef Transform<A, B> = B Function(A element);

/// {@template Result}
/// A type-safe class for propagating results and errors, in similar fashion to
/// Rust's [Result](https://doc.rust-lang.org/std/result/) type.
///
/// See:
/// - `Ok` to represent a success
/// - `Err` to represent an error
/// {@endtemplate}
sealed class Result<T, E> {
  /// {@macro Result}
  const Result();

  /// Returns true if the result is an [Ok].
  bool get isOk => this is Ok;

  /// Returns true if the result is an [Err].
  bool get isErr => this is Err;

  /// Extracts a result's value if the result is an [Ok] and throws a
  /// [UnwrappedNonExistentValueException] if the result is an [Err].
  T unwrap() {
    return switch (this) {
      Ok(value: final value) => value,
      Err() => throw UnwrappedNonExistentValueException._unwrap(this),
    };
  }

  /// Extracts a result's value if the result is an [Err] and throws
  /// a [UnwrappedNonExistentValueException] if the result is an [Ok].
  E unwrapErr() {
    return switch (this) {
      Ok() => throw UnwrappedNonExistentValueException._unwrapErr(this),
      Err(value: final value) => value,
    };
  }

  /// Extracts a result's value if the result is an [Ok] and fallsback to
  /// [other] if the result is an [Err].
  T unwrapOr(T other) {
    return switch (this) {
      Ok(value: final value) => value,
      Err() => other,
    };
  }

  /// Extracts a result's value if the result is an [Ok] and throws a
  /// [ExpectedValueException] with some helpful [message] as its context if the
  /// result is an [Err].
  T expect(String message) {
    return switch (this) {
      Ok(value: final value) => value,
      Err() => throw ExpectedValueException._(this, context: message),
    };
  }

  /// Maps an [Ok] variant's data [T] to another type [S]. Does nothing if it is
  /// an [Err].
  Result<S, E> map<S>(Transform<T, S> transform) {
    return switch (this) {
      Ok(value: final value) => Ok<S, E>(transform(value)),
      Err(value: final value) => Err<S, E>(value),
    };
  }

  /// Maps an [Err] variant's error [E] to another type [S]. Does nothing if it
  /// is an [Ok].
  Result<T, S> mapErr<S>(Transform<E, S> transform) {
    return switch (this) {
      Ok(value: final value) => Ok<T, S>(value),
      Err(value: final value) => Err<T, S>(transform(value)),
    };
  }

  /// Extracts a result's value or returns null if it is an [Err].
  T? unwrapOrNull() {
    return switch (this) { Ok(value: final value) => value, Err() => null };
  }

  @override
  String toString() {
    return switch (this) {
      Ok(value: final value) => 'Ok($value)',
      Err(value: final value) => 'Err($value)',
    };
  }
}

/// {@template Ok}
/// The `Ok` type is used to contain the success value of an operation.
///
/// See:
/// - [Err] to represent an error
/// {@endtemplate}
final class Ok<T, E> extends Result<T, E> {
  /// {@macro Ok}
  const Ok(this.value);

  /// The underlying success value.
  final T value;
}

/// {@template Err}
/// The `Err` type is used to contain the error value of an operation.
///
/// See:
/// - [Ok] to represent a success
/// {@endtemplate}
final class Err<T, E> extends Result<T, E> {
  /// {@macro Err}
  const Err(this.value);

  /// The underlying error value.
  final E value;
}
