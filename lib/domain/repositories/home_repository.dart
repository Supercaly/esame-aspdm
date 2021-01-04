import 'package:aspdm_project/core/either.dart';
import 'package:aspdm_project/core/failures.dart';
import 'package:aspdm_project/domain/entities/task.dart';

abstract class HomeRepository {
  Future<Either<Failure, List<Task>>> getTasks();
}
