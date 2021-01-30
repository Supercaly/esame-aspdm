import 'package:aspdm_project/core/maybe.dart';
import 'package:aspdm_project/presentation/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("Router test", () {
    test("extract arguments returns the correct object", () {
      final obj1 = 123;
      final Maybe<int> res1 = Routes.extractArguments(
        RouteSettings(name: "/name", arguments: obj1),
      );
      expect(res1.isJust(), isTrue);
      expect(res1.getOrNull(), isNotNull);
      expect(res1.getOrNull(), equals(123));

      final res2 = Routes.extractArguments(RouteSettings(name: "/name"));
      expect(res2.isNothing(), isTrue);
      expect(res2.getOrNull(), isNull);

      final Maybe<String> res3 = Routes.extractArguments(
        RouteSettings(name: "/name", arguments: obj1),
      );
      expect(res3.isNothing(), isTrue);
      expect(res3.getOrNull(), isNull);
    });

    test("on generate route returns the correct route", () {
      expect(
        Routes.onGenerateRoute(RouteSettings(name: Routes.main)),
        isA<MaterialPageRoute>(),
      );
      expect(
        Routes.onGenerateRoute(RouteSettings(name: Routes.archive)),
        isA<MaterialPageRoute>(),
      );
      expect(
        Routes.onGenerateRoute(RouteSettings(name: Routes.task)),
        isA<MaterialPageRoute>(),
      );
      expect(
        Routes.onGenerateRoute(RouteSettings(name: Routes.taskForm)),
        isA<MaterialPageRoute>(),
      );

      try {
        Routes.onGenerateRoute(RouteSettings(name: "/unknown"));
      } catch (e) {
        expect(e, isA<InvalidRouteException>());
        expect((e as InvalidRouteException).name, equals("/unknown"));
      }
    });
  });
}
