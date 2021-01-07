import 'package:aspdm_project/core/either.dart';
import 'package:aspdm_project/core/value_object.dart';
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
      final obj3 = ValueObjectImpl(Either.left(ValueFailure(123)));
      final obj4 = ValueObjectImpl(Either.left(ValueFailure(123)));

      expect(obj1 == obj1, isTrue);
      expect(obj1 == obj2, isTrue);
      expect(obj3 == obj4, isTrue);
      expect(obj1 == obj4, isFalse);
    });

    test("hash code works correctly", () {
      final obj1 = ValueObjectImpl(Either.right(123));
      final obj2 = ValueObjectImpl(Either.left(ValueFailure(123)));

      expect(obj1.hashCode, equals(Either.right(123).hashCode));
      expect(obj2.hashCode, equals(Either.left(ValueFailure(123)).hashCode));
    });

    test("to string return the expected representation", () {
      expect(ValueObjectImpl(Either.right(123)).toString(),
          equals("Value{Right(123)}"));
      expect(ValueObjectImpl(Either.left(ValueFailure(123))).toString(),
          equals("Value{Left(Failure{123})}"));
    });
  });

  group("ValueFailure tests", () {
    test("equality works correctly", () {
      final obj1 = ValueFailure(123);
      final obj2 = ValueFailure(123);
      final obj3 = ValueFailure(456);

      expect(obj1 == obj1, isTrue);
      expect(obj1 == obj2, isTrue);
      expect(obj1 == obj3, isFalse);
    });

    test("hash code works correctly", () {
      expect(ValueFailure(123).hashCode, equals(123.hashCode));
    });

    test("to string return the expected representation", () {
      expect(ValueFailure(123).toString(), equals("Failure{123}"));
    });
  });
}
