import 'package:aspdm_project/locator.dart';
import 'package:aspdm_project/model/task.dart';
import 'package:aspdm_project/services/data_source.dart';

class HomeRepository {
  final DataSource _dataSource = locator<DataSource>();

  Future<List<Task>> getTasks() {
    return _dataSource.getUnarchivedTasks();
  }
}
