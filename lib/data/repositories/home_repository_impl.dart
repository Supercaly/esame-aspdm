import 'package:aspdm_project/domain/entities/task.dart';
import 'package:aspdm_project/domain/repositories/home_repository.dart';
import 'package:aspdm_project/locator.dart';
import 'package:aspdm_project/services/data_source.dart';

class HomeRepositoryImpl extends HomeRepository {
  final DataSource _dataSource = locator<DataSource>();

  @override
  Future<List<Task>> getTasks() {
    return _dataSource.getUnarchivedTasks();
  }
}
