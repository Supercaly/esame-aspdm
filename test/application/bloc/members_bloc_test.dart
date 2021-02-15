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
      build: () => MembersBloc(initialValue: null, repository: repository),
      expect: [],
    );

    blocTest(
      "emits data on success",
      build: () => MembersBloc(initialValue: null, repository: repository),
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
      build: () => MembersBloc(initialValue: null, repository: repository),
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
      build: () => MembersBloc(initialValue: null, repository: repository),
      act: (MembersBloc bloc) async {
        when(repository.getUsers()).thenAnswer((_) async => Either.right(
              IList.from([
                User(
                  id: UniqueId("user1"),
                  name: UserName("User 1"),
                  email: EmailAddress("user1@email.com"),
                  profileColor: null,
                ),
                User(
                  id: UniqueId("user2"),
                  name: UserName("User 2"),
                  email: EmailAddress("user2@email.com"),
                  profileColor: null,
                ),
                User(
                  id: UniqueId("user3"),
                  name: UserName("User 3"),
                  email: EmailAddress("user3@email.com"),
                  profileColor: null,
                ),
              ]),
            ));
        await bloc.fetch();
        bloc.selectMember(
          User(
            id: UniqueId("user2"),
            name: UserName("User 2"),
            email: EmailAddress("user2@email.com"),
            profileColor: null,
          ),
        );
      },
      expect: [
        MembersState(IList.empty(), IList.empty(), true, false),
        MembersState(
            IList.empty(),
            IList.from([
              User(
                id: UniqueId("user1"),
                name: UserName("User 1"),
                email: EmailAddress("user1@email.com"),
                profileColor: null,
              ),
              User(
                id: UniqueId("user2"),
                name: UserName("User 2"),
                email: EmailAddress("user2@email.com"),
                profileColor: null,
              ),
              User(
                id: UniqueId("user3"),
                name: UserName("User 3"),
                email: EmailAddress("user3@email.com"),
                profileColor: null,
              ),
            ]),
            false,
            false),
        MembersState(
            IList.from([
              User(
                id: UniqueId("user2"),
                name: UserName("User 2"),
                email: EmailAddress("user2@email.com"),
                profileColor: null,
              ),
            ]),
            IList.from([
              User(
                id: UniqueId("user1"),
                name: UserName("User 1"),
                email: EmailAddress("user1@email.com"),
                profileColor: null,
              ),
              User(
                id: UniqueId("user2"),
                name: UserName("User 2"),
                email: EmailAddress("user2@email.com"),
                profileColor: null,
              ),
              User(
                id: UniqueId("user3"),
                name: UserName("User 3"),
                email: EmailAddress("user3@email.com"),
                profileColor: null,
              ),
            ]),
            false,
            false),
      ],
    );

    blocTest(
      "emits on deselect",
      build: () => MembersBloc(
        initialValue: IList.from([
          User(
            id: UniqueId("user1"),
            name: UserName("User 1"),
            email: EmailAddress("user1@email.com"),
            profileColor: null,
          ),
          User(
            id: UniqueId("user2"),
            name: UserName("User 2"),
            email: EmailAddress("user2@email.com"),
            profileColor: null,
          ),
          User(
            id: UniqueId("user3"),
            name: UserName("User 3"),
            email: EmailAddress("user3@email.com"),
            profileColor: null,
          ),
        ]),
        repository: repository,
      ),
      act: (MembersBloc bloc) {
        bloc.deselectMember(
          User(
            id: UniqueId("user2"),
            name: UserName("User 2"),
            email: EmailAddress("user2@email.com"),
            profileColor: null,
          ),
        );
      },
      expect: [
        MembersState(
            IList.from([
              User(
                id: UniqueId("user1"),
                name: UserName("User 1"),
                email: EmailAddress("user1@email.com"),
                profileColor: null,
              ),
              User(
                id: UniqueId("user3"),
                name: UserName("User 3"),
                email: EmailAddress("user3@email.com"),
                profileColor: null,
              ),
            ]),
            IList.empty(),
            false,
            false),
      ],
    );
  });
}
