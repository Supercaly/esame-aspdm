import 'package:aspdm_project/model/task.dart';
import 'package:aspdm_project/services/data_source.dart';

import '../locator.dart';

class ArchiveRepository {
  final DataSource _dataSource = locator<DataSource>();

  Future<List<Task>> getArchivedTasks() {
    return _dataSource.getArchivedTasks();
  }
}
