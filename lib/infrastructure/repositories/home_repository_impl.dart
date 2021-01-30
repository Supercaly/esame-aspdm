import 'package:aspdm_project/core/either.dart';
import 'package:aspdm_project/core/ilist.dart';
import 'package:aspdm_project/domain/failures/failures.dart';
import 'package:aspdm_project/core/monad_task.dart';
import 'package:aspdm_project/domain/entities/task.dart';
import 'package:aspdm_project/domain/failures/server_failure.dart';
import 'package:aspdm_project/domain/repositories/home_repository.dart';
import 'package:aspdm_project/infrastructure/datasources/remote_data_source.dart';

class HomeRepositoryImpl extends HomeRepository {
  final RemoteDataSource _dataSource;

  HomeRepositoryImpl(this._dataSource);

  @override
  Future<Either<Failure, IList<Task>>> getTasks() {
    return MonadTask(() => _dataSource.getUnarchivedTasks())
        .map((value) => value.map((e) => e.toTask()).toIList())
        .attempt((e) => ServerFailure.unexpectedError(e))
        .run();
  }
}
