import 'package:tasky/core/either.dart';
import 'package:tasky/core/maybe.dart';
import 'package:tasky/domain/entities/user.dart';
import 'package:tasky/domain/failures/server_failure.dart';
import 'package:tasky/domain/repositories/auth_repository.dart';
import 'package:tasky/domain/values/unique_id.dart';
import 'package:tasky/domain/values/user_values.dart';
import 'package:tasky/services/log_service.dart';
import 'package:tasky/application/states/auth_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/mockito.dart';

import '../../mocks/mock_auth_repository.dart';
import '../../mocks/mock_log_service.dart';

void main() {
  AuthRepository repository;

  setUpAll(() {
    repository = MockAuthRepository();
    GetIt.I.registerLazySingleton<LogService>(() => MockLogService());
  });

  test("create AuthState wih user", () {
    when(repository.lastSignedInUser).thenReturn(Maybe.nothing());
    expect(AuthState(repository: repository).currentUser.isNothing(), isTrue);

    when(repository.lastSignedInUser).thenReturn(
      Maybe.just(User(
        id: UniqueId("mock_id"),
        name: UserName("Mock User"),
        email: EmailAddress("mock.user@email.it"),
        profileColor: null,
      )),
    );
    expect(
      AuthState(repository: repository).currentUser.getOrNull(),
      equals(User(
        id: UniqueId("mock_id"),
        name: UserName("Mock User"),
        email: EmailAddress("mock.user@email.it"),
        profileColor: null,
      )),
    );
  });

  test("is loading returns the correct value", () {
    when(repository.lastSignedInUser).thenReturn(Maybe.nothing());
    final state = AuthState(repository: repository);

    expect(state.isLoading, isFalse);
  });

  test("login with correct data logs the user", () async {
    when(repository.lastSignedInUser).thenReturn(Maybe.nothing());
    when(repository.login(any, any)).thenAnswer((_) async => Either.right(User(
          id: UniqueId("mock_id"),
          name: UserName("Mock Name"),
          email: EmailAddress("mock@email.com"),
          profileColor: null,
        )));

    final authState = AuthState(repository: repository);
    final res = await authState.login(
      EmailAddress("test@email.com"),
      Password("password"),
    );

    expect(res, isA<Right>());
    expect((res as Right).value, isA<Unit>());
    expect(
      authState.currentUser.getOrNull(),
      equals(User(
        id: UniqueId("mock_id"),
        name: UserName("Mock Name"),
        email: EmailAddress("mock@email.com"),
        profileColor: null,
      )),
    );
  });

  test("login with error return either with left side", () async {
    when(repository.lastSignedInUser).thenReturn(Maybe.nothing());
    when(repository.login(any, any)).thenAnswer(
        (_) async => Either.left(ServerFailure.unexpectedError("")));

    final authState = AuthState(repository: repository);
    final res = await authState.login(
      EmailAddress("test@email.com"),
      Password("password"),
    );

    expect(res.isLeft(), isTrue);
    expect(authState.currentUser.isNothing(), isTrue);
  });

  test("logout sets currentUser to null", () async {
    when(repository.lastSignedInUser).thenReturn(Maybe.just(User(
      id: UniqueId("mock_id"),
      name: UserName("Mock Name"),
      email: EmailAddress("mock@email.com"),
      profileColor: null,
    )));
    when(repository.logout()).thenAnswer((_) => null);

    final authState = AuthState(repository: repository);

    expect(authState.currentUser.isJust(), isTrue);
    await authState.logout();
    expect(authState.currentUser.isNothing(), isTrue);
  });
}
