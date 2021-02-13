import 'package:tasky/presentation/generated/gen_colors.g.dart';
import 'package:tasky/presentation/widgets/expiration_badge.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import '../../finders/container_by_color_finder.dart';

void main() {
  group("ExpirationBadge Tests", () {
    testWidgets("create badge with expired date", (tester) async {
      final expDate = DateTime.now().subtract(Duration(days: 5));

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ExpirationBadge(
              date: expDate,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text(DateFormat("dd MMM y").format(expDate)), findsOneWidget);
      expect(ContainerByColorFinder(EasyColors.timeExpired), findsOneWidget);
      expect((tester.firstWidget(find.byType(Text)) as Text).style.color,
          equals(Colors.white));
      expect((tester.firstWidget(find.byType(Icon)) as Icon).color,
          equals(Colors.white));
    });

    testWidgets("create badge with expiring date", (tester) async {
      final expDate = DateTime.now().add(Duration(days: 1));

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ExpirationBadge(
              date: expDate,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text(DateFormat("dd MMM y").format(expDate)), findsOneWidget);
      expect(ContainerByColorFinder(EasyColors.timeExpiring), findsOneWidget);
      expect((tester.firstWidget(find.byType(Text)) as Text).style.color,
          equals(Colors.white));
      expect((tester.firstWidget(find.byType(Icon)) as Icon).color,
          equals(Colors.white));
    });

    testWidgets("create badge with not expiring date", (tester) async {
      final expDate = DateTime.now().add(Duration(days: 20));

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ExpirationBadge(
              date: expDate,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text(DateFormat("dd MMM y").format(expDate)), findsOneWidget);
      expect(ContainerByColorFinder(EasyColors.timeExpiring), findsNothing);
      expect(ContainerByColorFinder(EasyColors.timeExpired), findsNothing);
      expect((tester.firstWidget(find.byType(Text)) as Text).style.color,
          equals(Color(0x8a000000)));
      expect((tester.firstWidget(find.byType(Icon)) as Icon).color,
          equals(Color(0x8a000000)));
    });

    test("create badge with null date throws an error", () {
      try {
        ExpirationBadge(date: null);
        fail("This should throw an exception!");
      } catch (e) {
        expect(e, isA<AssertionError>());
      }
    });
  });

  group("ExpirationText Tests", () {
    testWidgets("create text with expired date", (tester) async {
      final expDate = DateTime.now().subtract(Duration(days: 5));

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ExpirationText(
              date: expDate,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text(DateFormat("dd MMM y HH:mm").format(expDate)),
          findsOneWidget);
      expect((tester.firstWidget(find.byType(Text)) as Text).style.color,
          equals(EasyColors.timeExpired));
    });

    testWidgets("create text with expiring date", (tester) async {
      final expDate = DateTime.now().add(Duration(days: 1));

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ExpirationText(
              date: expDate,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text(DateFormat("dd MMM y HH:mm").format(expDate)),
          findsOneWidget);
      expect((tester.firstWidget(find.byType(Text)) as Text).style.color,
          equals(EasyColors.timeExpiring));
    });

    testWidgets("create text with not expiring date", (tester) async {
      final expDate = DateTime.now().add(Duration(days: 20));

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ExpirationText(
              date: expDate,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text(DateFormat("dd MMM y HH:mm").format(expDate)),
          findsOneWidget);
      expect((tester.firstWidget(find.byType(Text)) as Text).style.color,
          equals(Color(0x8a000000)));
    });

    test("create text with null date throws an error", () {
      try {
        ExpirationText(date: null);
        fail("This should throw an exception!");
      } catch (e) {
        expect(e, isA<AssertionError>());
      }
    });
  });
}
