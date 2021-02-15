import 'package:tasky/core/either.dart';
import 'package:tasky/domain/repositories/members_repository.dart';
import 'package:tasky/infrastructure/datasources/remote_data_source.dart';
import 'package:tasky/domain/failures/server_failure.dart';
import 'package:tasky/infrastructure/models/user_model.dart';
import 'package:tasky/infrastructure/repositories/members_repository_impl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../mocks/mock_remote_data_source.dart';

void main() {
  MembersRepository repository;
  RemoteDataSource dataSource;

  setUpAll(() {
    dataSource = MockRemoteDataSource();
    repository = MembersRepositoryImpl(dataSource: dataSource);
  });

  tearDownAll(() {
    repository = null;
    dataSource = null;
  });

  test("get users returns some data", () async {
    when(dataSource.getUsers()).thenAnswer((_) async => Either.right([
          UserModel(
            id: "user1",
            name: "user 1 name",
            email: "user1@email.com",
            profileColor: Colors.red,
          ),
          UserModel(
            id: "user2",
            name: "user 2 name",
            email: "user2@email.com",
            profileColor: Colors.blue,
          ),
        ]));
    final res = await repository.getUsers();

    expect(res.isRight(), isTrue);
    expect(res.getOrNull(), isNotNull);
    expect(res.getOrNull(), hasLength(2));
  });

  test("get users returns empty", () async {
    when(dataSource.getUsers())
        .thenAnswer((_) async => Either.right(List.empty()));
    final res = await repository.getUsers();
    expect(res.isRight(), isTrue);
    expect(res.getOrNull(), isNotNull);
    expect(res.getOrNull(), isEmpty);
  });

  test("get users returns error", () async {
    when(dataSource.getUsers()).thenAnswer(
        (_) async => Either.left(ServerFailure.unexpectedError("")));
    final res = await repository.getUsers();
    expect(res.isLeft(), isTrue);

    when(dataSource.getUsers()).thenAnswer((_) async => throw Error());
    final res2 = await repository.getUsers();
    expect(res2.isLeft(), isTrue);
  });
}
