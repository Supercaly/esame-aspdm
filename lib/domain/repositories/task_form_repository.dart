
import 'package:aspdm_project/domain/entities/task.dart';
import 'package:aspdm_project/domain/failures/failures.dart';
import 'package:aspdm_project/core/either.dart';


abstract class TaskFormRepository {
  Future<Either<Failure, Task>> saveNewTask(Task task);
  Future<Either<Failure, Task>> updateTask(Task task);
}