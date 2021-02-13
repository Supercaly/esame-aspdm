import 'package:tasky/core/either.dart';
import 'package:tasky/core/value_object.dart';
import 'package:flutter_test/flutter_test.dart';

class ValueObjectImpl extends ValueObject<int> {
  @override
  final Either<ValueFailure<int>, int> value;

  const ValueObjectImpl(this.value);
}

void main() {
  group("ValueObject tests", () {
    test("equality works correctly", () {
      final obj1 = ValueObjectImpl(Either.right(123));
      final obj2 = ValueObjectImpl(Either.right(123));
      final obj3 = ValueObjectImpl(Either.left(ValueFailure.unknown(123)));
      final obj4 = ValueObjectImpl(Either.left(ValueFailure.unknown(123)));

      expect(obj1 == obj1, isTrue);
      expect(obj1 == obj2, isTrue);
      expect(obj3 == obj4, isTrue);
      expect(obj1 == obj4, isFalse);
    });

    test("hash code works correctly", () {
      final obj1 = ValueObjectImpl(Either.right(123));
      final obj2 = ValueObjectImpl(Either.left(ValueFailure.unknown(123)));

      expect(obj1.hashCode, equals(Either.right(123).hashCode));
      expect(obj2.hashCode,
          equals(Either.left(ValueFailure.unknown(123)).hashCode));
    });

    test("to string return the expected representation", () {
      expect(ValueObjectImpl(Either.right(123)).toString(),
          equals("Value{Right(123)}"));
      expect(ValueObjectImpl(Either.left(ValueFailure.unknown(123))).toString(),
          equals("Value{Left(ValueFailureUnknown{123})}"));
    });
  });

  group("ValueFailure tests", () {
    test("maybeMap return from the correct value", () {
      expect(
        ValueFailure.empty(null).maybeMap(
          empty: (_) => "empty",
          orElse: () => null,
        ),
        equals("empty"),
      );
      expect(
        ValueFailure.tooLong(123).maybeMap(
          tooLong: (_) => "too long",
          orElse: () => null,
        ),
        equals("too long"),
      );
      expect(
        ValueFailure.invalidEmail(456).maybeMap(
          invalidEmail: (_) => "invalid email",
          orElse: () => null,
        ),
        equals("invalid email"),
      );
      expect(
        ValueFailure.invalidPassword(789).maybeMap(
          invalidPassword: (_) => "invalid password",
          orElse: () => null,
        ),
        equals("invalid password"),
      );
      expect(
        ValueFailure.invalidId(null).maybeMap(
          invalidId: (_) => "invalid id",
          orElse: () => null,
        ),
        equals("invalid id"),
      );
      expect(
        ValueFailure.unknown(0).maybeMap(
          unknown: (_) => "unknown",
          orElse: () => null,
        ),
        equals("unknown"),
      );
    });

    test("maybeMap return from default", () {
      expect(
        ValueFailure.empty(null).maybeMap(
          orElse: () => "default",
        ),
        equals("default"),
      );
      expect(
        ValueFailure.tooLong(123).maybeMap(
          orElse: () => "default",
        ),
        equals("default"),
      );
      expect(
        ValueFailure.invalidEmail(456).maybeMap(
          orElse: () => "default",
        ),
        equals("default"),
      );
      expect(
        ValueFailure.invalidPassword(789).maybeMap(
          orElse: () => "default",
        ),
        equals("default"),
      );
      expect(
        ValueFailure.invalidId(null).maybeMap(
          orElse: () => "default",
        ),
        equals("default"),
      );
      expect(
        ValueFailure.unknown(0).maybeMap(
          orElse: () => "default",
        ),
        equals("default"),
      );
    });

    test("equality works correctly", () {
      final obj1 = ValueFailure.empty(null);
      final obj2 = ValueFailure.tooLong(123);
      final obj3 = ValueFailure.invalidEmail(456);
      final obj4 = ValueFailure.invalidPassword(789);
      final obj5 = ValueFailure.invalidId(null);
      final obj6 = ValueFailure.unknown(0);

      expect(obj1 == obj1, isTrue);
      expect(obj2 == obj2, isTrue);
      expect(obj3 == obj3, isTrue);
      expect(obj4 == obj4, isTrue);
      expect(obj5 == obj5, isTrue);
      expect(obj6 == obj6, isTrue);

      expect(obj1 == obj2, isFalse);
      expect(obj1 == obj3, isFalse);
      expect(obj1 == obj4, isFalse);
      expect(obj1 == obj5, isFalse);
      expect(obj1 == obj6, isFalse);

      expect(obj2 == obj1, isFalse);
      expect(obj2 == obj3, isFalse);
      expect(obj2 == obj4, isFalse);
      expect(obj2 == obj5, isFalse);
      expect(obj2 == obj6, isFalse);

      expect(obj3 == obj1, isFalse);
      expect(obj3 == obj2, isFalse);
      expect(obj3 == obj4, isFalse);
      expect(obj3 == obj5, isFalse);
      expect(obj3 == obj6, isFalse);

      expect(obj4 == obj1, isFalse);
      expect(obj4 == obj2, isFalse);
      expect(obj4 == obj3, isFalse);
      expect(obj4 == obj5, isFalse);
      expect(obj4 == obj6, isFalse);

      expect(obj5 == obj1, isFalse);
      expect(obj5 == obj2, isFalse);
      expect(obj5 == obj3, isFalse);
      expect(obj5 == obj4, isFalse);
      expect(obj5 == obj6, isFalse);

      expect(obj6 == obj1, isFalse);
      expect(obj6 == obj2, isFalse);
      expect(obj6 == obj3, isFalse);
      expect(obj6 == obj4, isFalse);
      expect(obj6 == obj5, isFalse);
    });

    test("hash code works correctly", () {
      expect(ValueFailure.empty(123).hashCode, equals(123.hashCode));
      expect(ValueFailure.tooLong(123).hashCode, equals(123.hashCode));
      expect(ValueFailure.invalidEmail(123).hashCode, equals(123.hashCode));
      expect(ValueFailure.invalidPassword(123).hashCode, equals(123.hashCode));
      expect(ValueFailure.invalidId(123).hashCode, equals(123.hashCode));
      expect(ValueFailure.unknown(123).hashCode, equals(123.hashCode));
    });

    test("to string return the expected representation", () {
      expect(
          ValueFailure.empty(123).toString(), equals("ValueFailureEmpty{123}"));
      expect(ValueFailure.tooLong(123).toString(),
          equals("ValueFailureTooLong{123}"));
      expect(ValueFailure.invalidEmail(123).toString(),
          equals("ValueFailureInvalidEmail{123}"));
      expect(ValueFailure.invalidPassword(123).toString(),
          equals("ValueFailureInvalidPassword{123}"));
      expect(ValueFailure.invalidId(null).toString(),
          equals("ValueFailureInvalidId{null}"));
      expect(ValueFailure.unknown(123).toString(),
          equals("ValueFailureUnknown{123}"));
    });
  });
}
