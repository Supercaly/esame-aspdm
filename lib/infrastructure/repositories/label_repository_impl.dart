import 'package:tasky/core/either.dart';
import 'package:tasky/core/ilist.dart';
import 'package:tasky/core/monad_task.dart';
import 'package:tasky/domain/entities/label.dart';
import 'package:tasky/domain/failures/failures.dart';
import 'package:tasky/domain/repositories/label_repository.dart';
import 'package:tasky/infrastructure/datasources/remote_data_source.dart';
import 'package:tasky/domain/failures/server_failure.dart';

class LabelRepositoryImpl extends LabelRepository {
  final RemoteDataSource _dataSource;

  LabelRepositoryImpl({required RemoteDataSource dataSource})
      : _dataSource = dataSource;

  @override
  Future<Either<Failure, IList<Label>>> getLabels() {
    return MonadTask(() => _dataSource.getLabels())
        .map((value) => value.map((e) => e.toDomain()).toIList())
        .attempt((err) => ServerFailure.unexpectedError(err))
        .run();
  }
}
