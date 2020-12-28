import 'package:aspdm_project/model/checklist.dart';
import 'package:aspdm_project/model/comment.dart';
import 'package:aspdm_project/model/label.dart';
import 'package:aspdm_project/model/task.dart';
import 'package:aspdm_project/model/user.dart';
import 'package:aspdm_project/services/navigation_service.dart';
import 'package:aspdm_project/widgets/label_widget.dart';
import 'package:aspdm_project/widgets/task_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/mockito.dart';

import '../mocks/mock_navigation_service.dart';

void main() {
  testWidgets("task with nothing but title displayed correctly",
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: TaskCard(
            task: Task(
              "mock_id",
              "mock title",
              null,
              null,
              null,
              null,
              null,
              null,
              null,
              null,
              null,
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
              "mock_id",
              "mock title",
              null,
              [
                Label("mock_id", Colors.red, "label"),
                Label("mock_id", Colors.blue, "label"),
              ],
              null,
              null,
              null,
              null,
              null,
              null,
              null,
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
              "mock_id",
              "mock title",
              "mock description",
              [
                Label("mock_id", Colors.red, "label"),
                Label("mock_id", Colors.blue, "label"),
              ],
              null,
              [
                User(
                  "mock_user",
                  "Mock User",
                  "mock.user@email.com",
                  null,
                )
              ],
              DateTime.now(),
              [
                Checklist(
                  "mock_id",
                  "checklist1",
                  [
                    ChecklistItem("mock_id", "item", false),
                    ChecklistItem("mock_id", "item", true),
                    ChecklistItem("mock_id", "item", false),
                    ChecklistItem("mock_id", "item", true),
                  ],
                ),
                Checklist(
                  "mock_id",
                  "checklist1",
                  [
                    ChecklistItem("mock_id", "item", false),
                    ChecklistItem("mock_id", "item", true),
                    ChecklistItem("mock_id", "item", false),
                  ],
                ),
              ],
              [
                Comment(
                  "c1",
                  "comment 1",
                  User(
                    "mock_user",
                    "Mock User",
                    "mock.user@email.com",
                    null,
                  ),
                  [],
                  [],
                  DateTime.now(),
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
                  [],
                  [],
                  DateTime.now(),
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
                  [],
                  [],
                  DateTime.now(),
                ),
              ],
              false,
              null,
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text("mock title"), findsOneWidget);
    expect(find.byType(LabelWidget), findsNWidgets(2));
    expect(find.byIcon(FeatherIcons.alignLeft), findsOneWidget);
    expect(find.byIcon(FeatherIcons.checkCircle), findsOneWidget);
    expect(find.text("3/7"), findsOneWidget);
    expect(find.byIcon(FeatherIcons.messageSquare), findsOneWidget);
    expect(find.text("3"), findsOneWidget);
    expect(find.byIcon(FeatherIcons.users), findsOneWidget);
    expect(find.text("1"), findsOneWidget);
  });

  testWidgets("pressing on card navigates to route", (tester) async {
    final navService = MockNavigationService();
    when(navService.navigateTo(any, arguments: anyNamed("arguments")))
        .thenAnswer((_) => null);
    GetIt.I.registerSingleton<NavigationService>(navService);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: TaskCard(
            task: Task(
              "mock_id",
              "mock title",
              null,
              null,
              null,
              null,
              null,
              null,
              null,
              null,
              null,
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byType(Card));
    await tester.pumpAndSettle();

    verify(navService.navigateTo(any, arguments: anyNamed("arguments")))
        .called(1);
  });

  test("create task with null arguments throws an error", () {
    try {
      TaskCard(task: null);
      fail("This should throw an error!");
    } catch (e) {
      expect(e, isA<AssertionError>());
    }

    try {
      TaskCard(
        task: Task(
          null,
          null,
          null,
          null,
          null,
          null,
          null,
          null,
          null,
          null,
          null,
        ),
      );
      fail("This should throw an error!");
    } catch (e) {
      expect(e, isA<AssertionError>());
    }
  });
}
