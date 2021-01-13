import 'package:aspdm_project/core/either.dart';
import 'package:aspdm_project/infrastructure/datasources/remote_data_source.dart';
import 'package:aspdm_project/infrastructure/models/task_model.dart';
import 'package:aspdm_project/infrastructure/models/user_model.dart';
import 'package:aspdm_project/infrastructure/repositories/home_repository_impl.dart';
import 'package:aspdm_project/domain/failures/server_failure.dart';
import 'package:aspdm_project/domain/repositories/home_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../mocks/mock_remote_data_source.dart';

void main() {
  HomeRepository repository;
  RemoteDataSource dataSource;

  setUpAll(() {
    dataSource = MockRemoteDataSource();
    repository = HomeRepositoryImpl(dataSource);
  });

  tearDownAll(() {
    repository = null;
    dataSource = null;
  });

  test("get tasks returns some data", () async {
    when(dataSource.getUnarchivedTasks()).thenAnswer((_) async => [
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
          TaskModel(
            "mock_id_2",
            "title",
            "description",
            null,
            UserModel(
              "mock_id_2",
              "Mock User 2",
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
        ]);
    final res = await repository.getTasks();

    expect(res.isRight(), isTrue);
    expect((res as Right).value, hasLength(2));
  });

  test("get tasks returns empty", () async {
    when(dataSource.getUnarchivedTasks()).thenAnswer((_) async => []);
    final res = await repository.getTasks();
    expect(res.isRight(), isTrue);
    expect((res as Right).value, isEmpty);

    when(dataSource.getUnarchivedTasks()).thenAnswer((_) async => null);
    final res2 = await repository.getTasks();
    expect(res2.isRight(), isTrue);
    expect((res2 as Right).value, isEmpty);
  });

  test("get tasks returns error", () async {
    when(dataSource.getUnarchivedTasks())
        .thenAnswer((_) async => throw ServerFailure.unexpectedError(""));
    final res = await repository.getTasks();

    expect(res.isLeft(), isTrue);
    expect((res as Left).value, ServerFailure.unexpectedError(""));
  });
}