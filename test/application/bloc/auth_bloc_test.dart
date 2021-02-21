import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tasky/application/bloc/auth_bloc.dart';
import 'package:tasky/core/maybe.dart';
import 'package:tasky/domain/entities/user.dart';
import 'package:tasky/domain/repositories/auth_repository.dart';
import 'package:tasky/domain/values/unique_id.dart';
import 'package:tasky/domain/values/user_values.dart';

import '../../mocks/mock_auth_repository.dart';

void main() {
  group("AuthBloc test", () {
    AuthRepository repository;

    setUpAll(() {
      repository = MockAuthRepository();
    });

    blocTest(
      "emits initial state",
      build: () => AuthBloc(repository: repository),
      expect: [],
    );

    blocTest(
      "check auth emits authenticated state",
      build: () => AuthBloc(repository: repository),
      act: (AuthBloc cubit) {
        when(repository.getSignedInUser()).thenAnswer(
          (_) async => Maybe.just(
            User.test(
              id: UniqueId("user_id"),
              name: UserName("User"),
              email: EmailAddress("user@email.com"),
            ),
          ),
        );
        cubit.checkAuth();
      },
      expect: [
        AuthState.authenticated(
          Maybe.just(
            User.test(
              id: UniqueId("user_id"),
              name: UserName("User"),
              email: EmailAddress("user@email.com"),
            ),
          ),
        ),
      ],
    );

    blocTest(
      "check auth emits unauthenticated state",
      build: () => AuthBloc(repository: repository),
      act: (AuthBloc cubit) {
        when(repository.getSignedInUser())
            .thenAnswer((_) async => Maybe.nothing());
        cubit.checkAuth();
      },
      expect: [
        AuthState.unauthenticated(
          Maybe.nothing(),
        ),
      ],
    );

    blocTest(
      "logout emits unauthenticated state",
      build: () => AuthBloc(repository: repository),
      act: (AuthBloc cubit) {
        when(repository.logout()).thenAnswer((_) async => Maybe.nothing());
        cubit.logOut();
      },
      expect: [
        AuthState.unauthenticated(
          Maybe.nothing(),
        ),
      ],
    );
  });
}
