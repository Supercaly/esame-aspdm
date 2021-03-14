import 'package:tasky/application/bloc/task_bloc.dart';
import 'package:tasky/core/either.dart';
import 'package:tasky/core/maybe.dart';
import 'package:tasky/domain/failures/failures.dart';
import 'package:tasky/domain/failures/server_failure.dart';
import 'package:tasky/domain/values/task_values.dart';
import 'package:tasky/domain/values/unique_id.dart';
import 'package:tasky/domain/entities/task.dart';
import 'package:tasky/domain/repositories/task_repository.dart';
import 'package:tasky/services/link_service.dart';
import 'package:tasky/services/log_service.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../mocks/mock_log_service.dart';

class MockTaskRepository extends Mock implements TaskRepository {}

class MockLinkService extends Mock implements LinkService {}

void main() {
  group("TaskBloc Tests", () {
    late TaskRepository repository;
    late LogService logService;
    late LinkService linkService;

    setUp(() {
      repository = MockTaskRepository();
      logService = MockLogService();
      linkService = MockLinkService();

      when(logService).calls(#error).thenReturn();
    });

    blocTest(
      "emits nothing when created",
      build: () => TaskBloc(
        taskId: Maybe.just(UniqueId("mock_id")),
        repository: repository,
        logService: logService,
        linkService: linkService,
      ),
      expect: () => [],
    );

    blocTest("emits data on fetch success",
        build: () => TaskBloc(
              taskId: Maybe.just(UniqueId("mock_id")),
              repository: repository,
              logService: logService,
              linkService: linkService,
            ),
        act: (TaskBloc bloc) {
          when(repository).calls(#watchTask).thenAnswer(
                (_) => Stream<Either<Failure, Task>>.value(
                  Either.right(
                    Task.test(),
                  ),
                ),
              );
          bloc.fetch();
        },
        expect: () => [
              TaskState(null, false, true, false, null),
              TaskState(Task.test(), false, false, false, null),
            ]);

    blocTest(
      "emits error on fetch error",
      build: () => TaskBloc(
        taskId: Maybe.just(UniqueId("mock_id")),
        repository: repository,
        logService: logService,
        linkService: linkService,
      ),
      act: (TaskBloc bloc) {
        when(repository).calls(#watchTask).thenAnswer((_) =>
            Stream<Either<Failure, Task>>.value(
                Either.left(ServerFailure.unexpectedError(""))));
        bloc.fetch();
      },
      expect: () => [
        TaskState(null, false, true, false, null),
        TaskState(null, true, false, false, null),
      ],
    );

    blocTest(
      "don't emits loading when fetch has showLoading false",
      build: () => TaskBloc(
        taskId: Maybe.just(UniqueId("mock_id")),
        repository: repository,
        logService: logService,
        linkService: linkService,
      ),
      act: (TaskBloc bloc) {
        when(repository).calls(#watchTask).thenAnswer(
              (_) => Stream<Either<Failure, Task>>.value(
                Either.right(
                  Task.test(),
                ),
              ),
            );
        bloc.fetch(showLoading: false);
      },
      expect: () => [
        TaskState(
          Task.test(),
          false,
          false,
          false,
          null,
        ),
      ],
    );

    blocTest("emits data on comment delete success",
        build: () => TaskBloc(
              taskId: Maybe.just(UniqueId("mock_id")),
              repository: repository,
              logService: logService,
              linkService: linkService,
            ),
        act: (TaskBloc bloc) {
          when(repository).calls(#deleteComment).thenAnswer(
                (_) => Future<Either<Failure, Task>>.value(
                  Either.right(
                    Task.test(),
                  ),
                ),
              );
          bloc.deleteComment(
            UniqueId("commentId"),
            Maybe.just(UniqueId("userId")),
          );
        },
        expect: () => [
              TaskState(
                Task.test(),
                false,
                false,
                false,
                null,
              ),
            ]);

    blocTest("emits error on comment delete error",
        build: () => TaskBloc(
              taskId: Maybe.just(UniqueId("mock_id")),
              repository: repository,
              logService: logService,
              linkService: linkService,
            ),
        act: (TaskBloc bloc) {
          when(repository).calls(#deleteComment).thenAnswer((_) =>
              Future<Either<Failure, Task>>.value(
                  Either.left(ServerFailure.unexpectedError(""))));
          bloc.deleteComment(
            UniqueId("commentId"),
            Maybe.just(UniqueId("userId")),
          );
        },
        expect: () => [
              TaskState(null, true, false, false, null),
            ]);

    blocTest("emits data on comment edit success",
        build: () => TaskBloc(
              taskId: Maybe.just(UniqueId("mock_id")),
              repository: repository,
              logService: logService,
              linkService: linkService,
            ),
        act: (TaskBloc bloc) {
          when(repository).calls(#editComment).thenAnswer(
                (_) => Future<Either<Failure, Task>>.value(
                  Either.right(
                    Task.test(),
                  ),
                ),
              );
          bloc.editComment(
            UniqueId("commentId"),
            CommentContent("newContent"),
            Maybe.just(UniqueId("userId")),
          );
        },
        expect: () => [
              TaskState(
                Task.test(),
                false,
                false,
                false,
                null,
              ),
            ]);

    blocTest("emits error on comment edit error",
        build: () => TaskBloc(
              taskId: Maybe.just(UniqueId("mock_id")),
              repository: repository,
              logService: logService,
              linkService: linkService,
            ),
        act: (TaskBloc bloc) {
          when(repository).calls(#editComment).thenAnswer((_) =>
              Future<Either<Failure, Task>>.value(
                  Either.left(ServerFailure.unexpectedError(""))));
          bloc.editComment(
            UniqueId("commentId"),
            CommentContent("newContent"),
            Maybe.just(UniqueId("userId")),
          );
        },
        expect: () => [
              TaskState(null, true, false, false, null),
            ]);

    blocTest("emits data on comment like success",
        build: () => TaskBloc(
              taskId: Maybe.just(UniqueId("mock_id")),
              repository: repository,
              logService: logService,
              linkService: linkService,
            ),
        act: (TaskBloc bloc) {
          when(repository).calls(#likeComment).thenAnswer(
                (_) => Future<Either<Failure, Task>>.value(
                  Either.right(
                    Task.test(),
                  ),
                ),
              );
          bloc.likeComment(
            UniqueId("commentId"),
            Maybe.just(UniqueId("userId")),
          );
        },
        expect: () => [
              TaskState(
                Task.test(),
                false,
                false,
                false,
                null,
              ),
            ]);

    blocTest("emits error on comment like error",
        build: () => TaskBloc(
              taskId: Maybe.just(UniqueId("mock_id")),
              repository: repository,
              logService: logService,
              linkService: linkService,
            ),
        act: (TaskBloc bloc) {
          when(repository).calls(#likeComment).thenAnswer((_) =>
              Future<Either<Failure, Task>>.value(
                  Either.left(ServerFailure.unexpectedError(""))));
          bloc.likeComment(
            UniqueId("commentId"),
            Maybe.just(UniqueId("userId")),
          );
        },
        expect: () => [
              TaskState(null, true, false, false, null),
            ]);

    blocTest("emits data on comment dislike success",
        build: () => TaskBloc(
              taskId: Maybe.just(UniqueId("mock_id")),
              repository: repository,
              logService: logService,
              linkService: linkService,
            ),
        act: (TaskBloc bloc) {
          when(repository).calls(#dislikeComment).thenAnswer(
                (_) => Future<Either<Failure, Task>>.value(
                  Either.right(
                    Task.test(),
                  ),
                ),
              );
          bloc.dislikeComment(
            UniqueId("commentId"),
            Maybe.just(UniqueId("userId")),
          );
        },
        expect: () => [
              TaskState(
                Task.test(),
                false,
                false,
                false,
                null,
              ),
            ]);

    blocTest("emits error on comment dislike error",
        build: () => TaskBloc(
              taskId: Maybe.just(UniqueId("mock_id")),
              repository: repository,
              logService: logService,
              linkService: linkService,
            ),
        act: (TaskBloc bloc) {
          when(repository).calls(#dislikeComment).thenAnswer((_) =>
              Future<Either<Failure, Task>>.value(
                  Either.left(ServerFailure.unexpectedError(""))));
          bloc.dislikeComment(
            UniqueId("commentId"),
            Maybe.just(UniqueId("userId")),
          );
        },
        expect: () => [
              TaskState(null, true, false, false, null),
            ]);

    blocTest("emits data on add comment success",
        build: () => TaskBloc(
              taskId: Maybe.just(UniqueId("mock_id")),
              repository: repository,
              logService: logService,
              linkService: linkService,
            ),
        act: (TaskBloc bloc) {
          when(repository).calls(#addComment).thenAnswer(
                (_) => Future<Either<Failure, Task>>.value(
                  Either.right(
                    Task.test(),
                  ),
                ),
              );
          bloc.addComment(
              CommentContent("content"), Maybe.just(UniqueId("userId")));
        },
        expect: () => [
              TaskState(
                Task.test(),
                false,
                false,
                false,
                null,
              ),
            ]);

    blocTest("emits error on add comment error",
        build: () => TaskBloc(
              taskId: Maybe.just(UniqueId("mock_id")),
              repository: repository,
              logService: logService,
              linkService: linkService,
            ),
        act: (TaskBloc bloc) {
          when(repository).calls(#addComment).thenAnswer((_) =>
              Future<Either<Failure, Task>>.value(
                  Either.left(ServerFailure.unexpectedError(""))));
          bloc.addComment(
            CommentContent("content"),
            Maybe.just(UniqueId("userId")),
          );
        },
        expect: () => [
              TaskState(null, true, false, false, null),
            ]);

    blocTest("emits data on archive success",
        build: () => TaskBloc(
              taskId: Maybe.just(UniqueId("mock_id")),
              repository: repository,
              logService: logService,
              linkService: linkService,
            ),
        act: (TaskBloc bloc) {
          when(repository).calls(#archiveTask).thenAnswer(
                (_) => Future<Either<Failure, Task>>.value(
                  Either.right(
                    Task.test(),
                  ),
                ),
              );
          bloc.archive(Maybe.just(UniqueId("userId")));
        },
        expect: () => [
              TaskState(
                Task.test(),
                false,
                false,
                false,
                null,
              ),
            ]);

    blocTest("emits error on archive error",
        build: () => TaskBloc(
              taskId: Maybe.just(UniqueId("mock_id")),
              repository: repository,
              logService: logService,
              linkService: linkService,
            ),
        act: (TaskBloc bloc) {
          when(repository).calls(#archiveTask).thenAnswer((_) =>
              Future<Either<Failure, Task>>.value(
                  Either.left(ServerFailure.unexpectedError(""))));
          bloc.archive(Maybe.just(UniqueId("userId")));
        },
        expect: () => [
              TaskState(null, true, false, false, null),
            ]);

    blocTest("emits data on unarchive success",
        build: () => TaskBloc(
              taskId: Maybe.just(UniqueId("mock_id")),
              repository: repository,
              logService: logService,
              linkService: linkService,
            ),
        act: (TaskBloc bloc) {
          when(repository).calls(#unarchiveTask).thenAnswer(
                (_) => Future<Either<Failure, Task>>.value(
                  Either.right(
                    Task.test(),
                  ),
                ),
              );
          bloc.unarchive(Maybe.just(UniqueId("userId")));
        },
        expect: () => [
              TaskState(
                Task.test(),
                false,
                false,
                false,
                null,
              ),
            ]);

    blocTest("emits error on unarchive error",
        build: () => TaskBloc(
              taskId: Maybe.just(UniqueId("mock_id")),
              repository: repository,
              logService: logService,
              linkService: linkService,
            ),
        act: (TaskBloc bloc) {
          when(repository).calls(#unarchiveTask).thenAnswer((_) =>
              Future<Either<Failure, Task>>.value(
                  Either.left(ServerFailure.unexpectedError(""))));
          bloc.unarchive(Maybe.just(UniqueId("userId")));
        },
        expect: () => [
              TaskState(null, true, false, false, null),
            ]);

    blocTest("emits data on complete checklist success",
        build: () => TaskBloc(
              taskId: Maybe.just(UniqueId("mock_id")),
              repository: repository,
              logService: logService,
              linkService: linkService,
            ),
        act: (TaskBloc bloc) {
          when(repository).calls(#completeChecklist).thenAnswer(
                (_) => Future<Either<Failure, Task>>.value(
                  Either.right(
                    Task.test(),
                  ),
                ),
              );
          bloc.completeChecklist(
            Maybe.just(UniqueId("userId")),
            UniqueId("checklistId"),
            UniqueId("itemId"),
            Toggle(true),
          );
        },
        expect: () => [
              TaskState(
                Task.test(),
                false,
                false,
                false,
                null,
              ),
            ]);

    blocTest("emits error on complete checklist error",
        build: () => TaskBloc(
              taskId: Maybe.just(UniqueId("mock_id")),
              repository: repository,
              logService: logService,
              linkService: linkService,
            ),
        act: (TaskBloc bloc) {
          when(repository).calls(#completeChecklist).thenAnswer((_) =>
              Future<Either<Failure, Task>>.value(
                  Either.left(ServerFailure.unexpectedError(""))));
          bloc.completeChecklist(
            Maybe.just(UniqueId("userId")),
            UniqueId("checklistId"),
            UniqueId("itemId"),
            Toggle(true),
          );
        },
        expect: () => [
              TaskState(null, true, false, false, null),
            ]);

    blocTest("emits link on share success",
        build: () => TaskBloc(
              taskId: Maybe.just(UniqueId("mock_id")),
              logService: logService,
              repository: repository,
              linkService: linkService,
            ),
        act: (TaskBloc cubit) {
          when(linkService).calls(#createLinkForPost).thenAnswer(
              (_) async => Maybe.just(Uri.parse("https://mock.link.com/mock")));
          cubit.share();
        },
        expect: () => [
              TaskState(
                  null, false, false, false, "https://mock.link.com/mock"),
            ]);

    blocTest("emits error on share error",
        build: () => TaskBloc(
              taskId: null,
              logService: logService,
              repository: repository,
              linkService: linkService,
            ),
        act: (TaskBloc cubit) {
          when(linkService)
              .calls(#createLinkForPost)
              .thenAnswer((_) async => Maybe<Uri>.nothing());
          cubit.share();
        },
        expect: () => [
              TaskState(null, false, false, true, null),
            ]);
  });
}
