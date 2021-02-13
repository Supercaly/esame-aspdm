import 'dart:async';
import 'package:tasky/core/either.dart';

/// Class that encapsulates a [Future] of [Either] and helps manage
/// his completion and errors in a more FP-way.
class MonadTask<Error, Value> {
  final Future<Either<Error, Value>> Function() _run;

  /// Creates a [MonadTask] with a function that returns
  /// [Future] of [Either].
  const MonadTask(this._run);

  /// Converts the [MonadTask] back into the original future.
  Future<Either<Error, Value>> run() => _run();

  /// Attempts to execute the function inside [MonadTask].
  /// This automatically catches all exceptions feeding them into
  /// the left side value of the [Either].
  /// If the errors are or type [Error] those are passed right to the [Either],
  /// otherwise they are passed through an [onError] function that converts
  /// them to [Error].
  MonadTask<Error, Value> attempt(Error Function(dynamic err) onError) =>
      MonadTask(() => _run().catchError((err) {
            try {
              return Either<Error, Value>.left(err as Error);
            } catch (_) {
              return Either<Error, Value>.left(onError(err));
            }
          }));

  /// Returns a new [MonadTask] that completes with an [Either] that maintains
  /// the same left side value, but maps the right side value through [f].
  MonadTask<Error, V2> map<V2>(V2 Function(Value value) f) =>
      MonadTask(() => _run().then((either) => either.map((right) => f(right))));
}
