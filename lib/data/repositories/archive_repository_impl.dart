import 'package:aspdm_project/domain/entities/task.dart';
import 'package:aspdm_project/domain/repositories/archive_repository.dart';
import 'package:aspdm_project/services/data_source.dart';

import '../../locator.dart';

class ArchiveRepositoryImpl extends ArchiveRepository {
  final DataSource _dataSource = locator<DataSource>();

  @override
  Future<List<Task>> getArchivedTasks() {
    return _dataSource.getArchivedTasks();
  }
}
