import 'package:tasky/application/bloc/members_bloc.dart';
import 'package:tasky/core/either.dart';
import 'package:tasky/core/ilist.dart';
import 'package:tasky/domain/entities/user.dart';
import 'package:tasky/domain/repositories/members_repository.dart';
import 'package:tasky/domain/values/unique_id.dart';
import 'package:tasky/domain/values/user_values.dart';
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
      build: () => MembersBloc(repository: repository),
      expect: [],
    );

    blocTest(
      "emits data on success",
      build: () => MembersBloc(repository: repository),
      act: (MembersBloc bloc) {
        when(repository.getUsers())
            .thenAnswer((_) => Future.value(Either.right(IList.empty())));
        bloc.fetch();
      },
      expect: [
        MembersState(IList.empty(), IList.empty(), true, false),
        MembersState(IList.empty(), IList.empty(), false, false),
      ],
    );

    blocTest(
      "emits error on error",
      build: () => MembersBloc(repository: repository),
      act: (MembersBloc bloc) {
        when(repository.getUsers())
            .thenAnswer((_) => Future.value(Either.left(MockFailure())));
        bloc.fetch();
      },
      expect: [
        MembersState(IList.empty(), IList.empty(), true, false),
        MembersState(IList.empty(), IList.empty(), false, true),
      ],
    );

    blocTest(
      "emits on select",
      build: () => MembersBloc(repository: repository),
      act: (MembersBloc bloc) async {
        when(repository.getUsers()).thenAnswer((_) async => Either.right(
              IList.from([
                User(UniqueId("user1"), UserName("User 1"),
                    EmailAddress("user1@email.com"), null),
                User(UniqueId("user2"), UserName("User 2"),
                    EmailAddress("user2@email.com"), null),
                User(UniqueId("user3"), UserName("User 3"),
                    EmailAddress("user3@email.com"), null),
              ]),
            ));
        await bloc.fetch();
        bloc.selectMember(
          User(UniqueId("user2"), UserName("User 2"),
              EmailAddress("user2@email.com"), null),
        );
      },
      expect: [
        MembersState(IList.empty(), IList.empty(), true, false),
        MembersState(
            IList.empty(),
            IList.from([
              User(UniqueId("user1"), UserName("User 1"),
                  EmailAddress("user1@email.com"), null),
              User(UniqueId("user2"), UserName("User 2"),
                  EmailAddress("user2@email.com"), null),
              User(UniqueId("user3"), UserName("User 3"),
                  EmailAddress("user3@email.com"), null),
            ]),
            false,
            false),
        MembersState(
            IList.from([
              User(UniqueId("user2"), UserName("User 2"),
                  EmailAddress("user2@email.com"), null),
            ]),
            IList.from([
              User(UniqueId("user1"), UserName("User 1"),
                  EmailAddress("user1@email.com"), null),
              User(UniqueId("user2"), UserName("User 2"),
                  EmailAddress("user2@email.com"), null),
              User(UniqueId("user3"), UserName("User 3"),
                  EmailAddress("user3@email.com"), null),
            ]),
            false,
            false),
      ],
    );

    blocTest(
      "emits on deselect",
      build: () => MembersBloc(
        initialValue: IList.from([
          User(UniqueId("user1"), UserName("User 1"),
              EmailAddress("user1@email.com"), null),
          User(UniqueId("user2"), UserName("User 2"),
              EmailAddress("user2@email.com"), null),
          User(UniqueId("user3"), UserName("User 3"),
              EmailAddress("user3@email.com"), null),
        ]),
        repository: repository,
      ),
      act: (MembersBloc bloc) {
        bloc.deselectMember(
          User(UniqueId("user2"), UserName("User 2"),
              EmailAddress("user2@email.com"), null),
        );
      },
      expect: [
        MembersState(
            IList.from([
              User(UniqueId("user1"), UserName("User 1"),
                  EmailAddress("user1@email.com"), null),
              User(UniqueId("user3"), UserName("User 3"),
                  EmailAddress("user3@email.com"), null),
            ]),
            IList.empty(),
            false,
            false),
      ],
    );
  });
}
