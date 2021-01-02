import 'package:aspdm_project/data/datasources/remote_data_source.dart';
import 'package:aspdm_project/data/models/user_model.dart';
import 'package:aspdm_project/data/repositories/auth_repository_impl.dart';
import 'package:aspdm_project/domain/entities/user.dart';
import 'package:aspdm_project/domain/repositories/auth_repository.dart';
import 'package:aspdm_project/services/preference_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../mocks/mock_preference_service.dart';
import '../../mocks/mock_remote_data_source.dart';

void main() {
  AuthRepository repository;
  RemoteDataSource dataSource;
  PreferenceService preferenceService;

  setUpAll(() {
    dataSource = MockRemoteDataSource();
    preferenceService = MockPreferenceService();
    repository = AuthRepositoryImpl(dataSource, preferenceService);
  });

  tearDownAll(() {
    repository = null;
    dataSource = null;
    preferenceService = null;
  });

  test("get last signed in user returns a user", () {
    when(preferenceService.getLastSignedInUser()).thenReturn(User(
      "mock_id",
      "Mock User",
      "mock@email.com",
      null,
    ));
    final user = repository.lastSignedInUser;

    expect(user, isNotNull);
    expect(user, isA<User>());
    verify(preferenceService.getLastSignedInUser()).called(1);
  });

  test("login returns the logged in user", () async {
    when(dataSource.authenticate(any, any)).thenAnswer((_) async => UserModel(
          "mock_id",
          "Mock User",
          "mock@email.com",
          null,
        ));
    final user = await repository.login("user@email.com", "1234");

    expect(user, isNotNull);
    expect(user, isA<User>());
    verify(preferenceService.storeSignedInUser(any)).called(1);
  });

  test("login throws an exception on wrong credential", () async {
    when(dataSource.authenticate(any, any)).thenAnswer((_) async => null);
    try {
      await repository.login("user@email.com", "1234");
      fail("This should throw an exception!");
    } catch (e) {
      expect(e, isA<Exception>());
    }

    verifyNever(preferenceService.storeSignedInUser(any));
  });

  test("logout logs out the user", () async {
    await repository.logout();

    verify(preferenceService.storeSignedInUser(null)).called(1);
  });
}
