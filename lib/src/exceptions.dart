part of 'result.dart';

sealed class _ResultException implements Exception {
  const _ResultException(this.message);

  final String message;

  @override
  String toString() {
    return '$runtimeType: $message';
  }
}

/// An exception to represent unwrapping a non-existent value, be it an [Ok] or
/// [Err] variant.
final class UnwrappedNonExistentValueException<T, E> extends _ResultException {
  const UnwrappedNonExistentValueException._unwrap(Result<T, E> result)
      : super('Tried to unwrap an Ok($T) on $result');

  const UnwrappedNonExistentValueException._unwrapErr(Result<T, E> result)
      : super('Tried to unwrap an Err($E) on $result');
}

/// An exception to represent unwrapping a non-existent value when calling
/// [Result.expect] along with some helpful message as context.
final class ExpectedValueException<T, E> extends _ResultException {
  ExpectedValueException._(
    Result<T, E> result, {
    required String context,
  }) : super(['Expected an Ok($T) but instead got $result', '', context]
            .join('\n'));
}
