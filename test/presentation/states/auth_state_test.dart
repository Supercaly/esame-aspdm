import 'package:aspdm_project/domain/entities/user.dart';
import 'package:aspdm_project/domain/repositories/auth_repository.dart';
import 'package:aspdm_project/services/log_service.dart';
import 'package:aspdm_project/presentation/states/auth_state.dart';
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
    when(repository.lastSignedInUser).thenReturn(null);
    expect(AuthState(repository).currentUser, isNull);

    when(repository.lastSignedInUser)
        .thenReturn(User("mock_id", "Mock User", "mock.user@email.it", null));
    expect(
      AuthState(repository).currentUser,
      equals(User("mock_id", "Mock User", "mock.user@email.it", null)),
    );
  });

  test("login with correct data logs the user", () async {
    when(repository.login(any, any)).thenAnswer(
        (_) async => User("mock_id", "Mock Name", "mock@email.com", null));

    final authState = AuthState(repository);
    final res = await authState.login("email", "password");

    expect(res, isTrue);
    expect(
      authState.currentUser,
      equals(User("mock_id", "Mock Name", "mock@email.com", null)),
    );
  });

  test("logout sets currentUser to null", () async {
    when(repository.lastSignedInUser)
        .thenReturn(User("mock_id", "Mock Name", "mock@email.com", null));
    when(repository.logout()).thenAnswer((_) => null);
    final authState = AuthState(repository);

    expect(authState.currentUser, isNotNull);
    await authState.logout();
    expect(authState.currentUser, isNull);
  });
}
