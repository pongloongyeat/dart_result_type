import 'dart:math';

import 'package:dart_result_type/dart_result_type.dart';

enum GameState {
  win,
  lose;

  @override
  String toString() {
    return switch (this) { win => 'You win', lose => 'You lose' };
  }
}

enum GameError { unlucky, veryUnlucky }

enum InsultingError { noob, youAbsolutelySuck }

Result<int, GameError> getResult() {
  final rand = Random();
  final randValue = rand.nextInt(10);

  return switch (randValue) {
    > 5 => Ok(randValue),
    _ => Err(rand.nextBool() ? GameError.unlucky : GameError.veryUnlucky)
  };
}

Iterable<Result<GameState, InsultingError>> playGame(int iterations) {
  return Iterable.generate(
    iterations,
    (_) => getResult()
        .map((element) => element > 8 ? GameState.win : GameState.lose)
        .mapErr((element) => switch (element) {
              GameError.unlucky => InsultingError.noob,
              GameError.veryUnlucky => InsultingError.youAbsolutelySuck
            }),
  );
}

void main() {
  for (final game in playGame(10)) {
    print(game);
  }
}
