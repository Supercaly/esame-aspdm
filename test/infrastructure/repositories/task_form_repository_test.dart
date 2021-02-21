import 'package:tasky/core/ilist.dart';
import 'package:tasky/domain/entities/task.dart';
import 'package:tasky/domain/entities/user.dart';
import 'package:tasky/domain/failures/server_failure.dart';
import 'package:tasky/domain/repositories/task_form_repository.dart';
import 'package:tasky/domain/values/task_values.dart';
import 'package:tasky/domain/values/unique_id.dart';
import 'package:tasky/domain/values/user_values.dart';
import 'package:tasky/infrastructure/datasources/remote_data_source.dart';
import 'package:tasky/infrastructure/repositories/task_form_repository_imp.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tasky/core/either.dart';
import 'package:mockito/mockito.dart';
import '../../mocks/mock_remote_data_source.dart';

void main() {
  group("TaskFormRepository test", () {
    TaskFormRepository repository;
    RemoteDataSource dataSource;

    setUpAll(() {
      dataSource = MockRemoteDataSource();
      repository = TaskFormRepositoryImpl(dataSource: dataSource);
    });

    tearDownAll(() {
      dataSource = null;
      repository = null;
    });

    test("save new task return unit", () async {
      when(dataSource.postTask(any, any))
          .thenAnswer((_) async => Either.right(null));
      final res = await repository.saveNewTask(
        Task.test(
          id: UniqueId("task_id"),
          title: TaskTitle("Mock Title"),
          description: TaskDescription.empty(),
          labels: IList.empty(),
          author: User(
            id: UniqueId("user_di"),
            name: UserName("Mock User"),
            email: EmailAddress("user@mock.com"),
            profileColor: null,
          ),
          members: IList.empty(),
          checklists: IList.empty(),
          comments: IList.empty(),
          archived: Toggle(false),
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
        Task.test(
          id: UniqueId("task_id"),
          title: TaskTitle("Mock Title"),
          description: TaskDescription.empty(),
          labels: IList.empty(),
          author: User(
            id: UniqueId("user_di"),
            name: UserName("Mock User"),
            email: EmailAddress("user@mock.com"),
            profileColor: null,
          ),
          members: IList.empty(),
          checklists: IList.empty(),
          comments: IList.empty(),
          archived: Toggle(false),
        ),
        UniqueId("mock_id"),
      );

      expect(res.isLeft(), isTrue);
    });

    test("update task return unit", () async {
      when(dataSource.patchTask(any, any))
          .thenAnswer((_) async => Either.right(null));
      final res = await repository.updateTask(
        Task.test(
          id: UniqueId("task_id"),
          title: TaskTitle("Mock Title"),
          description: TaskDescription.empty(),
          labels: IList.empty(),
          author: User(
            id: UniqueId("user_di"),
            name: UserName("Mock User"),
            email: EmailAddress("user@mock.com"),
            profileColor: null,
          ),
          members: IList.empty(),
          checklists: IList.empty(),
          comments: IList.empty(),
          archived: Toggle(false),
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
        Task.test(
          id: UniqueId("task_id"),
          title: TaskTitle("Mock Title"),
          description: TaskDescription.empty(),
          labels: IList.empty(),
          author: User(
            id: UniqueId("user_di"),
            name: UserName("Mock User"),
            email: EmailAddress("user@mock.com"),
            profileColor: null,
          ),
          members: IList.empty(),
          expireDate: null,
          checklists: IList.empty(),
          comments: IList.empty(),
          archived: Toggle(false),
          creationDate: null,
        ),
        UniqueId("mock_id"),
      );

      expect(res.isLeft(), isTrue);
    });
  });
}
