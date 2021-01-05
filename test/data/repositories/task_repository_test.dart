import 'package:aspdm_project/core/either.dart';
import 'package:aspdm_project/data/datasources/remote_data_source.dart';
import 'package:aspdm_project/data/models/task_model.dart';
import 'package:aspdm_project/data/models/user_model.dart';
import 'package:aspdm_project/data/repositories/task_repository_impl.dart';
import 'package:aspdm_project/domain/entities/task.dart';
import 'package:aspdm_project/domain/repositories/task_repository.dart';
import 'package:aspdm_project/domain/values/comment_content.dart';
import 'package:aspdm_project/domain/values/toggle.dart';
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
      when(dataSource.getTask(any)).thenAnswer((_) async => TaskModel(
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
          ));
      final res = await repository.getTask(UniqueId("id"));

      expect(res.isRight(), isTrue);
      expect((res as Right).value, isA<Task>());
    });

    test("get task returns null task", () async {
      when(dataSource.getTask(any)).thenAnswer((_) => null);
      final res = await repository.getTask(UniqueId("id"));

      expect(res.isRight(), isTrue);
      expect((res as Right).value, isNull);
    });

    test("get task return error when passing null id", () async {
      final res = await repository.getTask(null);
      expect(res.isLeft(), isTrue);
    });

    test("complete checklist returns the updated task", () async {
      when(dataSource.check(any, any, any, any, any))
          .thenAnswer((_) async => TaskModel(
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
              ));
      final res = await repository.completeChecklist(
        UniqueId("taskId"),
        UniqueId("userId"),
        UniqueId("checklistId"),
        UniqueId("itemId"),
        Toggle(true),
      );

      expect(res.isRight(), isTrue);
      expect((res as Right).value, isA<Task>());
    });

    test("complete checklist return error", () async {
      when(dataSource.check(any, any, any, any, any))
          .thenAnswer((_) async => null);

      final res = await repository.completeChecklist(
        UniqueId("taskId"),
        UniqueId("userId"),
        UniqueId("checklistId"),
        UniqueId("itemId"),
        Toggle(true),
      );
      expect(res.isLeft(), isTrue);
    });
  });

  group("Archive test", () {
    test("archive task returns the updated task", () async {
      when(dataSource.archive(any, any, true))
          .thenAnswer((_) async => TaskModel(
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
              ));
      final res =
          await repository.archiveTask(UniqueId("taskId"), UniqueId("userId"));

      expect(res.isRight(), isTrue);
      expect((res as Right).value, isA<Task>());
    });

    test("archive task throws error", () async {
      when(dataSource.archive(any, any, true)).thenAnswer((_) async => null);

      final res = await repository.archiveTask(
        UniqueId("taskId"),
        UniqueId("userId"),
      );

      expect(res.isLeft(), isTrue);
    });

    test("unarchive task returns the updated task", () async {
      when(dataSource.archive(any, any, false))
          .thenAnswer((_) async => TaskModel(
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
              ));
      final res = await repository.unarchiveTask(
          UniqueId("taskId"), UniqueId("userId"));

      expect(res.isRight(), isTrue);
      expect((res as Right).value, isA<Task>());
    });

    test("unarchive task throws error", () async {
      when(dataSource.archive(any, any, false)).thenAnswer((_) async => null);

      final res = await repository.unarchiveTask(
        UniqueId("taskId"),
        UniqueId("userId"),
      );

      expect(res.isLeft(), isTrue);
    });
  });

  group("Comments test", () {
    test("delete comment returns the updated task", () async {
      when(dataSource.deleteComment(any, any, any))
          .thenAnswer((_) async => TaskModel(
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
              ));
      final res = await repository.deleteComment(
          UniqueId("taskId"), UniqueId("commentId"), UniqueId("userId"));

      expect(res.isRight(), isTrue);
      expect((res as Right).value, isA<Task>());
    });

    test("delete comment throws error", () async {
      when(dataSource.deleteComment(any, any, any))
          .thenAnswer((_) async => null);
      final res = await repository.deleteComment(
          UniqueId("taskId"), UniqueId("commentId"), UniqueId("userId"));

      expect(res.isLeft(), isTrue);
    });

    test("edit comment returns the updated task", () async {
      when(dataSource.patchComment(any, any, any, any))
          .thenAnswer((_) async => TaskModel(
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
              ));
      final res = await repository.editComment(UniqueId("taskId"),
          UniqueId("commentId"), CommentContent("content"), UniqueId("userId"));

      expect(res.isRight(), isTrue);
      expect((res as Right).value, isA<Task>());
    });

    test("edit comment throws error", () async {
      when(dataSource.patchComment(any, any, any, any))
          .thenAnswer((_) async => null);
      final res = await repository.editComment(UniqueId("taskId"),
          UniqueId("commentId"), CommentContent("content"), UniqueId("userId"));

      expect(res.isLeft(), isTrue);
    });

    test("add comment returns the updated task", () async {
      when(dataSource.postComment(any, any, any))
          .thenAnswer((_) async => TaskModel(
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
              ));
      final res = await repository.addComment(
          UniqueId("taskId"), CommentContent("content"), UniqueId("userId"));

      expect(res.isRight(), isTrue);
      expect((res as Right).value, isA<Task>());
    });

    test("add comment throws error", () async {
      when(dataSource.postComment(any, any, any)).thenAnswer((_) async => null);
      final res = await repository.addComment(
          UniqueId("taskId"), CommentContent("content"), UniqueId("userId"));

      expect(res.isLeft(), isTrue);
    });

    test("like comment returns the updated task", () async {
      when(dataSource.likeComment(any, any, any))
          .thenAnswer((_) async => TaskModel(
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
              ));
      final res = await repository.likeComment(
          UniqueId("taskId"), UniqueId("commentId"), UniqueId("userId"));

      expect(res.isRight(), isTrue);
      expect((res as Right).value, isA<Task>());
    });

    test("like comment throws error", () async {
      when(dataSource.likeComment(any, any, any)).thenAnswer((_) async => null);
      final res = await repository.likeComment(
          UniqueId("taskId"), UniqueId("commentId"), UniqueId("userId"));

      expect(res.isLeft(), isTrue);
    });

    test("dislike comment returns the updated task", () async {
      when(dataSource.dislikeComment(any, any, any))
          .thenAnswer((_) async => TaskModel(
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
              ));
      final res = await repository.dislikeComment(
          UniqueId("taskId"), UniqueId("commentId"), UniqueId("userId"));

      expect(res.isRight(), isTrue);
      expect((res as Right).value, isA<Task>());
    });

    test("dislike comment throws error", () async {
      when(dataSource.dislikeComment(any, any, any))
          .thenAnswer((_) async => null);
      final res = await repository.dislikeComment(
          UniqueId("taskId"), UniqueId("commentId"), UniqueId("userId"));

      expect(res.isLeft(), isTrue);
    });
  });
}
