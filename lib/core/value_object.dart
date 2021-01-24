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
abstract class ValueFailure<T> {
  factory ValueFailure.empty(T value) => ValueFailureEmpty(value);
  factory ValueFailure.tooLong(T value) => ValueFailureTooLong(value);
  factory ValueFailure.invalidEmail(T value) => ValueFailureInvalidEmail(value);
  factory ValueFailure.invalidPassword(T value) =>
      ValueFailureInvalidPassword(value);
  factory ValueFailure.invalidId(T value) => ValueFailureInvalidId(value);
  factory ValueFailure.unknown(T value) => ValueFailureUnknown(value);

  final T _value;

  const ValueFailure(this._value);

  /// Returns the invalid value.
  /// This can be useful for debug purpose.
  T get value => _value;
}

class ValueFailureEmpty<T> extends ValueFailure<T> {
  const ValueFailureEmpty(T value) : super(value);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ValueFailureEmpty<T> && other.value == this.value;
  }

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => "ValueFailureEmpty{$_value}";
}

class ValueFailureTooLong<T> extends ValueFailure<T> {
  const ValueFailureTooLong(T value) : super(value);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ValueFailureTooLong<T> && other.value == this.value;
  }

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => "ValueFailureTooLong{$_value}";
}

class ValueFailureInvalidEmail<T> extends ValueFailure<T> {
  const ValueFailureInvalidEmail(T value) : super(value);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ValueFailureInvalidEmail<T> && other.value == this.value;
  }

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => "ValueFailureInvalidEmail{$_value}";
}

class ValueFailureInvalidPassword<T> extends ValueFailure<T> {
  const ValueFailureInvalidPassword(T value) : super(value);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ValueFailureInvalidPassword<T> && other.value == this.value;
  }

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => "ValueFailureInvalidPassword{$_value}";
}

class ValueFailureInvalidId<T> extends ValueFailure<T> {
  const ValueFailureInvalidId(T value) : super(value);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ValueFailureInvalidId<T> && other.value == this.value;
  }

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => "ValueFailureInvalidId{$_value}";
}

class ValueFailureUnknown<T> extends ValueFailure<T> {
  const ValueFailureUnknown(T value) : super(value);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ValueFailureUnknown<T> && other.value == this.value;
  }

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => "ValueFailureUnknown{$_value}";
}
