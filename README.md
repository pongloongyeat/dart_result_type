A type-safe way of representing success or error values, mimicking Rust's [Result](https://doc.rust-lang.org/std/result/enum.Result.html) type.

## Panics

In Rust, calling `.unwrap()` on an `Err` type panics. In this package, the equivalent would be throwing an `Exception`. As with Rust, the recommended way would be to pattern match (thank you Dart 3) the equivalent variants to get the underlying data, or to do an `.isOk` or `.isErr` check before calling `.unwrap()`.

```dart
Future<void> doSomething() async {
    final result: Result<Json, ApiError> = await apiCall() ;
    switch (result) {
        Ok(value: final value):
            showSuccessDialog(value.content);
        Err(value: final value):
            showFailureDialog(value);
    };
}
```

## Option

Since Dart has sound null-safety, there is no need to represent an optional value with `Option<T>`. Instead, there is a `.unwrapOrNull()` and `unwrapErrOrNull` method to return the `Result`'s underyling value, or null, if there is no value.

```dart
Future<void> doSomething() async {
    final result: Result<Json, ApiError> = await apiCall();
    final content = result.unwrapOrNull()?.content;
    if (content != null) showSuccessDialog(content);
}
```

## Example

```dart
import 'dart:math';

import 'package:dart_result_type/dart_result_type.dart';

enum GameState { win, lose }
enum GameError { unlucky }

Result<int, GameError> getResult() {
    final rand = Random();
    final randValue = rand.nextInt(10);

    // Represent a success or error with Ok or Err
    return switch (randValue) {
        > 5 => Ok(randValue),
        _ => Err(GameError.unlucky)
    };
}

Iterable<Result<GameState, GameError>> playGame(int iterations) {
    return Iterable.generate(iterations, (_) {
        return getResult()
            // map our success value into an actual GameState
            .map((value) => value > 8 ? GameState.win : GameState.lose);
    });
}

void main() {
    for (final game in playGame(10)) {
        print(game);
    }
}
```
