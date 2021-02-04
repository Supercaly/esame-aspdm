import 'package:aspdm_project/core/ilist.dart';
import 'package:aspdm_project/domain/entities/task.dart';
import 'package:aspdm_project/domain/entities/user.dart';
import 'package:aspdm_project/domain/failures/server_failure.dart';
import 'package:aspdm_project/domain/repositories/task_form_repository.dart';
import 'package:aspdm_project/domain/values/task_values.dart';
import 'package:aspdm_project/domain/values/unique_id.dart';
import 'package:aspdm_project/domain/values/user_values.dart';
import 'package:aspdm_project/infrastructure/datasources/remote_data_source.dart';
import 'package:aspdm_project/infrastructure/repositories/task_form_repository_imp.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:aspdm_project/core/either.dart';
import 'package:mockito/mockito.dart';
import '../../mocks/mock_remote_data_source.dart';

void main() {
  group("TaskFormRepository test", () {
    TaskFormRepository repository;
    RemoteDataSource dataSource;

    setUpAll(() {
      dataSource = MockRemoteDataSource();
      repository = TaskFormRepositoryImpl(dataSource);
    });

    tearDownAll(() {
      dataSource = null;
      repository = null;
    });

    test("save new task return unit", () async {
      when(dataSource.postTask(any, any))
          .thenAnswer((_) async => Either.right(null));
      final res = await repository.saveNewTask(
        Task(
          UniqueId("task_id"),
          TaskTitle("Mock Title"),
          TaskDescription.empty(),
          IList.empty(),
          User(
            UniqueId("user_di"),
            UserName("Mock User"),
            EmailAddress("user@mock.com"),
            null,
          ),
          IList.empty(),
          null,
          IList.empty(),
          IList.empty(),
          Toggle(false),
          null,
        ),
        UniqueId("mock_id"),
      );

      expect(res.isRight(), isTrue);
      expect(res.getOrNull(), isA<Unit>());
    });

    test("save new task return error", () async {
      when(dataSource.postTask(any, any)).thenAnswer(
          (_) async => Either.left(ServerFailure.unexpectedError("")));
      final res = await repository.saveNewTask(
        Task(
          UniqueId("task_id"),
          TaskTitle("Mock Title"),
          TaskDescription.empty(),
          IList.empty(),
          User(
            UniqueId("user_di"),
            UserName("Mock User"),
            EmailAddress("user@mock.com"),
            null,
          ),
          IList.empty(),
          null,
          IList.empty(),
          IList.empty(),
          Toggle(false),
          null,
        ),
        UniqueId("mock_id"),
      );

      expect(res.isLeft(), isTrue);
    });

    test("update task return unit", () async {
      when(dataSource.patchTask(any, any))
          .thenAnswer((_) async => Either.right(null));
      final res = await repository.updateTask(
        Task(
          UniqueId("task_id"),
          TaskTitle("Mock Title"),
          TaskDescription.empty(),
          IList.empty(),
          User(
            UniqueId("user_di"),
            UserName("Mock User"),
            EmailAddress("user@mock.com"),
            null,
          ),
          IList.empty(),
          null,
          IList.empty(),
          IList.empty(),
          Toggle(false),
          null,
        ),
        UniqueId("mock_id"),
      );

      expect(res.isRight(), isTrue);
      expect(res.getOrNull(), isA<Unit>());
    });

    test("update task return error", () async {
      when(dataSource.patchTask(any, any)).thenAnswer(
          (_) async => Either.left(ServerFailure.unexpectedError("")));
      final res = await repository.updateTask(
        Task(
          UniqueId("task_id"),
          TaskTitle("Mock Title"),
          TaskDescription.empty(),
          IList.empty(),
          User(
            UniqueId("user_di"),
            UserName("Mock User"),
            EmailAddress("user@mock.com"),
            null,
          ),
          IList.empty(),
          null,
          IList.empty(),
          IList.empty(),
          Toggle(false),
          null,
        ),
        UniqueId("mock_id"),
      );

      expect(res.isLeft(), isTrue);
    });
  });
}
