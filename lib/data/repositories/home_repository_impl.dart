import 'package:aspdm_project/core/either.dart';
import 'package:aspdm_project/core/failures.dart';
import 'package:aspdm_project/domain/entities/task.dart';
import 'package:aspdm_project/domain/repositories/home_repository.dart';
import 'package:aspdm_project/data/datasources/remote_data_source.dart';

class HomeRepositoryImpl extends HomeRepository {
  final RemoteDataSource _dataSource;

  HomeRepositoryImpl(this._dataSource);

  @override
  Future<Either<Failure, List<Task>>> getTasks() async {
    try {
      return Either.right((await _dataSource.getUnarchivedTasks())
          ?.map((e) => e.toTask())
          ?.toList() ?? []);
    } catch (e) {
      return Either.left(ServerFailure());
    }
  }
}
