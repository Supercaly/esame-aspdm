/// A class that can be used to handle situations where one of
/// two disjoint types may be assigned to a value or returned
/// from a method, allowing for straightforward transformations
/// and eventual "reduction" to a single,
/// commonly-typed value.
abstract class Either<L, R> {
  const Either();

  /// Short-hand constructor for a [Either]
  /// with [Left] value.
  factory Either.left(L l) => Left._(l);

  /// Short-hand constructor for a [Either]
  /// with [Right] value.
  factory Either.right(R r) => Right._(r);

  /// Apply a transformation to the right side value if this is
  /// a [Right], or else the left side value if this is a [Left],
  /// and returns the result.
  B fold<B>(B Function(L left) ifLeft, B Function(R right) ifRight);

  /// Returns a new [Either] that as a left side value returned by
  /// [ifLeft] or a right side value returned by [ifRight].
  Either<T, U> map<T, U>(
      T Function(L left) ifLeft, U Function(R right) ifRight);

  /// Returns `true` if this is a [Left] side value.
  bool isLeft() => fold((l) => true, (r) => false);

  /// Returns `true` if this is a [Right] side value.
  bool isRight() => fold((l) => false, (r) => true);

  @override
  String toString() => fold((l) => "Left($l)", (r) => "Right($r)");
}

/// Implements the left element of the [Either].
class Left<L, R> extends Either<L, R> {
  final L _value;

  const Left._(this._value);

  L get value => _value;

  @override
  B fold<B>(B Function(L p1) ifLeft, B Function(R p1) ifRight) =>
      ifLeft(_value);

  @override
  Either<T, U> map<T, U>(T Function(L p1) ifLeft, U Function(R p1) ifRight) =>
      Either<T, U>.left(ifLeft(_value));

  @override
  bool operator ==(Object other) =>
      other is Left && other._value == this._value;

  @override
  int get hashCode => _value.hashCode;
}

/// Implements the right element of the [Either].
class Right<L, R> extends Either<L, R> {
  final R _value;

  const Right._(this._value);

  R get value => _value;

  @override
  B fold<B>(B Function(L p1) ifLeft, B Function(R p1) ifRight) =>
      ifRight(_value);

  @override
  Either<T, U> map<T, U>(T Function(L p1) ifLeft, U Function(R p1) ifRight) =>
      Either<T, U>.right(ifRight(_value));

  @override
  bool operator ==(Object other) =>
      other is Right && other._value == this._value;

  @override
  int get hashCode => _value.hashCode;
}
