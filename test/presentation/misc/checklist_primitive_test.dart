import 'package:aspdm_project/domain/entities/checklist.dart';
import 'package:aspdm_project/domain/values/task_values.dart';
import 'package:aspdm_project/domain/values/unique_id.dart';
import 'package:aspdm_project/presentation/misc/checklist_primitive.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("ChecklistPrimitive tests", () {
    test("empty creates a primitive correctly", () {
      final c1 = ChecklistPrimitive.empty();

      expect(c1.title, isNull);
      expect(c1.items, isEmpty);
    });

    test("copyWith copies a primitive correctly", () {
      final c1 = ChecklistPrimitive(
        title: "title",
        items: [
          ItemText("item 1"),
          ItemText("item 2"),
        ],
      );
      final c2 = c1.copyWith(title: "new title");
      final c3 = c1.copyWith(items: [ItemText("item 1")]);

      expect(c2.title, equals("new title"));
      expect(c2.items, equals(c1.items));
      expect(c3.title, equals(c1.title));
      expect(c3.items, equals([ItemText("item 1")]));
    });

    test("from checklist creates a primitive correctly", () {
      final ck = Checklist(
        UniqueId("checklist_id"),
        ChecklistTitle("Checklist 1"),
        [
          ChecklistItem(
            UniqueId("item_1"),
            ItemText("item 1"),
            Toggle(false),
          ),
          ChecklistItem(
            UniqueId("item_2"),
            ItemText("item 2"),
            Toggle(true),
          )
        ],
      );
      final c1 = ChecklistPrimitive.fromChecklist(ck);

      expect(c1.title, isNotEmpty);
      expect(c1.title, equals("Checklist 1"));
      expect(c1.items, hasLength(2));
      expect(
        c1.items,
        equals([
          ItemText("item 1"),
          ItemText("item 2"),
        ]),
      );
    });

    test("to checklist creates a checklist correctly", () {
      final c1 = ChecklistPrimitive(
        title: "Checklist 1",
        items: [
          ItemText("item 1"),
          ItemText("item 2"),
        ],
      );
      final ck = c1.toChecklist();

      expect(ck.title.value.isRight(), isTrue);
      expect(ck.title.value.getOrNull(), equals("Checklist 1"));
      expect(ck.items, hasLength(2));
      expect(
        ck.items,
        equals([
          ChecklistItem(UniqueId.empty(), ItemText("item 1"), Toggle(false)),
          ChecklistItem(UniqueId.empty(), ItemText("item 2"), Toggle(false)),
        ]),
      );
    });

    test("equality works correctly", () {
      final c1 = ChecklistPrimitive(
        title: "Checklist 1",
        items: [ItemText("Item 1")],
      );
      final c2 = ChecklistPrimitive(
        title: "Checklist 1",
        items: [ItemText("Item 1")],
      );
      final c3 = ChecklistPrimitive(
        title: "Checklist 2",
        items: [ItemText("Item 1")],
      );

      expect(c1 == c2, isTrue);
      expect(c2 == c1, isTrue);
      expect(c1 == c3, isFalse);
      expect(c2 == c3, isFalse);
    });

    test("to string return the correct representation", () {
      expect(
          ChecklistPrimitive(
            title: "Checklist 1",
            items: [ItemText("Item 1")],
          ).toString(),
          equals(
              "ChecklistPrimitive{title: Checklist 1, items: [ItemText(Item 1)]}"));
    });
  });
}
