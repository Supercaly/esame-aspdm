import 'package:tasky/core/ilist.dart';
import 'package:tasky/domain/entities/checklist.dart';
import 'package:tasky/domain/values/task_values.dart';
import 'package:tasky/domain/values/unique_id.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tasky/presentation/pages/task_info/widgets/display_checklist.dart';

void main() {
  group("DisplayChecklist test", () {
    test("create widget with null parameter throws an exception", () {
      try {
        DisplayChecklist(checklist: null);
        fail("This should throw an exception!");
      } catch (e) {
        expect(e, isA<AssertionError>());
      }
    });

    testWidgets("show widget correctly", (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DisplayChecklist(
              checklist: Checklist.test(
                id: UniqueId("checklist_id"),
                title: ChecklistTitle("Checklist"),
                items: IList.from(
                  [
                    ChecklistItem.test(
                      id: UniqueId("item_1"),
                      item: ItemText("Item 1"),
                      complete: Toggle(false),
                    ),
                    ChecklistItem.test(
                      id: UniqueId("item_2"),
                      item: ItemText("Item 2"),
                      complete: Toggle(false),
                    ),
                    ChecklistItem.test(
                      id: UniqueId("item_3"),
                      item: ItemText("Item 3"),
                      complete: Toggle(true),
                    ),
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

    testWidgets("show/hide content works correctly", (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DisplayChecklist(
              checklist: Checklist.test(
                id: UniqueId("checklist_id"),
                title: ChecklistTitle("Checklist"),
                items: IList.from(
                  [
                    ChecklistItem.test(
                      id: UniqueId("item_1"),
                      item: ItemText("Item 1"),
                      complete: Toggle(false),
                    ),
                    ChecklistItem.test(
                      id: UniqueId("item_2"),
                      item: ItemText("Item 2"),
                      complete: Toggle(false),
                    ),
                    ChecklistItem.test(
                      id: UniqueId("item_3"),
                      item: ItemText("Item 3"),
                      complete: Toggle(true),
                    ),
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

      await tester.tap(find.byIcon(FeatherIcons.chevronUp));
      await tester.pumpAndSettle();
      expect(find.text("Checklist"), findsOneWidget);
      expect(find.text("Item 1"), findsNothing);
      expect(find.text("Item 2"), findsNothing);
      expect(find.text("Item 3"), findsNothing);

      await tester.tap(find.byIcon(FeatherIcons.chevronDown));
      await tester.pumpAndSettle();
      expect(find.text("Checklist"), findsOneWidget);
      expect(find.text("Item 1"), findsOneWidget);
      expect(find.text("Item 2"), findsOneWidget);
      expect(find.text("Item 3"), findsOneWidget);
    });

    testWidgets("toggle items works correctly", (tester) async {
      ChecklistItem changedItem;
      bool checked;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DisplayChecklist(
              checklist: Checklist.test(
                id: UniqueId("checklist_id"),
                title: ChecklistTitle("Checklist"),
                items: IList.from(
                  [
                    ChecklistItem.test(
                      id: UniqueId("item_1"),
                      item: ItemText("Item 1"),
                      complete: Toggle(false),
                    ),
                    ChecklistItem.test(
                      id: UniqueId("item_2"),
                      item: ItemText("Item 2"),
                      complete: Toggle(false),
                    ),
                    ChecklistItem.test(
                      id: UniqueId("item_3"),
                      item: ItemText("Item 3"),
                      complete: Toggle(true),
                    ),
                  ],
                ),
              ),
              onItemChange: (item, toggle) {
                changedItem = item;
                checked = toggle.value.getOrNull();
              },
            ),
          ),
        ),
      );

      expect(find.text("Checklist"), findsOneWidget);
      expect(find.text("Item 1"), findsOneWidget);
      expect(find.text("Item 2"), findsOneWidget);
      expect(find.text("Item 3"), findsOneWidget);
      expect(find.byType(Checkbox), findsNWidgets(3));

      await tester.tap(find.byType(Checkbox).first);
      await tester.pumpAndSettle();
      expect(
        changedItem,
        equals(ChecklistItem.test(
          id: UniqueId("item_1"),
          item: ItemText("Item 1"),
          complete: Toggle(false),
        )),
      );
      expect(checked, isTrue);

      await tester.tap(find.byType(Checkbox).at(1));
      await tester.pumpAndSettle();
      expect(
        changedItem,
        equals(ChecklistItem.test(
          id: UniqueId("item_2"),
          item: ItemText("Item 2"),
          complete: Toggle(false),
        )),
      );
      expect(checked, isTrue);

      await tester.tap(find.byType(Checkbox).at(2));
      await tester.pumpAndSettle();
      expect(
        changedItem,
        equals(ChecklistItem.test(
          id: UniqueId("item_3"),
          item: ItemText("Item 3"),
          complete: Toggle(true),
        )),
      );
      expect(checked, isFalse);
    });

    test("get checklist progress returns the correct amount", () {
      final widget = DisplayChecklist(
        checklist: Checklist.test(
          id: UniqueId("checklist_id"),
          title: ChecklistTitle("Checklist"),
          items: IList.from(
            [
              ChecklistItem.test(
                id: UniqueId("item_1"),
                item: ItemText("Item 1"),
                complete: Toggle(false),
              ),
              ChecklistItem.test(
                id: UniqueId("item_2"),
                item: ItemText("Item 2"),
                complete: Toggle(false),
              ),
              ChecklistItem.test(
                id: UniqueId("item_3"),
                item: ItemText("Item 3"),
                complete: Toggle(true),
              ),
            ],
          ),
        ),
      );

      final percent =
          widget.createState().getChecklistProgress(widget.checklist.items);
      expect(percent, equals(1 / 3));
    });
  });
}
