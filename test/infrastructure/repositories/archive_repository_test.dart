import 'package:tasky/core/either.dart';
import 'package:tasky/infrastructure/datasources/remote_data_source.dart';
import 'package:tasky/infrastructure/models/task_model.dart';
import 'package:tasky/infrastructure/models/user_model.dart';
import 'package:tasky/infrastructure/repositories/archive_repository_impl.dart';
import 'package:tasky/domain/failures/server_failure.dart';
import 'package:tasky/domain/repositories/archive_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../mocks/mock_remote_data_source.dart';

void main() {
  ArchiveRepository repository;
  RemoteDataSource dataSource;

  setUpAll(() {
    dataSource = MockRemoteDataSource();
    repository = ArchiveRepositoryImpl(dataSource);
  });

  tearDownAll(() {
    repository = null;
    dataSource = null;
  });

  test("get archived tasks returns some data", () async {
    when(dataSource.getArchivedTasks()).thenAnswer((_) async => Either.right([
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
        ]));
    final res = await repository.getArchivedTasks();

    expect(res.isRight(), isTrue);
    expect(res.getOrNull(), isNotNull);
    expect(res.getOrNull(), hasLength(2));
  });

  test("get archived tasks returns empty", () async {
    when(dataSource.getArchivedTasks())
        .thenAnswer((_) async => Either.right([]));
    final res = await repository.getArchivedTasks();
    expect(res.isRight(), isTrue);
    expect(res.getOrNull(), isNotNull);
    expect(res.getOrNull(), isEmpty);
  });

  test("get archived tasks returns error", () async {
    when(dataSource.getArchivedTasks()).thenAnswer(
        (_) async => Either.left(ServerFailure.unexpectedError("")));
    final res = await repository.getArchivedTasks();
    expect(res.isLeft(), isTrue);

    when(dataSource.getArchivedTasks()).thenAnswer((_) async => throw Error());
    final res2 = await repository.getArchivedTasks();
    expect(res2.isLeft(), isTrue);
  });
}
