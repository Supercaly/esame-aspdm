import 'package:aspdm_project/core/either.dart';

/// Class that encapsulates a [Future] and helps manage
/// his completion and errors in a more FP-way.
class MonadTask<A> {
  final Future<A> Function() _run;

  const MonadTask(this._run);

  /// Converts the [MonadTask] back into the original future.
  Future<A> run() => _run();

  /// Attempts to execute the function inside [MonadTask].
  /// This automatically catches all exceptions feeding them into
  /// the left side value of the [Either].
  /// If the errors are or type [L] those are passed right to the [Either],
  /// otherwise they are passed through an [onError] function that converts
  /// them to [L].
  MonadTask<Either<L, A>> attempt<L>(L Function(dynamic err) onError) =>
      MonadTask(() =>
          _run().then((value) => Either<L, A>.right(value)).catchError((err) {
            try {
              return Either<L, A>.left(err as L);
            } catch (_) {
              return Either<L, A>.left(onError(err));
            }
          }));
}
