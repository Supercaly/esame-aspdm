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
  });
}
