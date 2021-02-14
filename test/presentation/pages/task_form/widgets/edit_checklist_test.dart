import 'package:tasky/core/ilist.dart';
import 'package:tasky/domain/values/task_values.dart';
import 'package:tasky/presentation/pages/task_form/misc/checklist_primitive.dart';
import 'package:tasky/presentation/pages/task_form/widgets/edit_checklist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("EditChecklist test", () {
    testWidgets("show widget correctly", (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EditChecklist(
              primitive: ChecklistPrimitive(
                title: "Checklist",
                items: IList.from(
                  [
                    ItemText("Item 1"),
                    ItemText("Item 2"),
                    ItemText("Item 3"),
                  ],
                ),
              ),
            ),
          ),
        ),
      );

      expect(find.text("Checklist"), findsOneWidget);
      expect(find.text("Item 1"), findsOneWidget);
      expect(find.text("Item 2"), findsOneWidget);
      expect(find.text("Item 3"), findsOneWidget);
      expect(find.byType(Checkbox), findsNWidgets(3));
    });

    testWidgets("tap call edit correctly", (tester) async {
      bool edit = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EditChecklist(
              onTap: () => edit = true,
              primitive: ChecklistPrimitive(
                title: "Checklist",
                items: IList.from(
                  [
                    ItemText("Item 1"),
                    ItemText("Item 2"),
                    ItemText("Item 3"),
                  ],
                ),
              ),
            ),
          ),
        ),
      );

      expect(edit, isFalse);
      await tester.tap(find.byType(Card));
      await tester.pumpAndSettle();
      expect(edit, isTrue);
    });

    testWidgets("tap on delete icon call remove correctly", (tester) async {
      bool remove = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EditChecklist(
              onRemove: () => remove = true,
              primitive: ChecklistPrimitive(
                title: "Checklist",
                items: IList.from(
                  [
                    ItemText("Item 1"),
                    ItemText("Item 2"),
                    ItemText("Item 3"),
                  ],
                ),
              ),
            ),
          ),
        ),
      );

      expect(remove, isFalse);
      await tester.tap(find.byIcon(Icons.delete));
      await tester.pumpAndSettle();
      expect(remove, isTrue);
    });
  });
}
