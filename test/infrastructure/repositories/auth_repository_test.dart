import 'package:tasky/core/either.dart';
import 'package:tasky/core/maybe.dart';
import 'package:tasky/domain/failures/invalid_user_failure.dart';
import 'package:tasky/domain/failures/server_failure.dart';
import 'package:tasky/infrastructure/datasources/remote_data_source.dart';
import 'package:tasky/infrastructure/models/user_model.dart';
import 'package:tasky/infrastructure/repositories/auth_repository_impl.dart';
import 'package:tasky/domain/entities/user.dart';
import 'package:tasky/domain/repositories/auth_repository.dart';
import 'package:tasky/domain/values/unique_id.dart';
import 'package:tasky/domain/values/user_values.dart';
import 'package:tasky/services/preference_service.dart';
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
    repository = AuthRepositoryImpl(
      dataSource: dataSource,
      preferenceService: preferenceService,
    );
  });

  tearDownAll(() {
    repository = null;
    dataSource = null;
    preferenceService = null;
  });

  test("get signed in user returns a user", () async {
    when(preferenceService.getLastSignedInUser()).thenReturn(Maybe.just(User(
      id: UniqueId("mock_id"),
      name: UserName("Mock User"),
      email: EmailAddress("mock@email.com"),
      profileColor: null,
    )));
    final user = await repository.getSignedInUser();

    expect(user.isJust(), isTrue);
    expect(user.getOrNull(), isNotNull);
    expect(user.getOrNull(), isA<User>());
    verify(preferenceService.getLastSignedInUser()).called(1);
  });

  test("login returns the logged in user", () async {
    when(dataSource.authenticate(any, any))
        .thenAnswer((_) async => Either.right(UserModel(
              id: "mock_id",
              name: "Mock User",
              email: "mock@email.com",
              profileColor: null,
            )));
    final user = await repository.login(
        EmailAddress("user@email.com"), Password("1234"));

    expect(user.isRight(), isTrue);
    expect(user.getOrNull(), isNotNull);
    expect(user.getOrNull(), isA<User>());
    verify(preferenceService.storeSignedInUser(any)).called(1);
  });

  test("login returns an error on wrong credential", () async {
    when(dataSource.authenticate(any, any)).thenAnswer((r) async => Either.left(
          InvalidUserFailure(
            email: EmailAddress("user@email.com"),
            password: Password("1234"),
          ),
        ));
    final res = await repository.login(
        EmailAddress("user@email.com"), Password("1234"));

    expect(res.isLeft(), isTrue);
    expect((res as Left).value, isA<InvalidUserFailure>());
    verifyNever(preferenceService.storeSignedInUser(any));
  });

  test("login returns an error on server failure", () async {
    when(dataSource.authenticate(any, any)).thenAnswer(
        (_) async => Either.left(ServerFailure.unexpectedError("")));
    final res = await repository.login(
        EmailAddress("user@email.com"), Password("1234"));

    expect(res.isLeft(), isTrue);
    verifyNever(preferenceService.storeSignedInUser(any));
  });

  test("logout logs out the user", () async {
    await repository.logout();
    verify(preferenceService.storeSignedInUser(any)).called(1);
  });
}
