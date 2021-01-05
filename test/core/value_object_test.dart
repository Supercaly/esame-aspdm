import 'package:aspdm_project/core/either.dart';
import 'package:aspdm_project/core/value_failure.dart';
import 'package:aspdm_project/core/value_object.dart';
import 'package:flutter_test/flutter_test.dart';

class ValueObjectImpl extends ValueObject<int> {
  @override
  final Either<ValueFailure<int>, int> value;

  const ValueObjectImpl(this.value);
}

void main() {
  test("equality works correctly", () {
    final obj1 = ValueObjectImpl(Either.right(123));
    final obj2 = ValueObjectImpl(Either.right(123));

    expect(obj1 == obj2, isTrue);

    final obj3 = ValueObjectImpl(Either.left(ValueFailure(123)));
    final obj4 = ValueObjectImpl(Either.left(ValueFailure(123)));

    expect(obj3 == obj4, isTrue);

    expect(obj1 == obj4, isFalse);
  });
}