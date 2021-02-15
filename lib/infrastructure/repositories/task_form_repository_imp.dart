import 'package:flutter/foundation.dart';
import 'package:tasky/core/either.dart';
import 'package:tasky/core/monad_task.dart';
import 'package:tasky/domain/entities/task.dart';
import 'package:tasky/domain/failures/failures.dart';
import 'package:tasky/domain/failures/server_failure.dart';
import 'package:tasky/domain/repositories/task_form_repository.dart';
import 'package:tasky/domain/values/unique_id.dart';
import 'package:tasky/infrastructure/datasources/remote_data_source.dart';
import 'package:tasky/infrastructure/models/task_model.dart';

class TaskFormRepositoryImpl extends TaskFormRepository {
  final RemoteDataSource _dataSource;

  TaskFormRepositoryImpl({@required RemoteDataSource dataSource})
      : _dataSource = dataSource;

  @override
  Future<Either<Failure, Unit>> saveNewTask(Task task, UniqueId userId) {
    return MonadTask(
            () => _dataSource.postTask(TaskModel.fromDomain(task), userId))
        .map((_) => const Unit())
        .attempt((err) => ServerFailure.unexpectedError(err))
        .run();
  }

  @override
  Future<Either<Failure, Unit>> updateTask(Task task, UniqueId userId) {
    return MonadTask(
            () => _dataSource.patchTask(TaskModel.fromDomain(task), userId))
        .map((_) => const Unit())
        .attempt((err) => ServerFailure.unexpectedError(err))
        .run();
  }
}
