import 'package:aspdm_project/core/either.dart';
import 'package:aspdm_project/core/monad_task.dart';
import 'package:aspdm_project/domain/entities/task.dart';
import 'package:aspdm_project/domain/failures/failures.dart';
import 'package:aspdm_project/domain/failures/server_failure.dart';
import 'package:aspdm_project/domain/repositories/task_form_repository.dart';
import 'package:aspdm_project/domain/values/unique_id.dart';
import 'package:aspdm_project/infrastructure/datasources/remote_data_source.dart';
import 'package:aspdm_project/infrastructure/models/task_model.dart';

class TaskFormRepositoryImpl extends TaskFormRepository {
  final RemoteDataSource _dataSource;

  TaskFormRepositoryImpl(this._dataSource);

  @override
  Future<Either<Failure, Unit>> saveNewTask(Task task, UniqueId userId) {
    return MonadTask(
            () => _dataSource.postTask(TaskModel.fromTask(task), userId))
        .map((_) => const Unit())
        .attempt((err) => ServerFailure.unexpectedError(err))
        .run();
  }

  @override
  Future<Either<Failure, Unit>> updateTask(Task task, UniqueId userId) {
    return MonadTask(
            () => _dataSource.patchTask(TaskModel.fromTask(task), userId))
        .map((_) => const Unit())
        .attempt((err) => ServerFailure.unexpectedError(err))
        .run();
  }
}
