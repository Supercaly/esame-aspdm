import 'package:tasky/core/ilist.dart';
import 'package:tasky/core/maybe.dart';
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
import 'package:tasky/presentation/pages/task_list/widgets/task_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/mockito.dart';

import '../../../../mocks/mock_navigation_service.dart';

void main() {
  testWidgets("task with nothing but title displayed correctly",
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: TaskCard(
            task: Task.test(
              id: UniqueId("mock_id"),
              title: TaskTitle("mock title"),
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
            task: Task.test(
              id: UniqueId("mock_id"),
              title: TaskTitle("mock title"),
              labels: IList.from([
                Label.test(
                  id: UniqueId("mock_id"),
                  color: LabelColor(Colors.red),
                  label: LabelName("label"),
                ),
                Label.test(
                  id: UniqueId("mock_id"),
                  color: LabelColor(Colors.blue),
                  label: LabelName("label"),
                ),
              ]),
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
            task: Task.test(
              id: UniqueId("mock_id"),
              title: TaskTitle("mock title"),
              description: TaskDescription("mock description"),
              labels: IList.from([
                Label.test(
                  id: UniqueId("mock_id"),
                  color: LabelColor(Colors.red),
                  label: LabelName("label"),
                ),
                Label.test(
                  id: UniqueId("mock_id"),
                  color: LabelColor(Colors.blue),
                  label: LabelName("label"),
                ),
              ]),
              members: IList.from([
                User.test(
                  id: UniqueId("mock_user"),
                  name: UserName("Mock User"),
                  email: EmailAddress("mock.user@email.com"),
                )
              ]),
              expireDate: Maybe.just(ExpireDate(DateTime.now())),
              checklists: IList.from([
                Checklist.test(
                  id: UniqueId("mock_id"),
                  title: ChecklistTitle("checklist1"),
                  items: IList.from([
                    ChecklistItem.test(
                      id: UniqueId("mock_id"),
                      item: ItemText("item"),
                      complete: Toggle(false),
                    ),
                    ChecklistItem.test(
                      id: UniqueId("mock_id"),
                      item: ItemText("item"),
                      complete: Toggle(true),
                    ),
                    ChecklistItem.test(
                      id: UniqueId("mock_id"),
                      item: ItemText("item"),
                      complete: Toggle(false),
                    ),
                    ChecklistItem.test(
                      id: UniqueId("mock_id"),
                      item: ItemText("item"),
                      complete: Toggle(true),
                    ),
                  ]),
                ),
                Checklist.test(
                  id: UniqueId("mock_id"),
                  title: ChecklistTitle("checklist1"),
                  items: IList.from([
                    ChecklistItem.test(
                      id: UniqueId("mock_id"),
                      item: ItemText("item"),
                      complete: Toggle(false),
                    ),
                    ChecklistItem.test(
                      id: UniqueId("mock_id"),
                      item: ItemText("item"),
                      complete: Toggle(true),
                    ),
                    ChecklistItem.test(
                      id: UniqueId("mock_id"),
                      item: ItemText("item"),
                      complete: Toggle(false),
                    ),
                  ]),
                ),
              ]),
              comments: IList.from([
                Comment.test(
                  id: UniqueId("c1"),
                  content: CommentContent("comment 1"),
                  author: User.test(
                    id: UniqueId("mock_user"),
                    name: UserName("Mock User"),
                    email: EmailAddress("mock.user@email.com"),
                  ),
                  likes: IList.empty(),
                  dislikes: IList.empty(),
                  creationDate: CreationDate(DateTime.now()),
                ),
                Comment.test(
                  id: UniqueId("c2"),
                  content: CommentContent("comment 2"),
                  author: User.test(
                    id: UniqueId("mock_user"),
                    name: UserName("Mock User"),
                    email: EmailAddress("mock.user@email.com"),
                  ),
                  likes: IList.empty(),
                  dislikes: IList.empty(),
                  creationDate: CreationDate(DateTime.now()),
                ),
                Comment.test(
                  id: UniqueId("c3"),
                  content: CommentContent("comment 3"),
                  author: User.test(
                    id: UniqueId("mock_user"),
                    name: UserName("Mock User"),
                    email: EmailAddress("mock.user@email.com"),
                  ),
                  likes: IList.empty(),
                  dislikes: IList.empty(),
                  creationDate: CreationDate(DateTime.now()),
                ),
              ]),
              archived: Toggle(false),
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
            task: Task.test(
              id: UniqueId("mock_id"),
              title: TaskTitle("mock title"),
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
