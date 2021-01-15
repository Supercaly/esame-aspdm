import 'package:aspdm_project/core/either.dart';
import 'package:aspdm_project/domain/failures/failures.dart';
import 'package:aspdm_project/core/monad_task.dart';
import 'package:aspdm_project/domain/entities/task.dart';
import 'package:aspdm_project/domain/failures/server_failure.dart';
import 'package:aspdm_project/domain/failures/task_failure.dart';
import 'package:aspdm_project/domain/repositories/task_repository.dart';
import 'package:aspdm_project/infrastructure/datasources/remote_data_source.dart';
import 'package:aspdm_project/domain/values/task_values.dart';
import 'package:aspdm_project/domain/values/unique_id.dart';

class TaskRepositoryImpl extends TaskRepository {
  final RemoteDataSource _dataSource;

  TaskRepositoryImpl(this._dataSource);

  @override
  Future<Either<Failure, Task>> getTask(UniqueId id) async {
    if (id == null) return Either.left(TaskFailure.invalidId());
    return MonadTask(() => _dataSource.getTask(id))
        .map((value) => value?.toTask())
        .attempt((e) => ServerFailure.unexpectedError(e))
        .run();
  }

  @override
  Future<Either<Failure, Task>> deleteComment(
    UniqueId taskId,
    UniqueId commentId,
    UniqueId userId,
  ) =>
      MonadTask(() => _dataSource.deleteComment(taskId, commentId, userId))
          .map((value) => value.toTask())
          .attempt((e) => ServerFailure.unexpectedError(e))
          .run();

  @override
  Future<Either<Failure, Task>> editComment(
    UniqueId taskId,
    UniqueId commentId,
    CommentContent content,
    UniqueId userId,
  ) =>
      MonadTask(() =>
              _dataSource.patchComment(taskId, commentId, userId, content))
          .map((value) => value.toTask())
          .attempt((e) => ServerFailure.unexpectedError(e))
          .run();

  @override
  Future<Either<Failure, Task>> addComment(
          UniqueId taskId, CommentContent content, UniqueId userId) =>
      MonadTask(() => _dataSource.postComment(taskId, userId, content))
          .map((value) => value.toTask())
          .attempt((e) => ServerFailure.unexpectedError(e))
          .run();

  @override
  Future<Either<Failure, Task>> likeComment(
    UniqueId taskId,
    UniqueId commentId,
    UniqueId userId,
  ) =>
      MonadTask(() => _dataSource.likeComment(taskId, commentId, userId))
          .map((value) => value.toTask())
          .attempt((e) => ServerFailure.unexpectedError(e))
          .run();

  @override
  Future<Either<Failure, Task>> dislikeComment(
    UniqueId taskId,
    UniqueId commentId,
    UniqueId userId,
  ) =>
      MonadTask(() => _dataSource.dislikeComment(taskId, commentId, userId))
          .map((value) => value.toTask())
          .attempt((e) => ServerFailure.unexpectedError(e))
          .run();

  @override
  Future<Either<Failure, Task>> archiveTask(UniqueId taskId, UniqueId userId) =>
      MonadTask(() => _dataSource.archive(taskId, userId, Toggle(true)))
          .map((value) => value.toTask())
          .attempt((e) => ServerFailure.unexpectedError(e))
          .run();

  @override
  Future<Either<Failure, Task>> unarchiveTask(
    UniqueId taskId,
    UniqueId userId,
  ) =>
      MonadTask(() => _dataSource.archive(taskId, userId, Toggle(false)))
          .map((value) => value.toTask())
          .attempt((e) => ServerFailure.unexpectedError(e))
          .run();

  @override
  Future<Either<Failure, Task>> completeChecklist(
    UniqueId taskId,
    UniqueId userId,
    UniqueId checklistId,
    UniqueId itemId,
    Toggle complete,
  ) =>
      MonadTask(() =>
              _dataSource.check(taskId, userId, checklistId, itemId, complete))
          .map((value) => value.toTask())
          .attempt((e) => ServerFailure.unexpectedError(e))
          .run();
}
