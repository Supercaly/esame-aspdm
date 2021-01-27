import 'package:aspdm_project/core/maybe.dart';
import 'package:aspdm_project/domain/entities/checklist.dart';
import 'package:aspdm_project/domain/entities/label.dart';
import 'package:aspdm_project/domain/entities/task.dart';
import 'package:aspdm_project/domain/entities/user.dart';
import 'package:aspdm_project/domain/values/task_values.dart';
import 'package:aspdm_project/domain/values/unique_id.dart';
import 'package:aspdm_project/domain/values/user_values.dart';
import 'package:aspdm_project/presentation/misc/checklist_primitive.dart';
import 'package:aspdm_project/presentation/misc/task_primitive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("TaskPrimitive tests", () {
    test("empty creates a primitive correctly", () {
      final t1 = TaskPrimitive.empty();

      expect(t1.id, isNotNull);
      expect(t1.title, isNull);
      expect(t1.description, isNull);
      expect(t1.labels, isEmpty);
      expect(t1.members, isEmpty);
      expect(t1.checklists, isEmpty);
      expect(t1.expireDate.isNothing(), isTrue);
      expect(t1.author, isNull);
    });

    test("copyWith copies a primitive correctly", () {
      final t1 = TaskPrimitive(
        title: "title",
        description: "description",
        members: [],
        labels: [],
        checklists: [],
        expireDate: Maybe.nothing(),
        id: UniqueId("task_id"),
        author: null,
      );
      final t2 = t1.copyWith(title: "new title");
      final t3 = t1.copyWith(description: "new description");
      final t4 = t1.copyWith(members: [
        User(
          UniqueId("user1"),
          UserName("User 1"),
          EmailAddress("user1@email.com"),
          null,
        )
      ]);
      final t5 = t1.copyWith(labels: [
        Label(
          UniqueId("label"),
          Colors.red,
          "label",
        )
      ]);
      final t6 = t1.copyWith(checklists: [ChecklistPrimitive.empty()]);
      final t7 = t1.copyWith(
        expireDate: Maybe.just(DateTime.parse("2021-01-01")),
      );

      expect(t2.id, equals(t1.id));
      expect(t2.title, equals("new title"));
      expect(t2.description, equals(t1.description));
      expect(t2.labels, equals(t1.labels));
      expect(t2.members, equals(t1.members));
      expect(t2.checklists, equals(t1.checklists));
      expect(t2.expireDate, equals(t1.expireDate));
      expect(t2.author, equals(t1.author));

      expect(t3.id, equals(t1.id));
      expect(t3.title, equals(t1.title));
      expect(t3.description, equals("new description"));
      expect(t3.labels, equals(t1.labels));
      expect(t3.members, equals(t1.members));
      expect(t3.checklists, equals(t1.checklists));
      expect(t3.expireDate, equals(t1.expireDate));
      expect(t3.author, equals(t1.author));

      expect(t4.id, equals(t1.id));
      expect(t4.title, equals(t1.title));
      expect(t4.description, equals(t1.description));
      expect(t4.labels, equals(t1.labels));
      expect(
        t4.members,
        equals([
          User(
            UniqueId("user1"),
            UserName("User 1"),
            EmailAddress("user1@email.com"),
            null,
          )
        ]),
      );
      expect(t4.checklists, equals(t1.checklists));
      expect(t4.expireDate, equals(t1.expireDate));
      expect(t4.author, equals(t1.author));

      expect(t5.id, equals(t1.id));
      expect(t5.title, equals(t1.title));
      expect(t5.description, equals(t1.description));
      expect(
        t5.labels,
        equals([
          Label(
            UniqueId("label"),
            Colors.red,
            "label",
          )
        ]),
      );
      expect(t5.members, equals(t1.members));
      expect(t5.checklists, equals(t1.checklists));
      expect(t5.expireDate, equals(t1.expireDate));
      expect(t5.author, equals(t1.author));

      expect(t6.id, equals(t1.id));
      expect(t6.title, equals(t1.title));
      expect(t6.description, equals(t1.description));
      expect(t6.labels, equals(t1.labels));
      expect(t6.members, equals(t1.members));
      expect(t6.checklists, equals([ChecklistPrimitive.empty()]));
      expect(t6.expireDate, equals(t1.expireDate));
      expect(t6.author, equals(t1.author));

      expect(t7.id, equals(t1.id));
      expect(t7.title, equals(t1.title));
      expect(t7.description, equals(t1.description));
      expect(t7.labels, equals(t1.labels));
      expect(t7.members, equals(t1.members));
      expect(t7.checklists, equals(t1.checklists));
      expect(t7.expireDate, equals(Maybe.just(DateTime.parse("2021-01-01"))));
      expect(t7.author, equals(t1.author));
    });

    test("from task creates a primitive correctly", () {
      final tk = Task(
        UniqueId("task_id"),
        TaskTitle("title"),
        TaskDescription("description"),
        [
          Label(UniqueId("label"), Colors.red, "label"),
        ],
        User(
          UniqueId("user_id"),
          UserName("user 1"),
          EmailAddress("user1@email.com"),
          null,
        ),
        [
          User(
            UniqueId("user_id_2"),
            UserName("user 2"),
            EmailAddress("user2@email.com"),
            null,
          ),
        ],
        DateTime.parse("2021-01-01"),
        [
          Checklist(
            UniqueId("checklist_id"),
            ChecklistTitle("Checklist 1"),
            [
              ChecklistItem(
                UniqueId("item_1"),
                ItemText("Item 1"),
                Toggle(true),
              ),
            ],
          ),
        ],
        [],
        Toggle(false),
        DateTime.parse("2020-12-30"),
      );

      final t1 = TaskPrimitive.fromTask(tk);
      expect(t1.id.value.getOrNull(), equals("task_id"));
      expect(t1.title, "title");
      expect(t1.description, "description");
      expect(t1.labels, hasLength(1));
      expect(
        t1.labels[0],
        equals(Label(UniqueId("label"), Colors.red, "label")),
      );
      expect(t1.members, hasLength(1));
      expect(
        t1.members[0],
        equals(User(
          UniqueId("user_id_2"),
          UserName("user 2"),
          EmailAddress("user2@email.com"),
          null,
        )),
      );
      expect(t1.checklists, hasLength(1));
      expect(
        t1.checklists[0],
        equals(ChecklistPrimitive(
          title: "Checklist 1",
          items: [ItemText("Item 1")],
        )),
      );
      expect(t1.expireDate.isJust(), isTrue);
      expect(t1.expireDate.getOrNull(), equals(DateTime.parse("2021-01-01")));
      expect(
        t1.author,
        equals(User(
          UniqueId("user_id"),
          UserName("user 1"),
          EmailAddress("user1@email.com"),
          null,
        )),
      );
    });

    test("to task creates a task correctly", () {
      final t1 = TaskPrimitive(
        id: UniqueId("task_id"),
        title: "title",
        description: "description",
        expireDate: Maybe.just(DateTime.parse("2021-01-01")),
        labels: [Label(UniqueId("label"), Colors.red, "label")],
        members: [
          User(
            UniqueId("user_id_2"),
            UserName("user 2"),
            EmailAddress("user2@email.com"),
            null,
          ),
        ],
        checklists: [
          ChecklistPrimitive(
            title: "Checklist 1",
            items: [ItemText("Item 1")],
          ),
        ],
        author: User(
          UniqueId("user_id"),
          UserName("user 1"),
          EmailAddress("user1@email.com"),
          null,
        ),
      );

      final tk = t1.toTask();

      Task(
        UniqueId("task_id"),
        TaskTitle("title"),
        TaskDescription("description"),
        [
          Label(UniqueId("label"), Colors.red, "label"),
        ],
        User(
          UniqueId("user_id"),
          UserName("user 1"),
          EmailAddress("user1@email.com"),
          null,
        ),
        [
          User(
            UniqueId("user_id_2"),
            UserName("user 2"),
            EmailAddress("user2@email.com"),
            null,
          ),
        ],
        DateTime.parse("2021-01-01"),
        [
          Checklist(
            UniqueId("checklist_id"),
            ChecklistTitle("Checklist 1"),
            [
              ChecklistItem(
                UniqueId("item_1"),
                ItemText("Item 1"),
                Toggle(true),
              ),
            ],
          ),
        ],
        [],
        Toggle(false),
        DateTime.parse("2020-12-30"),
      );

      expect(tk.id, equals(t1.id));
      expect(tk.title.value.isRight(), isTrue);
      expect(tk.title.value.getOrNull(), "title");
      expect(tk.description.value.isRight(), isTrue);
      expect(tk.description.value.getOrNull(), "description");
      expect(tk.labels, hasLength(1));
      expect(
        tk.labels[0],
        equals(Label(UniqueId("label"), Colors.red, "label")),
      );
      expect(tk.members, hasLength(1));
      expect(
        tk.members[0],
        equals(User(
          UniqueId("user_id_2"),
          UserName("user 2"),
          EmailAddress("user2@email.com"),
          null,
        )),
      );
      expect(tk.checklists, hasLength(1));
      expect(
        tk.checklists[0],
        equals(Checklist(
          UniqueId.empty(),
          ChecklistTitle("Checklist 1"),
          [
            ChecklistItem(
              UniqueId.empty(),
              ItemText("Item 1"),
              Toggle(false),
            )
          ],
        )),
      );
      expect(tk.expireDate, isNotNull);
      expect(tk.expireDate, equals(DateTime.parse("2021-01-01")));
      expect(
        tk.author,
        equals(User(
          UniqueId("user_id"),
          UserName("user 1"),
          EmailAddress("user1@email.com"),
          null,
        )),
      );
    });

    test("equality works correctly", () {
      final c1 = TaskPrimitive(
        id: UniqueId("task_id"),
        title: "title",
        description: "description",
        expireDate: Maybe.just(DateTime.parse("2021-01-01")),
        labels: [Label(UniqueId("label"), Colors.red, "label")],
        members: [
          User(
            UniqueId("user_id_2"),
            UserName("user 2"),
            EmailAddress("user2@email.com"),
            null,
          ),
        ],
        checklists: [
          ChecklistPrimitive(
            title: "Checklist 1",
            items: [ItemText("Item 1")],
          ),
        ],
        author: User(
          UniqueId("user_id"),
          UserName("user 1"),
          EmailAddress("user1@email.com"),
          null,
        ),
      );
      final c2 = TaskPrimitive(
        id: UniqueId("task_id"),
        title: "title",
        description: "description",
        expireDate: Maybe.just(DateTime.parse("2021-01-01")),
        labels: [Label(UniqueId("label"), Colors.red, "label")],
        members: [
          User(
            UniqueId("user_id_2"),
            UserName("user 2"),
            EmailAddress("user2@email.com"),
            null,
          ),
        ],
        checklists: [
          ChecklistPrimitive(
            title: "Checklist 1",
            items: [ItemText("Item 1")],
          ),
        ],
        author: User(
          UniqueId("user_id"),
          UserName("user 1"),
          EmailAddress("user1@email.com"),
          null,
        ),
      );
      final c3 = TaskPrimitive.empty();

      expect(c1 == c2, isTrue);
      expect(c2 == c1, isTrue);
      expect(c1 == c3, isFalse);
      expect(c2 == c3, isFalse);
    });

    test("to string return the correct representation", () {
      expect(
        TaskPrimitive(
          id: UniqueId("task_id"),
          title: "title",
          description: "description",
          expireDate: Maybe.just(DateTime.parse("2021-01-01")),
          labels: [Label(UniqueId("label"), Colors.red, "label")],
          members: [
            User(
              UniqueId("user_id_2"),
              UserName("user 2"),
              EmailAddress("user2@email.com"),
              null,
            ),
          ],
          checklists: [
            ChecklistPrimitive(
              title: "Checklist 1",
              items: [ItemText("Item 1")],
            ),
          ],
          author: User(
            UniqueId("user_id"),
            UserName("user 1"),
            EmailAddress("user1@email.com"),
            null,
          ),
        ).toString(),
        equals("TaskPrimitive{"
            "id: UniqueId(task_id), "
            "title: title, "
            "description: description, "
            "expireDate: Just(2021-01-01 00:00:00.000), "
            "labels: [Label{id: UniqueId(label), color: MaterialColor(primary value: Color(0xfff44336)), label: label}], "
            "members: [User {id: UniqueId(user_id_2), name: UserName(user 2), email: EmailAddress(user2@email.com), profileColor: null], "
            "checklists: [ChecklistPrimitive{title: Checklist 1, items: [ItemText(Item 1)]}], "
            "author: User {id: UniqueId(user_id), name: UserName(user 1), email: EmailAddress(user1@email.com), profileColor: null}"),
      );
    });
  });
}