import 'package:tasky/core/maybe.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("Maybe tests", () {
    test("create Maybe with nothing", () {
      final n = Maybe.nothing();
      expect(n, isA<Nothing>());
    });

    test("create Maybe with just", () {
      final n = Maybe.just(123);
      expect(n, isA<Just<int>>());
    });

    test("fold returns from the correct method", () {
      final v1 = Maybe.just(123);
      final res = v1.fold(() => "nothing", (value) => "value - $value");
      expect(res, equals("value - 123"));

      final v2 = Maybe.nothing();
      final res2 = v2.fold(() => "nothing", (value) => "value - $value");
      expect(res2, equals("nothing"));
    });

    test("map returns from the correct method", () {
      final v1 = Maybe.just(123);
      final m1 = v1.map((value) => "$value");
      expect(m1, isA<Just<String>>());
      expect(m1.getOrNull(), "123");

      final v2 = Maybe.nothing();
      final m2 = v2.map((value) => "$value");
      expect(m2, isA<Nothing<String>>());
      expect(m2.getOrNull(), isNull);
    });

    test("flatMap returns the correct value", () {
      final ret = Maybe<String>.just("mock_value")
          .flatMap((value) => Maybe<String>.just("mock_value_2"));
      expect(ret, isA<Maybe<String>>());
      expect(ret.isJust(), isTrue);
      expect(ret.getOrCrash(), equals("mock_value_2"));

      final ret2 = Maybe.nothing().flatMap((value) => Maybe<String>.nothing());
      expect(ret2, isA<Maybe<String>>());
      expect(ret2.isNothing(), isTrue);

      final ret3 = Maybe<int>.nothing()
          .flatMap((value) => Maybe<String>.just("mock_value_2"));
      expect(ret3, isA<Maybe<String>>());
      expect(ret3.isNothing(), isTrue);

      final ret4 = Maybe<String>.just("mock_value")
          .flatMap((value) => Maybe<int>.nothing());
      expect(ret4, isA<Maybe<int>>());
      expect(ret4.isNothing(), isTrue);
    });

    test("get or null returns the correct value", () {
      expect(Maybe.just(123).getOrNull(), 123);
      expect(Maybe.nothing().getOrNull(), isNull);
    });

    test("get or else returns the correct value", () {
      expect(Maybe.just(123).getOrElse(() => 456), 123);
      expect(Maybe.nothing().getOrElse(() => 456), 456);
    });

    test("get or crash returns the correct value", () {
      final m1 = Maybe.just(123);
      expect(m1.getOrCrash(), equals(123));

      try {
        Maybe.nothing().getOrCrash();
        fail("This should throw an exception!");
      } catch (e) {
        expect(e, isA<Exception>());
      }
    });

    test("is nothing returns correctly", () {
      expect(Maybe.just(123).isNothing(), isFalse);
      expect(Maybe.nothing().isNothing(), isTrue);
    });

    test("is true returns correctly", () {
      expect(Maybe.just(123).isJust(), isTrue);
      expect(Maybe.nothing().isJust(), isFalse);
    });

    test("to string returns the correct representation", () {
      expect(Maybe.nothing().toString(), equals("Nothing()"));
      expect(Maybe.just(123).toString(), equals("Just(123)"));
    });
  });

  group("Nothing tests", () {
    test("equality works correctly", () {
      final n1 = Maybe.nothing();
      final n2 = Maybe.nothing();
      final n3 = Maybe.just(123);

      expect(n1 == n2, isTrue);
      expect(n1 == n3, isFalse);

      expect(n2 == n1, isTrue);
      expect(n2 == n3, isFalse);

      expect(n3 == n1, isFalse);
      expect(n3 == n2, isFalse);
    });

    test("hash code works correctly", () {
      expect(Maybe.nothing().hashCode, equals(0));
    });
  });

  group("Just tests", () {
    test("equality works correctly", () {
      final n1 = Maybe.just(123);
      final n2 = Maybe.just(123);
      final n3 = Maybe.just(456);
      final n4 = Maybe.nothing();

      expect(n1 == n2, isTrue);
      expect(n1 == n3, isFalse);
      expect(n1 == n4, isFalse);

      expect(n2 == n1, isTrue);
      expect(n2 == n3, isFalse);
      expect(n2 == n4, isFalse);

      expect(n3 == n1, isFalse);
      expect(n3 == n2, isFalse);
      expect(n3 == n4, isFalse);

      expect(n4 == n1, isFalse);
      expect(n4 == n2, isFalse);
      expect(n4 == n3, isFalse);
    });

    test("hash code works correctly", () {
      expect(Maybe.just(123).hashCode, equals(123.hashCode));
    });
  });
}
