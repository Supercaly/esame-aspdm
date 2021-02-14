/// Class that represent an optional value.
/// A value of type Maybe can be either a value of type
/// [Just] or [Nothing].
/// Using Maybe is a good way to deal with errors or
/// exceptional cases without resorting to drastic measures
/// such as error.
abstract class Maybe<A> {
  const Maybe();

  /// Creates a [Maybe] with nothing value.
  factory Maybe.nothing() => Nothing();

  /// Creates a [Maybe] with just value.
  factory Maybe.just(A a) => Just(a);

  /// Apply a transformation to the just side value if this is
  /// a [Just], or else to the nothing side value if this is a [Nothing]
  /// and returns the result.
  R? fold<R>(R? Function() ifNothing, R? Function(A value) ifJust);

  /// Returns a [Just] containing the result of applying a transformation
  /// [f] or otherwise a [Nothing].
  Maybe<R> map<R>(R Function(A value) f);

  /// Returns the value contained by the [Just] or [null].
  A? getOrNull();

  /// Returns the value contained by the [Just] or
  /// the result of applying [orElse].
  A getOrElse(A Function() orElse);

  /// Returns true if the [Maybe] is [Nothing].
  bool isNothing();

  /// Returns true if the [Maybe] is [Just].
  bool isJust();
}

/// Implements the nothing value of [Maybe].
class Nothing<A> extends Maybe<A> {
  const Nothing();

  @override
  R? fold<R>(R? Function() ifNothing, R? Function(A value) ifJust) =>
      ifNothing();

  @override
  A getOrElse(A Function() orElse) => orElse();

  @override
  A? getOrNull() => null;

  @override
  Maybe<R> map<R>(R Function(A value) f) => Nothing<R>();

  @override
  bool isJust() => false;

  @override
  bool isNothing() => true;

  @override
  bool operator ==(Object other) => other is Nothing<A>;

  @override
  int get hashCode => 0;

  @override
  String toString() => "Nothing()";
}

/// Implements the just value of [Maybe].
class Just<A> extends Maybe<A> {
  final A _value;

  const Just(this._value);

  @override
  R? fold<R>(R? Function() ifNothing, R? Function(A value) ifJust) =>
      ifJust(_value);

  @override
  A getOrElse(A Function() orElse) => _value;

  @override
  A getOrNull() => _value;

  @override
  Maybe<R> map<R>(R Function(A value) f) => Just(f(_value));

  @override
  bool isNothing() => false;

  @override
  bool isJust() => true;

  @override
  bool operator ==(Object other) => other is Just<A> && other._value == _value;

  @override
  int get hashCode => _value.hashCode;

  @override
  String toString() => "Just($_value)";
}
