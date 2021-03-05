import 'package:tasky/core/either.dart';
import 'package:tasky/domain/failures/failures.dart';
import 'package:tasky/infrastructure/datasources/remote_data_source.dart';
import 'package:tasky/infrastructure/models/task_model.dart';
import 'package:tasky/infrastructure/models/user_model.dart';
import 'package:tasky/infrastructure/repositories/archive_repository_impl.dart';
import 'package:tasky/domain/failures/server_failure.dart';
import 'package:tasky/domain/repositories/archive_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../mocks/mock_remote_data_source.dart';

void main() {
  ArchiveRepository repository;
  RemoteDataSource dataSource;

  setUpAll(() {
    dataSource = MockRemoteDataSource();
    repository = ArchiveRepositoryImpl(dataSource: dataSource);
  });

  tearDownAll(() {
    repository = null;
    dataSource = null;
  });

  test("get archived tasks returns some data", () async {
    when(dataSource)
        .calls(#getArchivedTasks)
        .thenAnswer((_) async => Either<Failure, List<TaskModel>>.right([
              TaskModel(
                id: "mock_id_1",
                title: "title",
                description: "description",
                labels: null,
                author: UserModel(
                  id: "mock_id_1",
                  name: "Mock User 1",
                  email: "mock1@email.com",
                  profileColor: null,
                ),
                members: null,
                checklists: null,
                comments: null,
                expireDate: null,
                archived: false,
                creationDate: DateTime.parse("2020-12-01"),
              ),
              TaskModel(
                id: "mock_id_2",
                title: "title",
                description: "description",
                labels: null,
                author: UserModel(
                  id: "mock_id_2",
                  name: "Mock User 2",
                  email: "mock1@email.com",
                  profileColor: null,
                ),
                members: null,
                checklists: null,
                comments: null,
                expireDate: null,
                archived: false,
                creationDate: DateTime.parse("2020-12-01"),
              ),
            ]));
    final res = await repository.watchArchivedTasks().first;

    expect(res.isRight(), isTrue);
    expect(res.getOrNull(), isNotNull);
    expect(res.getOrNull(), hasLength(2));
  });

  test("get archived tasks returns empty", () async {
    when(dataSource)
        .calls(#getArchivedTasks)
        .thenAnswer((_) async => Either<Failure, List<TaskModel>>.right([]));
    final res = await repository.watchArchivedTasks().first;
    expect(res.isRight(), isTrue);
    expect(res.getOrNull(), isNotNull);
    expect(res.getOrNull(), isEmpty);
  });

  test("get archived tasks returns error", () async {
    when(dataSource).calls(#getArchivedTasks).thenAnswer((_) async =>
        Either<Failure, List<TaskModel>>.left(
            ServerFailure.unexpectedError("")));
    final res = await repository.watchArchivedTasks().first;
    expect(res.isLeft(), isTrue);

    when(dataSource)
        .calls(#getArchivedTasks)
        .thenAnswer((_) async => throw Error());
    final res2 = await repository.watchArchivedTasks().first;
    expect(res2.isLeft(), isTrue);
  });
}
