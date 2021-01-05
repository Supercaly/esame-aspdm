import 'package:aspdm_project/domain/entities/checklist.dart';
import 'package:aspdm_project/domain/entities/comment.dart';
import 'package:aspdm_project/domain/entities/label.dart';
import 'package:aspdm_project/domain/entities/task.dart';
import 'package:aspdm_project/domain/entities/user.dart';
import 'package:aspdm_project/domain/values/comment_content.dart';
import 'package:aspdm_project/domain/values/email_address.dart';
import 'package:aspdm_project/domain/values/item_text.dart';
import 'package:aspdm_project/domain/values/task_description.dart';
import 'package:aspdm_project/domain/values/task_title.dart';
import 'package:aspdm_project/domain/values/toggle.dart';
import 'package:aspdm_project/domain/values/unique_id.dart';
import 'package:aspdm_project/domain/values/user_name.dart';
import 'package:aspdm_project/services/navigation_service.dart';
import 'package:aspdm_project/presentation/widgets/label_widget.dart';
import 'package:aspdm_project/presentation/widgets/task_card.dart';
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
              [
                Label(UniqueId("mock_id"), Colors.red, "label"),
                Label(UniqueId("mock_id"), Colors.blue, "label"),
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
              UniqueId("mock_id"),
              TaskTitle("mock title"),
              TaskDescription("mock description"),
              [
                Label(UniqueId("mock_id"), Colors.red, "label"),
                Label(UniqueId("mock_id"), Colors.blue, "label"),
              ],
              null,
              [
                User(
                  UniqueId("mock_user"),
                  UserName("Mock User"),
                  EmailAddress("mock.user@email.com"),
                  null,
                )
              ],
              DateTime.now(),
              [
                Checklist(
                  UniqueId("mock_id"),
                  ItemText("checklist1"),
                  [
                    ChecklistItem(
                        UniqueId("mock_id"), ItemText("item"), Toggle(false)),
                    ChecklistItem(
                        UniqueId("mock_id"), ItemText("item"), Toggle(true)),
                    ChecklistItem(
                        UniqueId("mock_id"), ItemText("item"), Toggle(false)),
                    ChecklistItem(
                        UniqueId("mock_id"), ItemText("item"), Toggle(true)),
                  ],
                ),
                Checklist(
                  UniqueId("mock_id"),
                  ItemText("checklist1"),
                  [
                    ChecklistItem(
                        UniqueId("mock_id"), ItemText("item"), Toggle(false)),
                    ChecklistItem(
                        UniqueId("mock_id"), ItemText("item"), Toggle(true)),
                    ChecklistItem(
                        UniqueId("mock_id"), ItemText("item"), Toggle(false)),
                  ],
                ),
              ],
              [
                Comment(
                  UniqueId("c1"),
                  CommentContent("comment 1"),
                  User(
                    UniqueId("mock_user"),
                    UserName("Mock User"),
                    EmailAddress("mock.user@email.com"),
                    null,
                  ),
                  [],
                  [],
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
                  [],
                  [],
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
                  [],
                  [],
                  DateTime.now(),
                ),
              ],
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
