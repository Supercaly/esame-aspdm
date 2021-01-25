import 'package:aspdm_project/core/either.dart';
import 'package:aspdm_project/core/maybe.dart';
import 'package:aspdm_project/domain/failures/server_failure.dart';
import 'package:aspdm_project/domain/failures/task_failure.dart';
import 'package:aspdm_project/infrastructure/datasources/remote_data_source.dart';
import 'package:aspdm_project/infrastructure/models/task_model.dart';
import 'package:aspdm_project/infrastructure/models/user_model.dart';
import 'package:aspdm_project/infrastructure/repositories/task_repository_impl.dart';
import 'package:aspdm_project/domain/entities/task.dart';
import 'package:aspdm_project/domain/repositories/task_repository.dart';
import 'package:aspdm_project/domain/values/task_values.dart';
import 'package:aspdm_project/domain/values/unique_id.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../mocks/mock_remote_data_source.dart';

void main() {
  TaskRepository repository;
  RemoteDataSource dataSource;

  setUpAll(() {
    dataSource = MockRemoteDataSource();
    repository = TaskRepositoryImpl(dataSource);
  });

  tearDownAll(() {
    repository = null;
    dataSource = null;
  });

  group("General test", () {
    test("get task returns the task", () async {
      when(dataSource.getTask(any)).thenAnswer(
        (_) async => Either.right(
          TaskModel(
            "mock_id_1",
            "title",
            "description",
            null,
            UserModel(
              "mock_id_1",
              "Mock User 1",
              "mock1@email.com",
              null,
            ),
            null,
            null,
            null,
            null,
            false,
            DateTime.parse("2020-12-01"),
          ),
        ),
      );
      final res = await repository.getTask(Maybe.just(UniqueId("id")));

      expect(res.isRight(), isTrue);
      expect(res.getOrNull(), isNotNull);
      expect(res.getOrNull(), isA<Task>());
    });

    test("get task returns null task", () async {
      when(dataSource.getTask(any)).thenAnswer((_) async => Either.right(null));
      final res = await repository.getTask(Maybe.just(UniqueId("id")));

      expect(res.isRight(), isTrue);
      expect(res.getOrNull(), isNull);
    });

    test("get task return error", () async {
      final res = await repository.getTask(Maybe.nothing());
      expect(res.isLeft(), isTrue);

      when(dataSource.getTask(any)).thenAnswer(
          (_) async => Either.left(ServerFailure.unexpectedError("")));
      final res2 = await repository.getTask(Maybe.just(UniqueId("mock_id")));
      expect(res2.isLeft(), isTrue);
    });

    test("complete checklist returns the updated task", () async {
      when(dataSource.check(any, any, any, any, any)).thenAnswer(
        (_) async => Either.right(
          TaskModel(
            "mock_id_1",
            "title",
            "description",
            null,
            UserModel(
              "mock_id_1",
              "Mock User 1",
              "mock1@email.com",
              null,
            ),
            null,
            null,
            null,
            null,
            false,
            DateTime.parse("2020-12-01"),
          ),
        ),
      );
      final res = await repository.completeChecklist(
        Maybe.just(UniqueId("taskId")),
        Maybe.just(UniqueId("userId")),
        UniqueId("checklistId"),
        UniqueId("itemId"),
        Toggle(true),
      );

      expect(res.isRight(), isTrue);
      expect(res.getOrNull(), isNotNull);
      expect(res.getOrNull(), isA<Task>());
    });

    test("complete checklist return error", () async {
      when(dataSource.check(any, any, any, any, any)).thenAnswer((_) async =>
          Either.left(TaskFailure.itemCompleteFailure(UniqueId("itemId"))));
      final res = await repository.completeChecklist(
        Maybe.just(UniqueId("taskId")),
        Maybe.just(UniqueId("userId")),
        UniqueId("checklistId"),
        UniqueId("itemId"),
        Toggle(true),
      );
      expect(res.isLeft(), isTrue);
    });
  });

  group("Archive test", () {
    test("archive task returns the updated task", () async {
      when(dataSource.archive(any, any, Toggle(true))).thenAnswer(
        (_) async => Either.right(
          TaskModel(
            "mock_id_1",
            "title",
            "description",
            null,
            UserModel(
              "mock_id_1",
              "Mock User 1",
              "mock1@email.com",
              null,
            ),
            null,
            null,
            null,
            null,
            false,
            DateTime.parse("2020-12-01"),
          ),
        ),
      );
      final res = await repository.archiveTask(
        Maybe.just(UniqueId("taskId")),
        Maybe.just(UniqueId("userId")),
      );

      expect(res.isRight(), isTrue);
      expect(res.getOrNull(), isNotNull);
      expect(res.getOrNull(), isA<Task>());
    });

    test("archive task return error", () async {
      when(dataSource.archive(any, any, Toggle(true))).thenAnswer((_) async =>
          Either.left(TaskFailure.archiveFailure(UniqueId("taskId"))));
      final res = await repository.archiveTask(
        Maybe.just(UniqueId("taskId")),
        Maybe.just(UniqueId("userId")),
      );
      expect(res.isLeft(), isTrue);
    });

    test("unarchive task returns the updated task", () async {
      when(dataSource.archive(any, any, Toggle(false))).thenAnswer(
        (_) async => Either.right(
          TaskModel(
            "mock_id_1",
            "title",
            "description",
            null,
            UserModel(
              "mock_id_1",
              "Mock User 1",
              "mock1@email.com",
              null,
            ),
            null,
            null,
            null,
            null,
            false,
            DateTime.parse("2020-12-01"),
          ),
        ),
      );
      final res = await repository.unarchiveTask(
        Maybe.just(UniqueId("taskId")),
        Maybe.just(UniqueId("userId")),
      );

      expect(res.isRight(), isTrue);
      expect(res.getOrNull(), isNotNull);
      expect(res.getOrNull(), isA<Task>());
    });

    test("unarchive task return error", () async {
      when(dataSource.archive(any, any, Toggle(false))).thenAnswer((_) async =>
          Either.left(TaskFailure.unarchiveFailure(UniqueId("taskId"))));
      final res = await repository.unarchiveTask(
        Maybe.just(UniqueId("taskId")),
        Maybe.just(UniqueId("userId")),
      );
      expect(res.isLeft(), isTrue);
    });
  });

  group("Comments test", () {
    test("delete comment returns the updated task", () async {
      when(dataSource.deleteComment(any, any, any)).thenAnswer(
        (_) async => Either.right(
          TaskModel(
            "mock_id_1",
            "title",
            "description",
            null,
            UserModel(
              "mock_id_1",
              "Mock User 1",
              "mock1@email.com",
              null,
            ),
            null,
            null,
            null,
            null,
            false,
            DateTime.parse("2020-12-01"),
          ),
        ),
      );
      final res = await repository.deleteComment(
        Maybe.just(UniqueId("taskId")),
        UniqueId("commentId"),
        Maybe.just(UniqueId("userId")),
      );

      expect(res.isRight(), isTrue);
      expect(res.getOrNull(), isNotNull);
      expect(res.getOrNull(), isA<Task>());
    });

    test("delete comment return error", () async {
      when(dataSource.deleteComment(any, any, any)).thenAnswer((_) async =>
          Either.left(TaskFailure.deleteCommentFailure(UniqueId("commentId"))));
      final res = await repository.deleteComment(
        Maybe.just(UniqueId("taskId")),
        UniqueId("commentId"),
        Maybe.just(UniqueId("userId")),
      );
      expect(res.isLeft(), isTrue);
    });

    test("edit comment returns the updated task", () async {
      when(dataSource.patchComment(any, any, any, any)).thenAnswer(
        (_) async => Either.right(
          TaskModel(
            "mock_id_1",
            "title",
            "description",
            null,
            UserModel(
              "mock_id_1",
              "Mock User 1",
              "mock1@email.com",
              null,
            ),
            null,
            null,
            null,
            null,
            false,
            DateTime.parse("2020-12-01"),
          ),
        ),
      );
      final res = await repository.editComment(
        Maybe.just(UniqueId("taskId")),
        UniqueId("commentId"),
        CommentContent("content"),
        Maybe.just(UniqueId("userId")),
      );

      expect(res.isRight(), isTrue);
      expect(res.getOrNull(), isNotNull);
      expect(res.getOrNull(), isA<Task>());
    });

    test("edit comment return error", () async {
      when(dataSource.patchComment(any, any, any, any)).thenAnswer((_) async =>
          Either.left(TaskFailure.editCommentFailure(UniqueId("commentId"))));
      final res = await repository.editComment(
        Maybe.just(UniqueId("taskId")),
        UniqueId("commentId"),
        CommentContent("content"),
        Maybe.just(UniqueId("userId")),
      );
      expect(res.isLeft(), isTrue);
    });

    test("add comment returns the updated task", () async {
      when(dataSource.postComment(any, any, any)).thenAnswer(
        (_) async => Either.right(
          TaskModel(
            "mock_id_1",
            "title",
            "description",
            null,
            UserModel(
              "mock_id_1",
              "Mock User 1",
              "mock1@email.com",
              null,
            ),
            null,
            null,
            null,
            null,
            false,
            DateTime.parse("2020-12-01"),
          ),
        ),
      );
      final res = await repository.addComment(
        Maybe.just(UniqueId("taskId")),
        CommentContent("content"),
        Maybe.just(UniqueId("userId")),
      );

      expect(res.isRight(), isTrue);
      expect(res.getOrNull(), isNotNull);
      expect(res.getOrNull(), isA<Task>());
    });

    test("add comment return error", () async {
      when(dataSource.postComment(any, any, any)).thenAnswer(
          (_) async => Either.left(TaskFailure.newCommentFailure()));
      final res = await repository.addComment(
        Maybe.just(UniqueId("taskId")),
        CommentContent("content"),
        Maybe.just(UniqueId("userId")),
      );
      expect(res.isLeft(), isTrue);
    });

    test("like comment returns the updated task", () async {
      when(dataSource.likeComment(any, any, any)).thenAnswer(
        (_) async => Either.right(
          TaskModel(
            "mock_id_1",
            "title",
            "description",
            null,
            UserModel(
              "mock_id_1",
              "Mock User 1",
              "mock1@email.com",
              null,
            ),
            null,
            null,
            null,
            null,
            false,
            DateTime.parse("2020-12-01"),
          ),
        ),
      );
      final res = await repository.likeComment(
        Maybe.just(UniqueId("taskId")),
        UniqueId("commentId"),
        Maybe.just(UniqueId("userId")),
      );

      expect(res.isRight(), isTrue);
      expect(res.getOrNull(), isNotNull);
      expect(res.getOrNull(), isA<Task>());
    });

    test("like comment return error", () async {
      when(dataSource.likeComment(any, any, any)).thenAnswer((_) async =>
          Either.left(TaskFailure.likeFailure(UniqueId("commentId"))));
      final res = await repository.likeComment(
        Maybe.just(UniqueId("taskId")),
        UniqueId("commentId"),
        Maybe.just(UniqueId("userId")),
      );
      expect(res.isLeft(), isTrue);
    });

    test("dislike comment returns the updated task", () async {
      when(dataSource.dislikeComment(any, any, any)).thenAnswer(
        (_) async => Either.right(
          TaskModel(
            "mock_id_1",
            "title",
            "description",
            null,
            UserModel(
              "mock_id_1",
              "Mock User 1",
              "mock1@email.com",
              null,
            ),
            null,
            null,
            null,
            null,
            false,
            DateTime.parse("2020-12-01"),
          ),
        ),
      );
      final res = await repository.dislikeComment(
        Maybe.just(UniqueId("taskId")),
        UniqueId("commentId"),
        Maybe.just(UniqueId("userId")),
      );

      expect(res.isRight(), isTrue);
      expect(res.getOrNull(), isNotNull);
      expect(res.getOrNull(), isA<Task>());
    });

    test("dislike comment return error", () async {
      when(dataSource.dislikeComment(any, any, any)).thenAnswer((_) async =>
          Either.left(TaskFailure.dislikeFailure(UniqueId("commentId"))));
      final res = await repository.dislikeComment(
        Maybe.just(UniqueId("taskId")),
        UniqueId("commentId"),
        Maybe.just(UniqueId("userId")),
      );
      expect(res.isLeft(), isTrue);
    });
  });
}
