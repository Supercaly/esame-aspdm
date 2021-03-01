import 'package:tasky/core/either.dart';
import 'package:tasky/application/bloc/archive_bloc.dart';
import 'package:tasky/core/ilist.dart';
import 'package:tasky/domain/repositories/archive_repository.dart';
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
      build: () => ArchiveBloc(repository: repository),
      expect: () => [],
    );

    blocTest(
      "emits data on success",
      build: () => ArchiveBloc(repository: repository),
      act: (ArchiveBloc bloc) {
        when(repository.watchArchivedTasks())
            .thenAnswer((_) => Stream.value(Either.right(IList.empty())));
        bloc.fetch();
      },
      expect: () => [
        ArchiveState(IList.empty(), false, true),
        ArchiveState(IList.empty(), false, false),
      ],
    );

    blocTest(
      "emits error on error",
      build: () => ArchiveBloc(repository: repository),
      act: (ArchiveBloc bloc) {
        when(repository.watchArchivedTasks())
            .thenAnswer((_) => Stream.value(Either.left(MockFailure())));
        bloc.fetch();
      },
      expect: () => [
        ArchiveState(IList.empty(), false, true),
        ArchiveState(IList.empty(), true, false),
      ],
    );

    blocTest(
      "don't emits loading when fetch has showLoading false",
      build: () => ArchiveBloc(repository: repository),
      act: (ArchiveBloc bloc) {
        when(repository.watchArchivedTasks())
            .thenAnswer((_) => Stream.value(Either.right(IList.empty())));
        bloc.fetch(showLoading: false);
      },
      expect: () => [
        ArchiveState(IList.empty(), false, false),
      ],
    );
  });
}
