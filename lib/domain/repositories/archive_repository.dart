import 'package:aspdm_project/domain/entities/task.dart';

abstract class ArchiveRepository {
  Future<List<Task>> getArchivedTasks();
}
