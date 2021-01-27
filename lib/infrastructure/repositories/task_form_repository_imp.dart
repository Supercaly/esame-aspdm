import 'package:aspdm_project/core/either.dart';
import 'package:aspdm_project/domain/entities/task.dart';
import 'package:aspdm_project/domain/failures/failures.dart';
import 'package:aspdm_project/domain/failures/server_failure.dart';
import 'package:aspdm_project/domain/repositories/task_form_repository.dart';
import 'package:aspdm_project/infrastructure/datasources/remote_data_source.dart';

class TaskFormRepositoryImpl extends TaskFormRepository {
  final RemoteDataSource _dataSource;

  TaskFormRepositoryImpl(this._dataSource);

  @override
  Future<Either<Failure, Task>> saveNewTask(Task task) async {
    await Future.delayed(Duration(seconds: 3));
    //return Either.left(ServerFailure.unexpectedError(""));
    return Either.right(null);
  }

  @override
  Future<Either<Failure, Task>> updateTask(Task task) {
    return Future.value(Either.left(ServerFailure.unexpectedError("")));
  }
}
