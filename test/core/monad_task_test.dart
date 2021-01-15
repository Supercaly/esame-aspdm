import 'package:aspdm_project/core/either.dart';
import 'package:aspdm_project/core/monad_task.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_test/flutter_test.dart';

/// Mock [Exception] used to verify error propagation inside attempt.
class MockException extends Equatable implements Exception {
  /// true if the value is generated inside the [Either], false
  /// if it's passed inside the attempt.
  final bool passed;

  MockException(this.passed);

  @override
  List<Object> get props => [passed];
}

void main() {
  group("MonadTask tests", () {
    test("run returns the future", () {
      final t1 = MonadTask<MockException, num>(
        () => Future.value(Either.right(123)),
      );
      expect(t1.run(), isA<Future<Either<MockException, num>>>());
      expectLater(t1.run(), completion(Either.right(123)));
    });

    test("map returns a new monad task", () {
      final t1 =
          MonadTask<MockException, num>(() => Future.value(Either.right(123)));
      expect(
        t1.map((value) => "$value").run(),
        completion(Either.right("123")),
      );

      final t2 = MonadTask<MockException, num>(
        () => Future.value(Either.left(MockException(true))),
      );
      expect(
        t2.map((value) => "$value").run(),
        completion(Either.left(MockException(true))),
      );
    });

    test("attempt return the correct either", () async {
      final t1 = MonadTask<MockException, num>(
        () => Future.microtask(() => Either.right(num.parse("123"))),
      );
      expect(
        t1.attempt((err) => MockException(false)).run(),
        completion(Either.right(123)),
      );

      final t2 = MonadTask<MockException, num>(
        () => Future.microtask(() => Either.left(MockException(true))),
      );
      expect(
        t2.attempt((err) => MockException(false)).run(),
        completion(Either.left(MockException(true))),
      );

      final t3 = MonadTask<MockException, num>(
        () => Future.microtask(() => Either.right(num.parse("not_a_number"))),
      );
      expect(
        t3.attempt((err) => MockException(false)).run(),
        completion(Either.left(MockException(false))),
      );
    });
  });
}
