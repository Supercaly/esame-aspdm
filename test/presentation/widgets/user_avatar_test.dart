import 'package:tasky/domain/entities/user.dart';
import 'package:tasky/domain/values/unique_id.dart';
import 'package:tasky/domain/values/user_values.dart';
import 'package:tasky/presentation/widgets/user_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../finders/container_by_color_finder.dart';

void main() {
  testWidgets("display circle avatar", (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: UserAvatar(
            user: User(UniqueId("mock_id"), UserName("Mock User"),
                EmailAddress("mock@email.com"), Colors.red),
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
    expect(ContainerByColorFinder(Colors.red), findsOneWidget);
  });

  testWidgets("display rectangular avatar", (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: UserAvatar(
            user: User(
              UniqueId("mock_id"),
              UserName("Mock User"),
              EmailAddress("mock@email.com"),
              Colors.blue,
            ),
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
    expect(ContainerByColorFinder(Colors.blue), findsOneWidget);
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

  testWidgets("updates user when reconfiguring", (tester) async {
    final GlobalKey key = GlobalKey();
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: UserAvatar(
            key: key,
            user: User(
              UniqueId("mock_id"),
              UserName("Mock User"),
              EmailAddress("mock@email.com"),
              Colors.blue,
            ),
            size: 48.0,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text("M"), findsOneWidget);
    expect(ContainerByColorFinder(Colors.blue), findsOneWidget);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: UserAvatar(
            key: key,
            user: User(
              UniqueId("mock_id_2"),
              UserName("New Mocked User"),
              EmailAddress("mock2@email.com"),
              Colors.green,
            ),
            size: 48.0,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text("N"), findsOneWidget);
    expect(ContainerByColorFinder(Colors.green), findsOneWidget);
  });

  test("null size throws an error", () {
    try {
      UserAvatar(size: null, user: null);
      fail("This should throw an exception!");
    } catch (e) {
      expect(e, isA<AssertionError>());
    }
    try {
      UserAvatar(size: 0.0, user: null);
      fail("This should throw an exception!");
    } catch (e) {
      expect(e, isA<AssertionError>());
    }
  });

  test("null rectangle throws an error", () {
    try {
      UserAvatar(size: 24, rectangle: null, user: null);
      fail("This should throw an exception!");
    } catch (e) {
      expect(e, isA<AssertionError>());
    }
  });
}
