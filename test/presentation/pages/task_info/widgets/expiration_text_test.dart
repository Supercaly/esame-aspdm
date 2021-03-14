import 'package:tasky/presentation/generated/gen_colors.g.dart';
import 'package:tasky/presentation/pages/task_info/widgets/expiration_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';

void main() {
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
      expect(
        (tester.firstWidget(find.byType(Text)) as Text).style?.color,
        equals(EasyColors.timeExpired),
      );
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
      expect(
        (tester.firstWidget(find.byType(Text)) as Text).style?.color,
        equals(EasyColors.timeExpiring),
      );
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
      expect(
        (tester.firstWidget(find.byType(Text)) as Text).style?.color,
        equals(Color(0x8a000000)),
      );
    });
  });
}
