import 'package:aspdm_project/bloc/archive_bloc.dart';
import 'package:aspdm_project/repositories/archive_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

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
        when(repository.getArchivedTasks()).thenAnswer((_) => Future.value([]));
        bloc.fetch();
      },
      expect: [
        ArchiveState.loading([]),
        ArchiveState.data([]),
      ],
    );

    blocTest(
      "emits error on error",
      build: () => ArchiveBloc(repository),
      act: (ArchiveBloc bloc) {
        when(repository.getArchivedTasks())
            .thenAnswer((_) => Future.error(Error()));
        bloc.fetch();
      },
      expect: [
        ArchiveState.loading([]),
        ArchiveState.error([]),
      ],
    );

    blocTest(
      "don't emits loading when fetch has showLoading false",
      build: () => ArchiveBloc(repository),
      act: (ArchiveBloc bloc) {
        when(repository.getArchivedTasks()).thenAnswer((_) => Future.value([]));
        bloc.fetch(showLoading: false);
      },
      expect: [
        ArchiveState.data([]),
      ],
    );

    blocTest(
      "emits empty data when repository returns null",
      build: () => ArchiveBloc(repository),
      act: (ArchiveBloc bloc) {
        when(repository.getArchivedTasks())
            .thenAnswer((_) => Future.value(null));
        bloc.fetch();
      },
      expect: [
        ArchiveState.loading([]),
        ArchiveState.data([]),
      ],
    );
  });
}
