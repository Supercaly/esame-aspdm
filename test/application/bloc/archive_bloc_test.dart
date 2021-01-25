import 'package:aspdm_project/core/either.dart';
import 'package:aspdm_project/application/bloc/archive_bloc.dart';
import 'package:aspdm_project/domain/repositories/archive_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../mocks/mock_failure.dart';

class MockArchiveRepository extends Mock implements ArchiveRepository {}

void main() {
  group("ArchiveBloc Tests", () {
    ArchiveRepository repository;

    setUp(() {
      repository = MockArchiveRepository();
    });

    blocTest(
      "emits nothing when created",
      build: () => ArchiveBloc(repository),
      expect: [],
    );

    blocTest(
      "emits data on success",
      build: () => ArchiveBloc(repository),
      act: (ArchiveBloc bloc) {
        when(repository.getArchivedTasks())
            .thenAnswer((_) => Future.value(Either.right([])));
        bloc.fetch();
      },
      expect: [
        ArchiveState([], false, true),
        ArchiveState([], false, false),
      ],
    );

    blocTest(
      "emits error on error",
      build: () => ArchiveBloc(repository),
      act: (ArchiveBloc bloc) {
        when(repository.getArchivedTasks())
            .thenAnswer((_) => Future.value(Either.left(MockFailure())));
        bloc.fetch();
      },
      expect: [
        ArchiveState([], false, true),
        ArchiveState([], true, false),
      ],
    );

    blocTest(
      "don't emits loading when fetch has showLoading false",
      build: () => ArchiveBloc(repository),
      act: (ArchiveBloc bloc) {
        when(repository.getArchivedTasks())
            .thenAnswer((_) => Future.value(Either.right([])));
        bloc.fetch(showLoading: false);
      },
      expect: [
        ArchiveState([], false, false),
      ],
    );
  });
}
