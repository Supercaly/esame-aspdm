import 'package:tasky/core/ilist.dart';
import 'package:tasky/domain/entities/checklist.dart';
import 'package:tasky/domain/entities/comment.dart';
import 'package:tasky/domain/entities/label.dart';
import 'package:tasky/domain/entities/task.dart';
import 'package:tasky/domain/entities/user.dart';
import 'package:tasky/domain/values/label_values.dart';
import 'package:tasky/domain/values/task_values.dart';
import 'package:tasky/domain/values/unique_id.dart';
import 'package:tasky/domain/values/user_values.dart';
import 'package:tasky/services/navigation_service.dart';
import 'package:tasky/presentation/widgets/label_widget.dart';
import 'package:tasky/presentation/widgets/task_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/mockito.dart';

import '../../mocks/mock_navigation_service.dart';

void main() {
  testWidgets("task with nothing but title displayed correctly",
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: TaskCard(
            task: Task(
              UniqueId("mock_id"),
              TaskTitle("mock title"),
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
              UniqueId("mock_id"),
              TaskTitle("mock title"),
              null,
              IList.from([
                Label(UniqueId("mock_id"), Colors.red, LabelName("label")),
                Label(UniqueId("mock_id"), Colors.blue, LabelName("label")),
              ]),
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
              UniqueId("mock_id"),
              TaskTitle("mock title"),
              TaskDescription("mock description"),
              IList.from([
                Label(UniqueId("mock_id"), Colors.red, LabelName("label")),
                Label(UniqueId("mock_id"), Colors.blue, LabelName("label")),
              ]),
              null,
              IList.from([
                User(
                  UniqueId("mock_user"),
                  UserName("Mock User"),
                  EmailAddress("mock.user@email.com"),
                  null,
                )
              ]),
              DateTime.now(),
              IList.from([
                Checklist(
                  UniqueId("mock_id"),
                  ChecklistTitle("checklist1"),
                  IList.from([
                    ChecklistItem(
                        UniqueId("mock_id"), ItemText("item"), Toggle(false)),
                    ChecklistItem(
                        UniqueId("mock_id"), ItemText("item"), Toggle(true)),
                    ChecklistItem(
                        UniqueId("mock_id"), ItemText("item"), Toggle(false)),
                    ChecklistItem(
                        UniqueId("mock_id"), ItemText("item"), Toggle(true)),
                  ]),
                ),
                Checklist(
                  UniqueId("mock_id"),
                  ChecklistTitle("checklist1"),
                  IList.from([
                    ChecklistItem(
                        UniqueId("mock_id"), ItemText("item"), Toggle(false)),
                    ChecklistItem(
                        UniqueId("mock_id"), ItemText("item"), Toggle(true)),
                    ChecklistItem(
                        UniqueId("mock_id"), ItemText("item"), Toggle(false)),
                  ]),
                ),
              ]),
              IList.from([
                Comment(
                  UniqueId("c1"),
                  CommentContent("comment 1"),
                  User(
                    UniqueId("mock_user"),
                    UserName("Mock User"),
                    EmailAddress("mock.user@email.com"),
                    null,
                  ),
                  IList.empty(),
                  IList.empty(),
                  DateTime.now(),
                ),
                Comment(
                  UniqueId("c2"),
                  CommentContent("comment 2"),
                  User(
                    UniqueId("mock_user"),
                    UserName("Mock User"),
                    EmailAddress("mock.user@email.com"),
                    null,
                  ),
                  IList.empty(),
                  IList.empty(),
                  DateTime.now(),
                ),
                Comment(
                  UniqueId("c3"),
                  CommentContent("comment 3"),
                  User(
                    UniqueId("mock_user"),
                    UserName("Mock User"),
                    EmailAddress("mock.user@email.com"),
                    null,
                  ),
                  IList.empty(),
                  IList.empty(),
                  DateTime.now(),
                ),
              ]),
              Toggle(false),
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
              UniqueId("mock_id"),
              TaskTitle("mock title"),
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
  });
}
