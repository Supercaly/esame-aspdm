import 'package:aspdm_project/core/either.dart';
import 'package:aspdm_project/infrastructure/datasources/remote_data_source.dart';
import 'package:aspdm_project/infrastructure/models/user_model.dart';
import 'package:aspdm_project/infrastructure/repositories/auth_repository_impl.dart';
import 'package:aspdm_project/domain/entities/user.dart';
import 'package:aspdm_project/domain/repositories/auth_repository.dart';
import 'package:aspdm_project/domain/values/unique_id.dart';
import 'package:aspdm_project/domain/values/user_values.dart';
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
      UniqueId("mock_id"),
      UserName("Mock User"),
      EmailAddress("mock@email.com"),
      null,
    ));
    final user = repository.lastSignedInUser;

    expect(user.isRight(), isTrue);
    expect((user as Right).value, isA<User>());
    verify(preferenceService.getLastSignedInUser()).called(1);
  });

  test("login returns the logged in user", () async {
    when(dataSource.authenticate(any, any)).thenAnswer((_) async => UserModel(
          "mock_id",
          "Mock User",
          "mock@email.com",
          null,
        ));
    final user = await repository.login(
        EmailAddress("user@email.com"), Password("1234"));

    expect(user.isRight(), isTrue);
    expect((user as Right).value, isA<User>());
    verify(preferenceService.storeSignedInUser(any)).called(1);
  });

  test("login returns an error on wrong credential", () async {
    when(dataSource.authenticate(any, any)).thenAnswer((_) async => null);
    final res = await repository.login(
        EmailAddress("user@email.com"), Password("1234"));

    expect(res.isLeft(), isTrue);
    verifyNever(preferenceService.storeSignedInUser(any));
  });

  test("login returns an error on server failure", () async {
    when(dataSource.authenticate(any, any))
        .thenAnswer((_) async => throw Error());
    final res = await repository.login(
        EmailAddress("user@email.com"), Password("1234"));

    expect(res.isLeft(), isTrue);
    verifyNever(preferenceService.storeSignedInUser(any));
  });

  test("logout logs out the user", () async {
    final res = await repository.logout();

    verify(preferenceService.storeSignedInUser(null)).called(1);
    expect(res.isRight(), isTrue);
  });
}
