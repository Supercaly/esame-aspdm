import 'package:aspdm_project/core/either.dart';
import 'package:aspdm_project/core/failures.dart';
import 'package:aspdm_project/domain/entities/task.dart';
import 'package:aspdm_project/domain/repositories/archive_repository.dart';
import 'package:aspdm_project/data/datasources/remote_data_source.dart';

class ArchiveRepositoryImpl extends ArchiveRepository {
  final RemoteDataSource _dataSource;

  ArchiveRepositoryImpl(this._dataSource);

  @override
  Future<Either<Failure, List<Task>>> getArchivedTasks() async {
    try {
      return Either.right((await _dataSource.getArchivedTasks())
              ?.map((e) => e.toTask())
              ?.toList() ??
          []);
    } catch (e) {
      return Either.left(ServerFailure());
    }
  }
}
