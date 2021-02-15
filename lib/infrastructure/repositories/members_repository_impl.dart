import 'package:flutter/foundation.dart';
import 'package:tasky/core/either.dart';
import 'package:tasky/core/ilist.dart';
import 'package:tasky/core/monad_task.dart';
import 'package:tasky/domain/entities/user.dart';
import 'package:tasky/domain/failures/failures.dart';
import 'package:tasky/domain/repositories/members_repository.dart';
import 'package:tasky/infrastructure/datasources/remote_data_source.dart';
import 'package:tasky/domain/failures/server_failure.dart';

class MembersRepositoryImpl extends MembersRepository {
  final RemoteDataSource _dataSource;

  MembersRepositoryImpl({@required RemoteDataSource dataSource})
      : _dataSource = dataSource;

  @override
  Future<Either<Failure, IList<User>>> getUsers() {
    return MonadTask(() => _dataSource.getUsers())
        .map((value) => value.map((e) => e.toUser()).toIList())
        .attempt((err) => ServerFailure.unexpectedError(err))
        .run();
  }
}
