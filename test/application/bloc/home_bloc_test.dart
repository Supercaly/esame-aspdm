import 'package:tasky/core/either.dart';
import 'package:tasky/application/bloc/home_bloc.dart';
import 'package:tasky/core/ilist.dart';
import 'package:tasky/domain/entities/task.dart';
import 'package:tasky/domain/failures/failures.dart';
import 'package:tasky/domain/repositories/home_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

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
      build: () => HomeBloc(repository: repository),
      expect: () => [],
    );

    blocTest(
      "emits data on success",
      build: () => HomeBloc(repository: repository),
      act: (HomeBloc bloc) {
        when(repository).calls(#watchTasks).thenAnswer((_) =>
            Stream.value(Either<Failure, IList<Task>>.right(IList.empty())));
        bloc.fetch();
      },
      expect: () => [
        HomeState(IList.empty(), false, true),
        HomeState(IList.empty(), false, false),
      ],
    );

    blocTest(
      "emits error on error",
      build: () => HomeBloc(repository: repository),
      act: (HomeBloc bloc) {
        when(repository).calls(#watchTasks).thenAnswer((_) =>
            Stream.value(Either<Failure, IList<Task>>.left(MockFailure())));
        bloc.fetch();
      },
      expect: () => [
        HomeState(IList.empty(), false, true),
        HomeState(IList.empty(), true, false),
      ],
    );

    blocTest(
      "don't emits loading when fetch has showLoading false",
      build: () => HomeBloc(repository: repository),
      act: (HomeBloc bloc) {
        when(repository).calls(#watchTasks).thenAnswer((_) =>
            Stream.value(Either<Failure, IList<Task>>.right(IList.empty())));
        bloc.fetch(showLoading: false);
      },
      expect: () => [
        HomeState(IList.empty(), false, false),
      ],
    );
  });
}
