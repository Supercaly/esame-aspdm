import 'package:flutter/foundation.dart';
import 'package:tasky/core/either.dart';
import 'package:tasky/core/ilist.dart';
import 'package:tasky/domain/failures/failures.dart';
import 'package:tasky/core/monad_task.dart';
import 'package:tasky/domain/entities/task.dart';
import 'package:tasky/domain/failures/server_failure.dart';
import 'package:tasky/domain/repositories/archive_repository.dart';
import 'package:tasky/infrastructure/datasources/remote_data_source.dart';

class ArchiveRepositoryImpl extends ArchiveRepository {
  final RemoteDataSource _dataSource;

  ArchiveRepositoryImpl({@required RemoteDataSource dataSource})
      : _dataSource = dataSource;

  @override
  Stream<Either<Failure, IList<Task>>> watchArchivedTasks() {
    return Stream.fromFuture(MonadTask(() => _dataSource.getArchivedTasks())
        .map((value) => value.map((e) => e.toDomain()).toIList())
        .attempt((e) => ServerFailure.unexpectedError(e))
        .run());
  }
}
