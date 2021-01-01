import 'package:aspdm_project/domain/entities/task.dart';
import 'package:aspdm_project/domain/repositories/home_repository.dart';
import 'package:aspdm_project/locator.dart';
import 'package:aspdm_project/data/datasources/remote_data_source.dart';

class HomeRepositoryImpl extends HomeRepository {
  final RemoteDataSource _dataSource = locator<RemoteDataSource>();

  @override
  Future<List<Task>> getTasks() async {
    return (await _dataSource.getUnarchivedTasks()).map((e) => e.toTask());
  }
}
