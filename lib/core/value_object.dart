import 'package:aspdm_project/core/either.dart';

/// Class representing a value that can be used by an entity.
abstract class ValueObject<T> {
  /// Returns [Either] the value [T] or a [ValueFailure].
  Either<ValueFailure<T>, T> get value;

  const ValueObject();

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ValueObject<T> && other.value == this.value;
  }

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => "Value{$value}";
}

/// Class representing the invalid state of a ValueObject.
class ValueFailure<T> {
  final T _value;

  /// Creates a new [ValueFailure] with an invalid value.
  const ValueFailure(this._value);

  /// Returns the invalid value.
  /// This can be useful for debug purpose.
  T get value => _value;

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ValueFailure<T> && other.value == this.value;
  }

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => "Failure{$_value}";
}
