import 'package:dart_result_type/dart_result_type.dart';
import 'package:test/test.dart';

void main() {
  final ok = Ok<String, int>('');
  final err = Err<String, int>(0);

  test('can infer types', () {
    expect(ok.isOk, isTrue);
    expect(ok.isErr, isFalse);
    expect(err.isErr, isTrue);
    expect(err.isOk, isFalse);
  });

  test('can unwrap', () {
    expect(ok.unwrap() == '', isTrue);
    expect(
      () => ok.unwrapErr(),
      throwsA(isA<UnwrappedNonExistentValueException>()),
    );
    expect(err.unwrapErr() == 0, isTrue);
    expect(
      () => err.unwrap(),
      throwsA(isA<UnwrappedNonExistentValueException>()),
    );

    expect(err.unwrapOr('') == '', isTrue);
    expect(err.unwrapOrElse(() => '') == '', isTrue);

    expect(ok.expect('') == '', isTrue);
    expect(() => err.expect(''), throwsA(isA<ExpectedValueException>()));
  });

  test('can map', () {
    final mappedOk = ok.map((_) => 0);
    expect(mappedOk.isOk, isTrue);
    expect(mappedOk.unwrap(), 0);

    final mappedErr = err.mapErr((_) => '');
    expect(mappedErr.isErr, isTrue);
    expect(mappedErr.unwrapErr() == '', isTrue);
  });

  test('can null-safely unwrap', () {
    expect(ok.unwrapOrNull() == '', isTrue);
    expect(err.unwrapOrNull(), isNull);
    expect(ok.unwrapErrOrNull(), isNull);
    expect(err.unwrapErrOrNull() == 0, isTrue);
  });
}
