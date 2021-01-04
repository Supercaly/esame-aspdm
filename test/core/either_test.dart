import 'package:aspdm_project/core/either.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("Either tests", () {
    test("create either with left value", () {
      final val = Either<String, int>.left("mock_value");

      expect(val, isA<Either<String, int>>());
      expect((val as Left).value, equals("mock_value"));
    });

    test("create either with right value", () {
      final val = Either<String, int>.right(123);

      expect(val, isA<Either<String, int>>());
      expect((val as Right).value, equals(123));
    });

    test("fold invokes the correct methods", () {
      bool leftCalled = false, rightCalled = false;

      Either<String, int>.left("mock_value").fold(
        (left) => leftCalled = true,
        (right) {},
      );
      expect(leftCalled, isTrue);
      expect(rightCalled, isFalse);

      leftCalled = false;
      rightCalled = false;

      Either<String, int>.right(123).fold(
        (left) {},
        (right) => rightCalled = true,
      );

      expect(leftCalled, isFalse);
      expect(rightCalled, isTrue);
    });

    test("fold returns from the correct methods", () {
      final ret = Either<String, int>.left("mock_value").fold(
        (left) => 0,
        (right) => 1,
      );
      expect(ret, equals(0));

      final ret2 = Either<String, int>.right(123).fold(
        (left) => 0,
        (right) => 1,
      );
      expect(ret2, equals(1));
    });

    test("isLeft returns correctly", () {
      expect(Either.left("mock_value").isLeft(), isTrue);
      expect(Either.right(123).isLeft(), isFalse);
    });

    test("isRight returns correctly", () {
      expect(Either.right(123).isRight(), isTrue);
      expect(Either.left("mock_value").isRight(), isFalse);
    });

    test("to string returns the correct representation", () {
      expect(Either.left(123).toString(), equals("Left(123)"));
      expect(Either.right(123).toString(), equals("Right(123)"));
    });

    test("map invokes the correct methods", () {
      bool leftCalled = false, rightCalled = false;

      Either<String, int>.left("mock_value").map(
        (left) {
          leftCalled = true;
          return left;
        },
        (right) {
          leftCalled = true;
          return right;
        }
      );
      expect(leftCalled, isTrue);
      expect(rightCalled, isFalse);

      leftCalled = false;
      rightCalled = false;

      Either<String, int>.right(123).fold(
        (left) {
          leftCalled = true;
          return left;
        },
        (right) {
          rightCalled = true;
          return right;
        }
      );

      expect(leftCalled, isFalse);
      expect(rightCalled, isTrue);
    });

    test("map returns from the correct methods", () {
      final ret = Either<String, int>.left("mock_value").map(
        (left) => 0.0,
        (right) => "mock_value",
      );
      expect(ret, isA<Either<double, String>>());
      expect((ret as Left).value, equals(0.0));

      final ret2 = Either<String, int>.right(123).map(
        (left) => 0.0,
        (right) => "mock_value",
      );
      expect(ret2, isA<Either<double, String>>());
      expect((ret2 as Right).value, equals("mock_value"));
    });
  });

  group("Left tests", () {
    test("equality works correctly", () {
      expect(Either.left("mock_value") == Either.left("mock_value"), isTrue);
      expect(Either.left("mock_value") == Either.left("mock_value_2"), isFalse);
      expect(Either.left("mock_value") == Either.right("mock_value"), isFalse);
      expect(Either.left("mock_value") == Either.right(123), isFalse);
    });

    test("value returns the correct value", () {
      expect((Either.left("mock_value") as Left).value, equals("mock_value"));
    });
  });

  group("Right tests", () {
    test("equality works correctly", () {
      expect(Either.right("mock_value") == Either.right("mock_value"), isTrue);
      expect(
          Either.right("mock_value") == Either.right("mock_value_2"), isFalse);
      expect(Either.right("mock_value") == Either.left("mock_value"), isFalse);
      expect(Either.right("mock_value") == Either.left(123), isFalse);
    });

    test("value returns the correct value", () {
      expect((Either.right("mock_value") as Right).value, equals("mock_value"));
    });
  });
}
