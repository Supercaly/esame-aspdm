import 'package:aspdm_project/model/user.dart';
import 'package:aspdm_project/widgets/user_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets("display circle avatar", (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: UserAvatar(
            user: User("mock_id", "Mock User", "mock@email.com"),
            size: 48.0,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text("M"), findsOneWidget);
    expect(
        ((tester.firstWidget(find.byType(Container)) as Container).decoration
                as BoxDecoration)
            .shape,
        BoxShape.circle);
  });

  testWidgets("display rectangular avatar", (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: UserAvatar(
            user: User("mock_id", "Mock User", "mock@email.com"),
            size: 48.0,
            rectangle: true,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text("M"), findsOneWidget);
    expect(
      ((tester.firstWidget(find.byType(Container)) as Container).decoration
              as BoxDecoration)
          .shape,
      BoxShape.rectangle,
    );
    expect(
      ((tester.firstWidget(find.byType(Container)) as Container).decoration
              as BoxDecoration)
          .borderRadius,
      BorderRadius.circular(8.0),
    );
  });

  testWidgets("null user works correctly", (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: UserAvatar(
            user: null,
            size: 48.0,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(
      ((tester.firstWidget(find.byType(Container)) as Container).decoration
              as BoxDecoration)
          .shape,
      BoxShape.circle,
    );
  });

  test("null size throws an error", () {
    try {
      UserAvatar();
      fail("This should throw an exception!");
    } catch (e) {
      expect(e, isA<AssertionError>());
    }
    try {
      UserAvatar(size: 0.0);
      fail("This should throw an exception!");
    } catch (e) {
      expect(e, isA<AssertionError>());
    }
  });

  test("null rectangle throws an error", () {
    try {
      UserAvatar(size: 24, rectangle: null);
      fail("This should throw an exception!");
    } catch (e) {
      expect(e, isA<AssertionError>());
    }
  });
}
