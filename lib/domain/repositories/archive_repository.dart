import 'package:aspdm_project/core/either.dart';
import 'package:aspdm_project/core/ilist.dart';
import 'package:aspdm_project/domain/failures/failures.dart';
import 'package:aspdm_project/domain/entities/task.dart';

abstract class ArchiveRepository {
  Future<Either<Failure, IList<Task>>> getArchivedTasks();
}
