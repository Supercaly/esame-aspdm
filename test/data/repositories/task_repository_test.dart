import 'package:aspdm_project/data/datasources/remote_data_source.dart';
import 'package:aspdm_project/data/models/task_model.dart';
import 'package:aspdm_project/data/models/user_model.dart';
import 'package:aspdm_project/data/repositories/task_repository_impl.dart';
import 'package:aspdm_project/domain/entities/task.dart';
import 'package:aspdm_project/domain/repositories/task_repository.dart';
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
            DateTime.parse("2020-12-01"),
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
          ));
      final res = await repository.getTask("id");

      expect(res, isNotNull);
      expect(res, isA<Task>());
    });

    test("get task returns null task", () async {
      when(dataSource.getTask(any)).thenAnswer((_) => null);
      final res = await repository.getTask("id");

      expect(res, isNull);
    });

    test("get task throws error when passing null id", () async {
      try {
        await repository.getTask(null);
        fail("This should throw an exception!");
      } catch (e) {
        expect(e, isA<AssertionError>());
      }
    });

    test("complete checklist returns the updated task", () async {
      when(dataSource.check(any, any, any, any, any))
          .thenAnswer((_) async => TaskModel(
                "mock_id_1",
                "title",
                DateTime.parse("2020-12-01"),
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
              ));
      final res = await repository.completeChecklist(
        "taskId",
        "userId",
        "checklistId",
        "itemId",
        true,
      );

      expect(res, isNotNull);
      expect(res, isA<Task>());
    });

    test("complete checklist throws error", () async {
      when(dataSource.check(any, any, any, any, any))
          .thenAnswer((_) async => null);
      try {
        await repository.completeChecklist(
          "taskId",
          "userId",
          "checklistId",
          "itemId",
          true,
        );
        fail("This should throw an exception!");
      } catch (e) {
        expect(e, isA<Exception>());
      }
    });
  });

  group("Archive test", () {
    test("archive task returns the updated task", () async {
      when(dataSource.archive(any, any, true))
          .thenAnswer((_) async => TaskModel(
                "mock_id_1",
                "title",
                DateTime.parse("2020-12-01"),
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
              ));
      final res = await repository.archiveTask("taskId", "userId");

      expect(res, isNotNull);
      expect(res, isA<Task>());
    });

    test("archive task throws error", () async {
      when(dataSource.archive(any, any, true)).thenAnswer((_) async => null);
      try {
        await repository.archiveTask(
          "taskId",
          "userId",
        );
        fail("This should throw an exception!");
      } catch (e) {
        expect(e, isA<Exception>());
      }
    });

    test("unarchive task returns the updated task", () async {
      when(dataSource.archive(any, any, false))
          .thenAnswer((_) async => TaskModel(
                "mock_id_1",
                "title",
                DateTime.parse("2020-12-01"),
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
              ));
      final res = await repository.unarchiveTask("taskId", "userId");

      expect(res, isNotNull);
      expect(res, isA<Task>());
    });

    test("unarchive task throws error", () async {
      when(dataSource.archive(any, any, false)).thenAnswer((_) async => null);
      try {
        await repository.unarchiveTask(
          "taskId",
          "userId",
        );
        fail("This should throw an exception!");
      } catch (e) {
        expect(e, isA<Exception>());
      }
    });
  });

  group("Comments test", () {
    test("delete comment returns the updated task", () async {
      when(dataSource.deleteComment(any, any, any))
          .thenAnswer((_) async => TaskModel(
                "mock_id_1",
                "title",
                DateTime.parse("2020-12-01"),
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
              ));
      final res =
          await repository.deleteComment("taskId", "commentId", "userId");

      expect(res, isNotNull);
      expect(res, isA<Task>());
    });

    test("delete comment throws error", () async {
      when(dataSource.deleteComment(any, any, any))
          .thenAnswer((_) async => null);
      try {
        await repository.deleteComment("taskId", "commentId", "userId");
        fail("This should throw an exception!");
      } catch (e) {
        expect(e, isA<Exception>());
      }
    });

    test("edit comment returns the updated task", () async {
      when(dataSource.patchComment(any, any, any, any))
          .thenAnswer((_) async => TaskModel(
                "mock_id_1",
                "title",
                DateTime.parse("2020-12-01"),
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
              ));
      final res = await repository.editComment(
          "taskId", "commentId", "content", "userId");

      expect(res, isNotNull);
      expect(res, isA<Task>());
    });

    test("edit comment throws error", () async {
      when(dataSource.patchComment(any, any, any, any))
          .thenAnswer((_) async => null);
      try {
        await repository.editComment(
            "taskId", "commentId", "content", "userId");
        fail("This should throw an exception!");
      } catch (e) {
        expect(e, isA<Exception>());
      }
    });

    test("add comment returns the updated task", () async {
      when(dataSource.postComment(any, any, any))
          .thenAnswer((_) async => TaskModel(
                "mock_id_1",
                "title",
                DateTime.parse("2020-12-01"),
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
              ));
      final res = await repository.addComment("taskId", "content", "userId");

      expect(res, isNotNull);
      expect(res, isA<Task>());
    });

    test("add comment throws error", () async {
      when(dataSource.postComment(any, any, any)).thenAnswer((_) async => null);
      try {
        await repository.addComment("taskId", "content", "userId");
        fail("This should throw an exception!");
      } catch (e) {
        expect(e, isA<Exception>());
      }
    });

    test("like comment returns the updated task", () async {
      when(dataSource.likeComment(any, any, any))
          .thenAnswer((_) async => TaskModel(
                "mock_id_1",
                "title",
                DateTime.parse("2020-12-01"),
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
              ));
      final res = await repository.likeComment("taskId", "commentId", "userId");

      expect(res, isNotNull);
      expect(res, isA<Task>());
    });

    test("like comment throws error", () async {
      when(dataSource.likeComment(any, any, any)).thenAnswer((_) async => null);
      try {
        await repository.likeComment("taskId", "commentId", "userId");
        fail("This should throw an exception!");
      } catch (e) {
        expect(e, isA<Exception>());
      }
    });

    test("dislike comment returns the updated task", () async {
      when(dataSource.dislikeComment(any, any, any))
          .thenAnswer((_) async => TaskModel(
                "mock_id_1",
                "title",
                DateTime.parse("2020-12-01"),
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
              ));
      final res =
          await repository.dislikeComment("taskId", "commentId", "userId");

      expect(res, isNotNull);
      expect(res, isA<Task>());
    });

    test("dislike comment throws error", () async {
      when(dataSource.dislikeComment(any, any, any))
          .thenAnswer((_) async => null);
      try {
        await repository.dislikeComment("taskId", "commentId", "userId");
        fail("This should throw an exception!");
      } catch (e) {
        expect(e, isA<Exception>());
      }
    });
  });
}
