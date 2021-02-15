import 'package:tasky/core/either.dart';
import 'package:tasky/core/ilist.dart';
import 'package:tasky/domain/failures/failures.dart';
import 'package:tasky/domain/entities/task.dart';

abstract class HomeRepository {
  Stream<Either<Failure, IList<Task>>> watchTasks();
}
