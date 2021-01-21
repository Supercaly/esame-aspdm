import 'package:aspdm_project/application/bloc/members_bloc.dart';
import 'package:aspdm_project/core/either.dart';
import 'package:aspdm_project/domain/repositories/members_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../mocks/mock_failure.dart';

class MockMembersRepository extends Mock implements MembersRepository {}

void main() {
  group("MembersBloc Tests", () {
    MembersRepository repository;

    setUp(() {
      repository = MockMembersRepository();
    });

    blocTest(
      "emits nothing when created",
      build: () => MembersBloc(repository),
      expect: [],
    );

    blocTest(
      "emits data on success",
      build: () => MembersBloc(repository),
      act: (MembersBloc bloc) {
        when(repository.getUsers())
            .thenAnswer((_) => Future.value(Either.right([])));
        bloc.fetch();
      },
      expect: [
        MembersState.loading(),
        MembersState.data([]),
      ],
    );

    blocTest(
      "emits error on error",
      build: () => MembersBloc(repository),
      act: (MembersBloc bloc) {
        when(repository.getUsers())
            .thenAnswer((_) => Future.value(Either.left(MockFailure())));
        bloc.fetch();
      },
      expect: [
        MembersState.loading(),
        MembersState.error(),
      ],
    );
  });
}
