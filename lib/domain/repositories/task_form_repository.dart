import 'package:tasky/domain/entities/task.dart';
import 'package:tasky/domain/failures/failures.dart';
import 'package:tasky/core/either.dart';
import 'package:tasky/domain/values/unique_id.dart';

abstract class TaskFormRepository {
  Future<Either<Failure, Unit>> saveNewTask(Task task, UniqueId userId);
  Future<Either<Failure, Unit>> updateTask(Task task, UniqueId userId);
}
