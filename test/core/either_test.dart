import 'package:tasky/core/either.dart';
import 'package:tasky/core/maybe.dart';
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

    test("map returns from the correct methods", () {
      final ret = Either<String, int>.left("mock_value").map(
        (right) => 0.0,
      );
      expect(ret, isA<Either<String, double>>());
      expect((ret as Left).value, equals("mock_value"));

      final ret2 = Either<String, int>.right(123).map(
        (right) => 0.0,
      );
      expect(ret2, isA<Either<String, double>>());
      expect((ret2 as Right).value, equals(0.0));
    });

    test("flatMap returns the correct either", () {
      final ret = Either<String, int>.left("mock_value")
          .flatMap((right) => Either<String, double>.left("mock_value_2"));
      expect(ret, isA<Either<String, double>>());
      expect(ret.isLeft(), isTrue);
      expect((ret as Left).value, equals("mock_value"));

      final ret2 =
          Either<String, int>.right(123).flatMap((right) => Either.right(0.0));
      expect(ret2, isA<Either<String, double>>());
      expect(ret2.isRight(), isTrue);
      expect((ret2 as Right).value, equals(0.0));

      final ret3 = Either<String, int>.right(123)
          .flatMap((right) => Either<String, double>.left("mock_value_2"));
      expect(ret3, isA<Either<String, double>>());
      expect(ret3.isLeft(), isTrue);
      expect((ret3 as Left).value, equals("mock_value_2"));
    });

    test("get or null returns the correct value", () {
      final e1 = Either.left(123);
      expect(e1.getOrNull(), isNull);

      final e2 = Either.right(123);
      expect(e2.getOrNull(), equals(123));
    });

    test("get or else invokes the correct methods", () {
      bool called = false;

      final e1 = Either.left(123);
      e1.getOrElse((left) {
        called = true;
        return 456;
      });
      expect(called, isTrue);

      called = false;

      final e2 = Either.right(123);
      e2.getOrElse((left) {
        called = true;
        return 456;
      });
      expect(called, isFalse);
    });

    test("get or else returns the correct value", () {
      final e1 = Either.left(123);
      expect(e1.getOrElse((left) => 456), equals(456));

      final e2 = Either.right(123);
      expect(e2.getOrElse((left) => 456), equals(123));
    });

    test("get or crash returns the correct value", () {
      final e1 = Either.right(123);
      expect(e1.getOrCrash(), equals(123));

      try {
        Either.left(123).getOrCrash();
        fail("This should throw an exception!");
      } catch (e) {
        expect(e, isA<Exception>());
      }
    });

    test("to maybe returns correctly", () {
      final v1 = Either.right(123);
      expect(v1.toMaybe(), isA<Maybe<int>>());
      expect(v1.toMaybe().isJust(), isTrue);
      expect(v1.toMaybe().getOrNull(), equals(123));

      final v2 = Either<Error, int>.left(Error());
      expect(v2.toMaybe(), isA<Maybe<int>>());
      expect(v2.toMaybe().isNothing(), isTrue);
    });

    test("to string returns the correct representation", () {
      final e1 = Either.left(123);
      expect(e1.toString(), equals("Left(123)"));

      final e2 = Either.right(123);
      expect(e2.toString(), equals("Right(123)"));
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

    test("hash code works correctly", () {
      final e1 = Either.left(123);
      expect(e1.hashCode, equals(123.hashCode));
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

    test("hash code works correctly", () {
      final e1 = Either.right(123);
      expect(e1.hashCode, equals(123.hashCode));
    });
  });

  group("Unit tests", () {
    test("to string returns the correct representation", () {
      expect(const Unit().toString(), equals("Unit()"));
    });
  });
}
