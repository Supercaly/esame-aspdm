import 'package:aspdm_project/core/either.dart';
import 'package:aspdm_project/core/maybe.dart';
import 'package:aspdm_project/domain/entities/user.dart';
import 'package:aspdm_project/domain/failures/server_failure.dart';
import 'package:aspdm_project/domain/repositories/auth_repository.dart';
import 'package:aspdm_project/domain/values/unique_id.dart';
import 'package:aspdm_project/domain/values/user_values.dart';
import 'package:aspdm_project/services/log_service.dart';
import 'package:aspdm_project/application/states/auth_state.dart';
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
    expect(AuthState(repository).currentUser.isNothing(), isTrue);

    when(repository.lastSignedInUser).thenReturn(
      Maybe.just(User(
        UniqueId("mock_id"),
        UserName("Mock User"),
        EmailAddress("mock.user@email.it"),
        null,
      )),
    );
    expect(
      AuthState(repository).currentUser.getOrNull(),
      equals(User(
        UniqueId("mock_id"),
        UserName("Mock User"),
        EmailAddress("mock.user@email.it"),
        null,
      )),
    );
  });

  test("is loading returns the correct value", () {
    when(repository.lastSignedInUser).thenReturn(Maybe.nothing());
    final state = AuthState(repository);

    expect(state.isLoading, isFalse);
  });

  test("login with correct data logs the user", () async {
    when(repository.lastSignedInUser).thenReturn(Maybe.nothing());
    when(repository.login(any, any)).thenAnswer((_) async => Either.right(User(
          UniqueId("mock_id"),
          UserName("Mock Name"),
          EmailAddress("mock@email.com"),
          null,
        )));

    final authState = AuthState(repository);
    final res = await authState.login(
      EmailAddress("test@email.com"),
      Password("password"),
    );

    expect(res, isA<Right>());
    expect((res as Right).value, isA<Unit>());
    expect(
      authState.currentUser.getOrNull(),
      equals(User(
        UniqueId("mock_id"),
        UserName("Mock Name"),
        EmailAddress("mock@email.com"),
        null,
      )),
    );
  });

  test("login with error return either with left side", () async {
    when(repository.lastSignedInUser).thenReturn(Maybe.nothing());
    when(repository.login(any, any)).thenAnswer(
        (_) async => Either.left(ServerFailure.unexpectedError("")));

    final authState = AuthState(repository);
    final res = await authState.login(
      EmailAddress("test@email.com"),
      Password("password"),
    );

    expect(res.isLeft(), isTrue);
    expect(authState.currentUser.isNothing(), isTrue);
  });

  test("logout sets currentUser to null", () async {
    when(repository.lastSignedInUser).thenReturn(Maybe.just(User(
      UniqueId("mock_id"),
      UserName("Mock Name"),
      EmailAddress("mock@email.com"),
      null,
    )));
    when(repository.logout()).thenAnswer((_) => null);

    final authState = AuthState(repository);

    expect(authState.currentUser.isJust(), isTrue);
    await authState.logout();
    expect(authState.currentUser.isNothing(), isTrue);
  });
}
