import 'package:tasky/core/maybe.dart';

/// Class representing a void return type.
/// This class is used only in conjunction with
/// [Either] or other functional classes to express
/// a void return type since void can't be used.
class Unit {
  const Unit();

  @override
  String toString() => "Unit()";
}

/// A class that can be used to handle situations where one of
/// two disjoint types may be assigned to a value or returned
/// from a method, allowing for straightforward transformations
/// and eventual "reduction" to a single,
/// commonly-typed value.
abstract class Either<L, R> {
  const Either();

  /// Short-hand constructor for a [Either]
  /// with [Left] value.
  const factory Either.left(L l) = Left;

  /// Short-hand constructor for a [Either]
  /// with [Right] value.
  const factory Either.right(R r) = Right;

  /// Apply a transformation to the right side value if this is
  /// a [Right], or else the left side value if this is a [Left],
  /// and returns the result.
  B? fold<B>(B? Function(L left) ifLeft, B? Function(R right) ifRight);

  /// Returns a new [Either] that has the same left value or
  /// the result of [f] as right value.
  Either<L, R2> map<R2>(R2 Function(R right) f);

  /// Returns a new [Either] that has the same left value or
  /// the result of [f] as right value.
  Either<L, R2> flatMap<R2>(Either<L, R2> Function(R right) f);

  /// Returns the value if it's a right side value or null.
  R? getOrNull();

  /// Returns the value if it's a right side value or throws an exception.
  R getOrCrash();

  /// Returns the value if it's a right side value or executes
  /// an [orElse] callback retuning his value.
  R getOrElse(R Function(L left) orElse);

  /// Returns `true` if this is a [Left] side value.
  bool isLeft();

  /// Returns `true` if this is a [Right] side value.
  bool isRight();

  /// Returns a [Maybe] from the right side value.
  Maybe<R> toMaybe();
}

/// Implements the left element of the [Either].
class Left<L, R> extends Either<L, R> {
  final L _value;

  const Left(this._value);

  L get value => _value;

  @override
  B? fold<B>(B? Function(L p1) ifLeft, B? Function(R p1) ifRight) =>
      ifLeft(_value);

  @override
  Either<L, R2> map<R2>(R2 Function(R right) f) => Either<L, R2>.left(_value);

  @override
  Either<L, R2> flatMap<R2>(Either<L, R2> Function(R right) f) =>
      Either<L, R2>.left(_value);

  @override
  R? getOrNull() => null;

  @override
  R getOrCrash() => throw Exception("Trying to get invalid value!");

  @override
  R getOrElse(R Function(L left) orElse) => orElse(_value);

  @override
  bool isLeft() => true;

  @override
  bool isRight() => false;

  @override
  Maybe<R> toMaybe() => Maybe<R>.nothing();

  @override
  bool operator ==(Object other) =>
      other is Left && other._value == this._value;

  @override
  int get hashCode => _value.hashCode;

  @override
  String toString() => "Left($_value)";
}

/// Implements the right element of the [Either].
class Right<L, R> extends Either<L, R> {
  final R _value;

  const Right(this._value);

  R get value => _value;

  @override
  B? fold<B>(B? Function(L p1) ifLeft, B? Function(R p1) ifRight) =>
      ifRight(_value);

  @override
  Either<L, R2> map<R2>(R2 Function(R right) f) =>
      Either<L, R2>.right(f(_value));

  @override
  Either<L, R2> flatMap<R2>(Either<L, R2> Function(R right) f) => f(_value);

  @override
  R? getOrNull() => _value;

  @override
  R getOrCrash() => _value;

  @override
  R getOrElse(R Function(L left) orElse) => _value;

  @override
  bool isLeft() => false;

  @override
  bool isRight() => true;

  @override
  Maybe<R> toMaybe() => Maybe<R>.just(_value);

  @override
  bool operator ==(Object other) =>
      other is Right && other._value == this._value;

  @override
  int get hashCode => _value.hashCode;

  @override
  String toString() => "Right($_value)";
}
