import 'package:aspdm_project/data/datasources/remote_data_source.dart';
import 'package:aspdm_project/data/models/task_model.dart';
import 'package:aspdm_project/data/models/user_model.dart';
import 'package:aspdm_project/data/repositories/archive_repository_impl.dart';
import 'package:aspdm_project/domain/repositories/archive_repository.dart';
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
    when(dataSource.getArchivedTasks()).thenAnswer((_) async => [
          TaskModel(
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
          ),
          TaskModel(
            "mock_id_2",
            "title",
            DateTime.parse("2020-12-01"),
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
          ),
        ]);
    final res = await repository.getArchivedTasks();

    expect(res, isNotNull);
    expect(res, hasLength(2));
  });

  test("get archived tasks returns empty", () async {
    when(dataSource.getArchivedTasks()).thenAnswer((_) async => []);
    final res = await repository.getArchivedTasks();

    expect(res, isNotNull);
    expect(res, isEmpty);
  });

  test("get archived tasks returns null", () async {
    when(dataSource.getArchivedTasks()).thenAnswer((_) async => null);
    final res = await repository.getArchivedTasks();

    expect(res, isNull);
  });
}
