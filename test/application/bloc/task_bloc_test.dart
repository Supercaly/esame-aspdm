import 'package:aspdm_project/application/bloc/task_bloc.dart';
import 'package:aspdm_project/core/either.dart';
import 'package:aspdm_project/domain/failures/server_failure.dart';
import 'package:aspdm_project/domain/values/task_values.dart';
import 'package:aspdm_project/domain/values/unique_id.dart';
import 'package:aspdm_project/domain/entities/task.dart';
import 'package:aspdm_project/domain/repositories/task_repository.dart';
import 'package:aspdm_project/services/log_service.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/mockito.dart';

import '../../mocks/mock_log_service.dart';

class MockTaskRepository extends Mock implements TaskRepository {}

void main() {
  group("TaskBloc Tests", () {
    TaskRepository repository;

    setUp(() {
      repository = MockTaskRepository();
    });

    setUpAll(() {
      GetIt.I.registerLazySingleton<LogService>(() => MockLogService());
    });

    blocTest(
      "emits nothing when created",
      build: () => TaskBloc(UniqueId("mock_id"), repository),
      expect: [],
    );

    blocTest("emits data on fetch success",
        build: () => TaskBloc(UniqueId("mock_id"), repository),
        act: (TaskBloc bloc) {
          when(repository.getTask(any)).thenAnswer(
            (_) => Future.value(
              Either.right(
                Task(
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
          );
          bloc.fetch();
        },
        expect: [
          TaskState.loading(null),
          TaskState.data(Task(
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
          )),
        ]);

    blocTest(
      "emits error on fetch error",
      build: () => TaskBloc(UniqueId("mock_id"), repository),
      act: (TaskBloc bloc) {
        when(repository.getTask(any)).thenAnswer((_) =>
            Future.value(Either.left(ServerFailure.unexpectedError(""))));
        bloc.fetch();
      },
      expect: [
        TaskState.loading(null),
        TaskState.error(null),
      ],
    );

    blocTest(
      "don't emits loading when fetch has showLoading false",
      build: () => TaskBloc(UniqueId("mock_id"), repository),
      act: (TaskBloc bloc) {
        when(repository.getTask(any)).thenAnswer(
          (_) => Future.value(
            Either.right(
              Task(
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
        );
        bloc.fetch(showLoading: false);
      },
      expect: [
        TaskState.data(Task(
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
        )),
      ],
    );

    blocTest("emits data on comment delete success",
        build: () => TaskBloc(UniqueId("mock_id"), repository),
        act: (TaskBloc bloc) {
          when(repository.deleteComment(any, any, any)).thenAnswer(
            (_) => Future.value(
              Either.right(
                Task(
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
          );
          bloc.deleteComment(UniqueId("commentId"), UniqueId("userId"));
        },
        expect: [
          TaskState.data(Task(
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
          )),
        ]);

    blocTest("emits error on comment delete error",
        build: () => TaskBloc(UniqueId("mock_id"), repository),
        act: (TaskBloc bloc) {
          when(repository.deleteComment(any, any, any)).thenAnswer((_) =>
              Future.value(Either.left(ServerFailure.unexpectedError(""))));
          bloc.deleteComment(UniqueId("commentId"), UniqueId("userId"));
        },
        expect: [
          TaskState.error(null),
        ]);

    blocTest("emits data on comment edit success",
        build: () => TaskBloc(UniqueId("mock_id"), repository),
        act: (TaskBloc bloc) {
          when(repository.editComment(any, any, any, any)).thenAnswer(
            (_) => Future.value(
              Either.right(
                Task(
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
          );
          bloc.editComment(UniqueId("commentId"), CommentContent("newContent"),
              UniqueId("userId"));
        },
        expect: [
          TaskState.data(Task(
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
          )),
        ]);

    blocTest("emits error on comment edit error",
        build: () => TaskBloc(UniqueId("mock_id"), repository),
        act: (TaskBloc bloc) {
          when(repository.editComment(any, any, any, any)).thenAnswer((_) =>
              Future.value(Either.left(ServerFailure.unexpectedError(""))));
          bloc.editComment(UniqueId("commentId"), CommentContent("newContent"),
              UniqueId("userId"));
        },
        expect: [
          TaskState.error(null),
        ]);

    blocTest("emits data on comment like success",
        build: () => TaskBloc(UniqueId("mock_id"), repository),
        act: (TaskBloc bloc) {
          when(repository.likeComment(any, any, any)).thenAnswer(
            (_) => Future.value(
              Either.right(
                Task(
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
          );
          bloc.likeComment(UniqueId("commentId"), UniqueId("userId"));
        },
        expect: [
          TaskState.data(Task(
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
          )),
        ]);

    blocTest("emits error on comment like error",
        build: () => TaskBloc(UniqueId("mock_id"), repository),
        act: (TaskBloc bloc) {
          when(repository.likeComment(any, any, any)).thenAnswer((_) =>
              Future.value(Either.left(ServerFailure.unexpectedError(""))));
          bloc.likeComment(UniqueId("commentId"), UniqueId("userId"));
        },
        expect: [
          TaskState.error(null),
        ]);

    blocTest("emits data on comment dislike success",
        build: () => TaskBloc(UniqueId("mock_id"), repository),
        act: (TaskBloc bloc) {
          when(repository.dislikeComment(any, any, any)).thenAnswer(
            (_) => Future.value(
              Either.right(
                Task(
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
          );
          bloc.dislikeComment(UniqueId("commentId"), UniqueId("userId"));
        },
        expect: [
          TaskState.data(Task(
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
          )),
        ]);

    blocTest("emits error on comment dislike error",
        build: () => TaskBloc(UniqueId("mock_id"), repository),
        act: (TaskBloc bloc) {
          when(repository.dislikeComment(any, any, any)).thenAnswer((_) =>
              Future.value(Either.left(ServerFailure.unexpectedError(""))));
          bloc.dislikeComment(UniqueId("commentId"), UniqueId("userId"));
        },
        expect: [
          TaskState.error(null),
        ]);

    blocTest("emits data on add comment success",
        build: () => TaskBloc(UniqueId("mock_id"), repository),
        act: (TaskBloc bloc) {
          when(repository.addComment(any, any, any)).thenAnswer(
            (_) => Future.value(
              Either.right(
                Task(
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
          );
          bloc.addComment(CommentContent("content"), UniqueId("userId"));
        },
        expect: [
          TaskState.data(Task(
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
          )),
        ]);

    blocTest("emits error on add comment error",
        build: () => TaskBloc(UniqueId("mock_id"), repository),
        act: (TaskBloc bloc) {
          when(repository.addComment(any, any, any)).thenAnswer((_) =>
              Future.value(Either.left(ServerFailure.unexpectedError(""))));
          bloc.addComment(CommentContent("content"), UniqueId("userId"));
        },
        expect: [
          TaskState.error(null),
        ]);

    blocTest("emits data on archive success",
        build: () => TaskBloc(UniqueId("mock_id"), repository),
        act: (TaskBloc bloc) {
          when(repository.archiveTask(any, any)).thenAnswer(
            (_) => Future.value(
              Either.right(
                Task(
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
          );
          bloc.archive(UniqueId("userId"));
        },
        expect: [
          TaskState.data(Task(
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
          )),
        ]);

    blocTest("emits error on archive error",
        build: () => TaskBloc(UniqueId("mock_id"), repository),
        act: (TaskBloc bloc) {
          when(repository.archiveTask(any, any)).thenAnswer((_) =>
              Future.value(Either.left(ServerFailure.unexpectedError(""))));
          bloc.archive(UniqueId("userId"));
        },
        expect: [
          TaskState.error(null),
        ]);

    blocTest("emits data on unarchive success",
        build: () => TaskBloc(UniqueId("mock_id"), repository),
        act: (TaskBloc bloc) {
          when(repository.unarchiveTask(any, any)).thenAnswer(
            (_) => Future.value(
              Either.right(
                Task(
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
          );
          bloc.unarchive(UniqueId("userId"));
        },
        expect: [
          TaskState.data(Task(
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
          )),
        ]);

    blocTest("emits error on unarchive error",
        build: () => TaskBloc(UniqueId("mock_id"), repository),
        act: (TaskBloc bloc) {
          when(repository.unarchiveTask(any, any)).thenAnswer((_) =>
              Future.value(Either.left(ServerFailure.unexpectedError(""))));
          bloc.unarchive(UniqueId("userId"));
        },
        expect: [
          TaskState.error(null),
        ]);

    blocTest("emits data on complete checklist success",
        build: () => TaskBloc(UniqueId("mock_id"), repository),
        act: (TaskBloc bloc) {
          when(repository.completeChecklist(any, any, any, any, any))
              .thenAnswer(
            (_) => Future.value(
              Either.right(
                Task(
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
          );
          bloc.completeChecklist(UniqueId("userId"), UniqueId("checklistId"),
              UniqueId("itemId"), Toggle(true));
        },
        expect: [
          TaskState.data(Task(
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
          )),
        ]);

    blocTest("emits error on complete checklist error",
        build: () => TaskBloc(UniqueId("mock_id"), repository),
        act: (TaskBloc bloc) {
          when(repository.completeChecklist(any, any, any, any, any))
              .thenAnswer((_) =>
                  Future.value(Either.left(ServerFailure.unexpectedError(""))));
          bloc.completeChecklist(UniqueId("userId"), UniqueId("checklistId"),
              UniqueId("itemId"), Toggle(true));
        },
        expect: [
          TaskState.error(null),
        ]);
  });
}
