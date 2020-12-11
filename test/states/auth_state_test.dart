import 'package:aspdm_project/model/user.dart';
import 'package:aspdm_project/services/log_service.dart';
import 'package:aspdm_project/services/preference_service.dart';
import 'package:aspdm_project/states/auth_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';

import '../mocks/mock_log_service.dart';
import '../mocks/mock_preference_service.dart';

void main() {
  AuthState authState;

  setUpAll(() {
    authState = AuthState(null);
    GetIt.I.registerLazySingleton<PreferenceService>(
        () => MockPreferenceService());
    GetIt.I.registerLazySingleton<LogService>(() => MockLogService());
  });

  test("create AuthState wih user", () {
    expect(AuthState(null).currentUser, isNull);
    expect(
      AuthState(User("mock_id", "Mock User", "mock.user@email.it", null))
          .currentUser,
      equals(User("mock_id", "Mock User", "mock.user@email.it", null)),
    );
  });

  test("login with correct data logs the user", () async {
    final res = await authState.login("email", "password");

    expect(res, isTrue);
    expect(authState.currentUser, equals(User("mock_id", null, null, null)));
  });

  test("logout sets currentUser to null", () async {
    await authState.logout();

    expect(authState.currentUser, isNull);
  });
}
