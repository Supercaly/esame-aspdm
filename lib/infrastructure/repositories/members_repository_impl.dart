import 'package:aspdm_project/core/either.dart';
import 'package:aspdm_project/core/monad_task.dart';
import 'package:aspdm_project/domain/entities/user.dart';
import 'package:aspdm_project/domain/failures/failures.dart';
import 'package:aspdm_project/domain/repositories/members_repository.dart';
import 'package:aspdm_project/infrastructure/datasources/remote_data_source.dart';
import 'package:aspdm_project/domain/failures/server_failure.dart';

class MembersRepositoryImpl extends MembersRepository {
  final RemoteDataSource _dataSource;

  MembersRepositoryImpl(this._dataSource);

  @override
  Future<Either<Failure, List<User>>> getUsers() {
    return MonadTask(() => _dataSource.getUsers())
        .map((value) => value.map((e) => e.toUser()).toList())
        .attempt((err) => ServerFailure.unexpectedError(err))
        .run();
  }
}
