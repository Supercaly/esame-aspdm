import 'package:aspdm_project/domain/entities/task.dart';
import 'package:aspdm_project/domain/failures/failures.dart';
import 'package:aspdm_project/core/either.dart';
import 'package:aspdm_project/domain/values/unique_id.dart';

abstract class TaskFormRepository {
  Future<Either<Failure, Unit>> saveNewTask(Task task, UniqueId userId);
  Future<Either<Failure, Task>> updateTask(Task task);
}
