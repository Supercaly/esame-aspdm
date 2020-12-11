import 'package:aspdm_project/model/checklist.dart';
import 'package:aspdm_project/model/comment.dart';
import 'package:aspdm_project/model/label.dart';
import 'package:aspdm_project/model/task.dart';
import 'package:aspdm_project/model/user.dart';
import 'package:aspdm_project/widgets/label_widget.dart';
import 'package:aspdm_project/widgets/task_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets("task with nothing but title displayed correctly",
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: TaskCard(
            task: Task(
              id: "mock_id",
              title: "mock title",
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text("mock title"), findsOneWidget);
  });

  testWidgets("task with labels displayed correctly", (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: TaskCard(
            task: Task(
              id: "mock_id",
              title: "mock title",
              labels: [
                Label(Colors.red, "label"),
                Label(Colors.blue, "label"),
              ],
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text("mock title"), findsOneWidget);
    expect(find.byType(LabelWidget), findsNWidgets(2));
  });

  testWidgets("task with all fields displayed correctly", (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: TaskCard(
            task: Task(
              id: "mock_id",
              title: "mock title",
              description: "mock description",
              labels: [
                Label(Colors.red, "label"),
                Label(Colors.blue, "label"),
              ],
              checklists: [
                Checklist(
                  "checklist1",
                  [
                    ChecklistItem("item", false),
                    ChecklistItem("item", true),
                    ChecklistItem("item", false),
                    ChecklistItem("item", true),
                  ],
                ),
                Checklist(
                  "checklist1",
                  [
                    ChecklistItem("item", false),
                    ChecklistItem("item", true),
                    ChecklistItem("item", false),
                  ],
                ),
              ],
              members: [
                User(
                  "mock_user",
                  "Mock User",
                  "mock.user@email.com",
                  null,
                )
              ],
              expireDate: DateTime.now(),
              comments: [
                Comment(
                  "c1",
                  "comment 1",
                  User(
                    "mock_user",
                    "Mock User",
                    "mock.user@email.com",
                    null,
                  ),
                  0,
                  0,
                  DateTime.now(),
                  false,
                  false,
                ),
                Comment(
                  "c2",
                  "comment 2",
                  User(
                    "mock_user",
                    "Mock User",
                    "mock.user@email.com",
                    null,
                  ),
                  0,
                  0,
                  DateTime.now(),
                  false,
                  false,
                ),
                Comment(
                  "c3",
                  "comment 3",
                  User(
                    "mock_user",
                    "Mock User",
                    "mock.user@email.com",
                    null,
                  ),
                  0,
                  0,
                  DateTime.now(),
                  false,
                  false,
                ),
              ],
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text("mock title"), findsOneWidget);
    expect(find.byType(LabelWidget), findsNWidgets(2));
    expect(find.byIcon(Icons.format_align_left), findsOneWidget);
    expect(find.byIcon(Icons.check_circle), findsOneWidget);
    expect(find.text("3/7"), findsOneWidget);
    expect(find.byIcon(Icons.message), findsOneWidget);
    expect(find.text("3"), findsOneWidget);
    expect(find.byIcon(Icons.person), findsOneWidget);
    expect(find.text("1"), findsOneWidget);
  });

  test("create task with null arguments throws an error", () {
    try {
      TaskCard(task: null);
      fail("This should throw an error!");
    } catch (e) {
      expect(e, isA<AssertionError>());
    }

    try {
      TaskCard(task: Task());
      fail("This should throw an error!");
    } catch (e) {
      expect(e, isA<AssertionError>());
    }
  });
}
