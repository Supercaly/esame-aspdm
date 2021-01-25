import 'package:aspdm_project/core/either.dart';
import 'package:aspdm_project/core/maybe.dart';
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
  Future<Either<Failure, Task>> getTask(Maybe<UniqueId> id) async {
    if (id.isNothing()) return Either.left(TaskFailure.invalidId());
    return MonadTask(() => _dataSource.getTask(id.getOrNull()))
        .map((value) => value?.toTask())
        .attempt((e) => ServerFailure.unexpectedError(e))
        .run();
  }

  @override
  Future<Either<Failure, Task>> deleteComment(
    Maybe<UniqueId> taskId,
    UniqueId commentId,
    Maybe<UniqueId> userId,
  ) =>
      MonadTask(() => _dataSource.deleteComment(
                taskId.getOrNull(),
                commentId,
                userId.getOrNull(),
              ))
          .map((value) => value.toTask())
          .attempt((e) => ServerFailure.unexpectedError(e))
          .run();

  @override
  Future<Either<Failure, Task>> editComment(
    Maybe<UniqueId> taskId,
    UniqueId commentId,
    CommentContent content,
    Maybe<UniqueId> userId,
  ) =>
      MonadTask(() => _dataSource.patchComment(
                taskId.getOrNull(),
                commentId,
                userId.getOrNull(),
                content,
              ))
          .map((value) => value.toTask())
          .attempt((e) => ServerFailure.unexpectedError(e))
          .run();

  @override
  Future<Either<Failure, Task>> addComment(
    Maybe<UniqueId> taskId,
    CommentContent content,
    Maybe<UniqueId> userId,
  ) =>
      MonadTask(() => _dataSource.postComment(
                taskId.getOrNull(),
                userId.getOrNull(),
                content,
              ))
          .map((value) => value.toTask())
          .attempt((e) => ServerFailure.unexpectedError(e))
          .run();

  @override
  Future<Either<Failure, Task>> likeComment(
    Maybe<UniqueId> taskId,
    UniqueId commentId,
    Maybe<UniqueId> userId,
  ) =>
      MonadTask(() => _dataSource.likeComment(
                taskId.getOrNull(),
                commentId,
                userId.getOrNull(),
              ))
          .map((value) => value.toTask())
          .attempt((e) => ServerFailure.unexpectedError(e))
          .run();

  @override
  Future<Either<Failure, Task>> dislikeComment(
    Maybe<UniqueId> taskId,
    UniqueId commentId,
    Maybe<UniqueId> userId,
  ) =>
      MonadTask(() => _dataSource.dislikeComment(
                taskId.getOrNull(),
                commentId,
                userId.getOrNull(),
              ))
          .map((value) => value.toTask())
          .attempt((e) => ServerFailure.unexpectedError(e))
          .run();

  @override
  Future<Either<Failure, Task>> archiveTask(
    Maybe<UniqueId> taskId,
    Maybe<UniqueId> userId,
  ) =>
      MonadTask(() => _dataSource.archive(
                taskId.getOrNull(),
                userId.getOrNull(),
                Toggle(true),
              ))
          .map((value) => value.toTask())
          .attempt((e) => ServerFailure.unexpectedError(e))
          .run();

  @override
  Future<Either<Failure, Task>> unarchiveTask(
    Maybe<UniqueId> taskId,
    Maybe<UniqueId> userId,
  ) =>
      MonadTask(() => _dataSource.archive(
                taskId.getOrNull(),
                userId.getOrNull(),
                Toggle(false),
              ))
          .map((value) => value.toTask())
          .attempt((e) => ServerFailure.unexpectedError(e))
          .run();

  @override
  Future<Either<Failure, Task>> completeChecklist(
    Maybe<UniqueId> taskId,
    Maybe<UniqueId> userId,
    UniqueId checklistId,
    UniqueId itemId,
    Toggle complete,
  ) =>
      MonadTask(() => _dataSource.check(
                taskId.getOrNull(),
                userId.getOrNull(),
                checklistId,
                itemId,
                complete,
              ))
          .map((value) => value.toTask())
          .attempt((e) => ServerFailure.unexpectedError(e))
          .run();
}
