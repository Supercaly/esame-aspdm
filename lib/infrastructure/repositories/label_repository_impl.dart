import 'package:aspdm_project/core/either.dart';
import 'package:aspdm_project/core/monad_task.dart';
import 'package:aspdm_project/domain/entities/label.dart';
import 'package:aspdm_project/domain/failures/failures.dart';
import 'package:aspdm_project/domain/repositories/label_repository.dart';
import 'package:aspdm_project/infrastructure/datasources/remote_data_source.dart';
import 'package:aspdm_project/domain/failures/server_failure.dart';

class LabelRepositoryImpl extends LabelRepository {
  final RemoteDataSource _dataSource;

  LabelRepositoryImpl(this._dataSource);

  @override
  Future<Either<Failure, List<Label>>> getLabels() {
    return MonadTask(() => _dataSource.getLabels())
        .map((value) => value.map((e) => e.toLabel()).toList())
        .attempt((err) => ServerFailure.unexpectedError(err))
        .run();
  }
}
