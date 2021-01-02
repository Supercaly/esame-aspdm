import 'package:aspdm_project/domain/entities/task.dart';
import 'package:aspdm_project/domain/repositories/archive_repository.dart';
import 'package:aspdm_project/data/datasources/remote_data_source.dart';

class ArchiveRepositoryImpl extends ArchiveRepository {
  final RemoteDataSource _dataSource;

  ArchiveRepositoryImpl(this._dataSource);

  @override
  Future<List<Task>> getArchivedTasks() async {
    return (await _dataSource.getArchivedTasks())
        ?.map((e) => e.toTask())
        ?.toList();
  }
}
