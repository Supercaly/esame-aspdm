import 'dart:async';

import 'package:aspdm_project/presentation/widgets/settings_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("SettingsGroup Tests", () {
    test("SettingsGroup with null title or children throws an error", () {
      try {
        SettingsGroup();
        fail("This should throw an exception!");
      } catch (e) {
        expect(e, isA<AssertionError>());
      }

      try {
        SettingsGroup(
          title: "title",
        );
        fail("This should throw an exception!");
      } catch (e) {
        expect(e, isA<AssertionError>());
      }

      try {
        SettingsGroup(
          title: "title",
          children: [],
        );
        fail("This should throw an exception!");
      } catch (e) {
        expect(e, isA<AssertionError>());
      }
    });

    testWidgets("display a group correctly", (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SettingsGroup(
              title: "group",
              children: [
                SettingsGroupItem(
                  icon: Icon(Icons.home),
                  text: "mock item 1",
                  textColor: Colors.red,
                ),
                SettingsGroupItem(
                  icon: Icon(Icons.home),
                  text: "mock item 2",
                  textColor: Colors.red,
                ),
              ],
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text("GROUP"), findsOneWidget);
      expect(find.byType(SettingsGroupItem), findsNWidgets(2));
    });

    testWidgets("display a group with a single item correctly", (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SettingsGroup.single(
              title: "group",
              item: SettingsGroupItem(
                icon: Icon(Icons.home),
                text: "mock item 1",
                textColor: Colors.red,
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text("GROUP"), findsOneWidget);
      expect(find.byType(SettingsGroupItem), findsOneWidget);
    });
  });

  group("SettingsGroupItem Tests", () {
    test("SettingsGroupItem with null text throws an error", () {
      try {
        SettingsGroupItem();
        fail("This should throw an exception!");
      } catch (e) {
        expect(e, isA<AssertionError>());
      }
    });

    testWidgets("the item works correctly", (tester) async {
      final onTapCompleter = Completer<void>();
      final onLongPressCompleter = Completer<void>();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SettingsGroupItem(
              icon: Icon(Icons.home),
              text: "mock_item",
              textColor: Colors.red,
              onTap: onTapCompleter.complete,
              onLongPress: onLongPressCompleter.complete,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.home), findsOneWidget);
      expect(find.text("mock_item"), findsOneWidget);
      expect((tester.firstWidget(find.text("mock_item")) as Text).style.color,
          equals(Colors.red));

      await tester.tap(find.text("mock_item"));
      await tester.pumpAndSettle();
      expect((onTapCompleter.isCompleted), isTrue);

      await tester.press(find.text("mock_item"));
      await tester.pumpAndSettle();
      expect((onLongPressCompleter.isCompleted), isTrue);
    });
  });
}
