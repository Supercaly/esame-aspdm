import 'package:aspdm_project/core/either.dart';
import 'package:aspdm_project/domain/failures/failures.dart';
import 'package:aspdm_project/core/monad_task.dart';
import 'package:aspdm_project/domain/entities/user.dart';
import 'package:aspdm_project/domain/failures/server_failure.dart';
import 'package:aspdm_project/domain/repositories/auth_repository.dart';
import 'package:aspdm_project/infrastructure/datasources/remote_data_source.dart';
import 'package:aspdm_project/domain/values/user_values.dart';
import 'package:aspdm_project/services/preference_service.dart';

class AuthRepositoryImpl extends AuthRepository {
  RemoteDataSource _dataSource;
  PreferenceService _preferenceService;

  AuthRepositoryImpl(this._dataSource, this._preferenceService);

  @override
  Either<Failure, User> get lastSignedInUser =>
      Either.right(_preferenceService.getLastSignedInUser());

  @override
  Future<Either<Failure, User>> login(
      EmailAddress email, Password password) async {
    final result =
        await MonadTask(() => _dataSource.authenticate(email, password))
            .map((value) => value.toUser())
            .attempt((e) => ServerFailure.unexpectedError(e))
            .run();

    if (result.isRight())
      await _preferenceService.storeSignedInUser(result.getOrNull());

    return result;
  }

  @override
  Future<Either<Failure, Unit>> logout() async {
    await _preferenceService.storeSignedInUser(null);
    return Either.right(const Unit());
  }
}
