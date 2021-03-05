import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
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
      expect: () => [],
    );

    blocTest(
      "check auth emits authenticated state",
      build: () => AuthBloc(repository: repository),
      act: (AuthBloc cubit) {
        when(repository).calls(#getSignedInUser).thenAnswer(
              (_) async => Maybe<User>.just(
                User.test(
                  id: UniqueId("user_id"),
                  name: UserName("User"),
                  email: EmailAddress("user@email.com"),
                ),
              ),
            );
        cubit.checkAuth();
      },
      expect: () => [
        AuthState.authenticated(
          Maybe<User>.just(
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
        when(repository)
            .calls(#getSignedInUser)
            .thenAnswer((_) async => Maybe<User>.nothing());
        cubit.checkAuth();
      },
      expect: () => [
        AuthState.unauthenticated(
          Maybe<User>.nothing(),
        ),
      ],
    );

    blocTest(
      "logout emits unauthenticated state",
      build: () => AuthBloc(repository: repository),
      act: (AuthBloc cubit) {
        when(repository)
            .calls(#logout)
            .thenAnswer((_) async => Maybe<User>.nothing());
        cubit.logOut();
      },
      expect: () => [
        AuthState.unauthenticated(
          Maybe<User>.nothing(),
        ),
      ],
    );
  });
}
