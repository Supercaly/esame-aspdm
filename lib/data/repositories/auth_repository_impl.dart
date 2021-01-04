import 'package:aspdm_project/core/either.dart';
import 'package:aspdm_project/core/failures.dart';
import 'package:aspdm_project/core/unit.dart';
import 'package:aspdm_project/data/models/user_model.dart';
import 'package:aspdm_project/domain/entities/user.dart';
import 'package:aspdm_project/domain/repositories/auth_repository.dart';
import 'package:aspdm_project/data/datasources/remote_data_source.dart';
import 'package:aspdm_project/services/preference_service.dart';

class AuthRepositoryImpl extends AuthRepository {
  RemoteDataSource _dataSource;
  PreferenceService _preferenceService;

  AuthRepositoryImpl(this._dataSource, this._preferenceService);

  @override
  Either<Failure, User> get lastSignedInUser =>
      Either.right(_preferenceService.getLastSignedInUser());

  @override
  Future<Either<Failure, User>> login(String email, String password) async {
    UserModel userModel;
    try {
      userModel = await _dataSource.authenticate(email, password);
    } catch (e) {
      return Either.left(ServerFailure());
    }
    if (userModel == null) return Either.left(InvalidUserFailure());

    final user = userModel.toUser();
    _preferenceService.storeSignedInUser(user);
    return Either.right(user);
  }

  @override
  Future<Either<Failure, Unit>> logout() async {
    await _preferenceService.storeSignedInUser(null);
    return Either.right(const Unit());
  }
}
