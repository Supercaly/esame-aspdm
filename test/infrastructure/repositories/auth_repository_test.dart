import 'package:tasky/core/either.dart';
import 'package:tasky/core/maybe.dart';
import 'package:tasky/domain/failures/failures.dart';
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
import 'package:mocktail/mocktail.dart';

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
    when(preferenceService)
        .calls(#getLastSignedInUser)
        .thenReturn(Maybe.just(User.test(
          id: UniqueId("mock_id"),
          name: UserName("Mock User"),
          email: EmailAddress("mock@email.com"),
        )));
    final user = await repository.getSignedInUser();

    expect(user.isJust(), isTrue);
    expect(user.getOrNull(), isNotNull);
    expect(user.getOrNull(), isA<User>());
    verify(preferenceService).called(#getLastSignedInUser).once();
  });

  test("login returns the logged in user", () async {
    when(preferenceService).calls(#storeSignedInUser).thenReturn();
    when(dataSource)
        .calls(#authenticate)
        .thenAnswer((_) async => Either<Failure, UserModel>.right(UserModel(
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
    verify(preferenceService).called(#storeSignedInUser).once();
  });

  test("login returns an error on wrong credential", () async {
    when(preferenceService).calls(#storeSignedInUser).thenReturn();
    when(dataSource)
        .calls(#authenticate)
        .thenAnswer((r) async => Either<Failure, UserModel>.left(
              InvalidUserFailure(
                email: EmailAddress("user@email.com"),
                password: Password("1234"),
              ),
            ));
    final res = await repository.login(
        EmailAddress("user@email.com"), Password("1234"));

    expect(res.isLeft(), isTrue);
    expect((res as Left).value, isA<InvalidUserFailure>());
    verify(preferenceService).called(#storeSignedInUser).never();
  });

  test("login returns an error on server failure", () async {
    when(preferenceService).calls(#storeSignedInUser).thenReturn();
    when(dataSource).calls(#authenticate).thenAnswer((_) async =>
        Either<Failure, UserModel>.left(ServerFailure.unexpectedError("")));
    final res = await repository.login(
        EmailAddress("user@email.com"), Password("1234"));

    expect(res.isLeft(), isTrue);
    verify(preferenceService).called(#storeSignedInUser).never();
  });

  test("logout logs out the user", () async {
    when(preferenceService).calls(#storeSignedInUser).thenReturn();
    await repository.logout();
    verify(preferenceService).called(#storeSignedInUser).once();
  });
}
