import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tasky/application/bloc/login_bloc.dart';
import 'package:tasky/core/either.dart';
import 'package:tasky/core/maybe.dart';
import 'package:tasky/domain/entities/user.dart';
import 'package:tasky/domain/failures/server_failure.dart';
import 'package:tasky/domain/repositories/auth_repository.dart';
import 'package:tasky/domain/values/unique_id.dart';
import 'package:tasky/domain/values/user_values.dart';

import '../../mocks/mock_auth_repository.dart';

void main() {
  group("LoginBloc test", () {
    AuthRepository repository;

    setUpAll(() {
      repository = MockAuthRepository();
    });

    blocTest(
      "emits initial state",
      build: () => LoginBloc(repository: repository),
      expect: [],
    );

    blocTest(
      "login emits loading state",
      build: () => LoginBloc(repository: repository),
      act: (LoginBloc cubit) {
        when(repository.login(any, any)).thenAnswer(
          (_) async => Either.right(
            User.test(
              id: UniqueId("user_id"),
              name: UserName("User"),
              email: EmailAddress("user@email.com"),
            ),
          ),
        );
        cubit.login(EmailAddress("user@email.com"), Password("password"));
      },
      expect: [
        LoginState(true, Maybe.nothing()),
        LoginState(
          false,
          Maybe.just(
            Either.right(
              User.test(
                id: UniqueId("user_id"),
                name: UserName("User"),
                email: EmailAddress("user@email.com"),
              ),
            ),
          ),
        ),
      ],
    );

    blocTest(
      "login emits success state",
      build: () => LoginBloc(repository: repository),
      act: (LoginBloc cubit) {
        when(repository.login(any, any)).thenAnswer(
          (_) async => Either.right(
            User.test(
              id: UniqueId("user_id"),
              name: UserName("User"),
              email: EmailAddress("user@email.com"),
            ),
          ),
        );
        cubit.login(EmailAddress("user@email.com"), Password("password"));
      },
      expect: [
        LoginState(true, Maybe.nothing()),
        LoginState(
          false,
          Maybe.just(
            Either.right(
              User.test(
                id: UniqueId("user_id"),
                name: UserName("User"),
                email: EmailAddress("user@email.com"),
              ),
            ),
          ),
        ),
      ],
    );

    blocTest(
      "login emits failure state",
      build: () => LoginBloc(repository: repository),
      act: (LoginBloc cubit) {
        when(repository.login(any, any)).thenAnswer(
            (_) async => Either.left(ServerFailure.unexpectedError("")));
        cubit.login(EmailAddress("user@email.com"), Password("password"));
      },
      expect: [
        LoginState(true, Maybe.nothing()),
        LoginState(
          false,
          Maybe.just(Either.left(ServerFailure.unexpectedError(""))),
        ),
      ],
    );
  });
}
