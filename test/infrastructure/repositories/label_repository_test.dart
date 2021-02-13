import 'package:tasky/core/either.dart';
import 'package:tasky/domain/repositories/label_repository.dart';
import 'package:tasky/infrastructure/datasources/remote_data_source.dart';
import 'package:tasky/infrastructure/models/label_model.dart';
import 'package:tasky/domain/failures/server_failure.dart';
import 'package:tasky/infrastructure/repositories/label_repository_impl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../mocks/mock_remote_data_source.dart';

void main() {
  LabelRepository repository;
  RemoteDataSource dataSource;

  setUpAll(() {
    dataSource = MockRemoteDataSource();
    repository = LabelRepositoryImpl(dataSource);
  });

  tearDownAll(() {
    repository = null;
    dataSource = null;
  });

  test("get labels returns some data", () async {
    when(dataSource.getLabels()).thenAnswer((_) async => Either.right([
          LabelModel("label1", Colors.red, "label1"),
          LabelModel("label2", Colors.blue, "label2"),
        ]));
    final res = await repository.getLabels();

    expect(res.isRight(), isTrue);
    expect(res.getOrNull(), isNotNull);
    expect(res.getOrNull(), hasLength(2));
  });

  test("get labels returns empty", () async {
    when(dataSource.getLabels())
        .thenAnswer((_) async => Either.right(List.empty()));
    final res = await repository.getLabels();
    expect(res.isRight(), isTrue);
    expect(res.getOrNull(), isNotNull);
    expect(res.getOrNull(), isEmpty);
  });

  test("get labels returns error", () async {
    when(dataSource.getLabels()).thenAnswer(
        (_) async => Either.left(ServerFailure.unexpectedError("")));
    final res = await repository.getLabels();
    expect(res.isLeft(), isTrue);

    when(dataSource.getLabels()).thenAnswer((_) async => throw Error());
    final res2 = await repository.getLabels();
    expect(res2.isLeft(), isTrue);
  });
}
