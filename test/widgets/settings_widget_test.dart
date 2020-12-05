import 'dart:async';

import 'package:aspdm_project/widgets/settings_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
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
