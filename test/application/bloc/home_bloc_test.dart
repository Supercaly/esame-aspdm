import 'package:aspdm_project/core/either.dart';
import 'package:aspdm_project/application/bloc/home_bloc.dart';
import 'package:aspdm_project/domain/repositories/home_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../mocks/mock_failure.dart';

class MockHomeRepository extends Mock implements HomeRepository {}

void main() {
  group("HomeBloc Tests", () {
    HomeRepository repository;

    setUp(() {
      repository = MockHomeRepository();
    });

    blocTest(
      "emits nothing when created",
      build: () => HomeBloc(repository),
      expect: [],
    );

    blocTest(
      "emits data on success",
      build: () => HomeBloc(repository),
      act: (HomeBloc bloc) {
        when(repository.getTasks())
            .thenAnswer((_) => Future.value(Either.right([])));
        bloc.fetch();
      },
      expect: [
        HomeState.loading([]),
        HomeState.data([]),
      ],
    );

    blocTest(
      "emits error on error",
      build: () => HomeBloc(repository),
      act: (HomeBloc bloc) {
        when(repository.getTasks())
            .thenAnswer((_) => Future.value(Either.left(MockFailure())));
        bloc.fetch();
      },
      expect: [
        HomeState.loading([]),
        HomeState.error([]),
      ],
    );

    blocTest(
      "don't emits loading when fetch has showLoading false",
      build: () => HomeBloc(repository),
      act: (HomeBloc bloc) {
        when(repository.getTasks())
            .thenAnswer((_) => Future.value(Either.right([])));
        bloc.fetch(showLoading: false);
      },
      expect: [
        HomeState.data([]),
      ],
    );
  });
}
