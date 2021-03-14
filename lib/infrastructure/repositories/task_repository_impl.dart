import 'package:tasky/core/either.dart';
import 'package:tasky/core/maybe.dart';
import 'package:tasky/domain/failures/failures.dart';
import 'package:tasky/core/monad_task.dart';
import 'package:tasky/domain/entities/task.dart';
import 'package:tasky/domain/failures/server_failure.dart';
import 'package:tasky/domain/failures/task_failure.dart';
import 'package:tasky/domain/repositories/task_repository.dart';
import 'package:tasky/infrastructure/datasources/remote_data_source.dart';
import 'package:tasky/domain/values/task_values.dart';
import 'package:tasky/domain/values/unique_id.dart';

class TaskRepositoryImpl extends TaskRepository {
  final RemoteDataSource _dataSource;

  TaskRepositoryImpl({required RemoteDataSource dataSource})
      : _dataSource = dataSource;

  @override
  Stream<Either<Failure, Task?>> watchTask(Maybe<UniqueId> id) {
    if (id.isNothing())
      return Stream.value(Either.left(TaskFailure.invalidId()));
    return Stream.fromFuture(
        MonadTask(() => _dataSource.getTask(id.getOrCrash()))
            .map((value) => value?.toDomain())
            .attempt((e) => ServerFailure.unexpectedError(e))
            .run());
  }

  @override
  Future<Either<Failure, Task>> deleteComment(
    Maybe<UniqueId> taskId,
    UniqueId commentId,
    Maybe<UniqueId> userId,
  ) =>
      MonadTask(() => _dataSource.deleteComment(
                taskId.getOrCrash(),
                commentId,
                userId.getOrCrash(),
              ))
          .map((value) => value.toDomain())
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
                taskId.getOrCrash(),
                commentId,
                userId.getOrCrash(),
                content,
              ))
          .map((value) => value.toDomain())
          .attempt((e) => ServerFailure.unexpectedError(e))
          .run();

  @override
  Future<Either<Failure, Task>> addComment(
    Maybe<UniqueId> taskId,
    CommentContent content,
    Maybe<UniqueId> userId,
  ) =>
      MonadTask(() => _dataSource.postComment(
                taskId.getOrCrash(),
                userId.getOrCrash(),
                content,
              ))
          .map((value) => value.toDomain())
          .attempt((e) => ServerFailure.unexpectedError(e))
          .run();

  @override
  Future<Either<Failure, Task>> likeComment(
    Maybe<UniqueId> taskId,
    UniqueId commentId,
    Maybe<UniqueId> userId,
  ) =>
      MonadTask(() => _dataSource.likeComment(
                taskId.getOrCrash(),
                commentId,
                userId.getOrCrash(),
              ))
          .map((value) => value.toDomain())
          .attempt((e) => ServerFailure.unexpectedError(e))
          .run();

  @override
  Future<Either<Failure, Task>> dislikeComment(
    Maybe<UniqueId> taskId,
    UniqueId commentId,
    Maybe<UniqueId> userId,
  ) =>
      MonadTask(() => _dataSource.dislikeComment(
                taskId.getOrCrash(),
                commentId,
                userId.getOrCrash(),
              ))
          .map((value) => value.toDomain())
          .attempt((e) => ServerFailure.unexpectedError(e))
          .run();

  @override
  Future<Either<Failure, Task>> archiveTask(
    Maybe<UniqueId> taskId,
    Maybe<UniqueId> userId,
  ) =>
      MonadTask(() => _dataSource.archive(
                taskId.getOrCrash(),
                userId.getOrCrash(),
                Toggle(true),
              ))
          .map((value) => value.toDomain())
          .attempt((e) => ServerFailure.unexpectedError(e))
          .run();

  @override
  Future<Either<Failure, Task>> unarchiveTask(
    Maybe<UniqueId> taskId,
    Maybe<UniqueId> userId,
  ) =>
      MonadTask(() => _dataSource.archive(
                taskId.getOrCrash(),
                userId.getOrCrash(),
                Toggle(false),
              ))
          .map((value) => value.toDomain())
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
                taskId.getOrCrash(),
                userId.getOrCrash(),
                checklistId,
                itemId,
                complete,
              ))
          .map((value) => value.toDomain())
          .attempt((e) => ServerFailure.unexpectedError(e))
          .run();
}
