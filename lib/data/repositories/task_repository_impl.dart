import 'package:aspdm_project/core/either.dart';
import 'package:aspdm_project/domain/failures/failures.dart';
import 'package:aspdm_project/core/monad_task.dart';
import 'package:aspdm_project/domain/entities/task.dart';
import 'package:aspdm_project/domain/failures/server_failure.dart';
import 'package:aspdm_project/domain/failures/task_failure.dart';
import 'package:aspdm_project/domain/repositories/task_repository.dart';
import 'package:aspdm_project/data/datasources/remote_data_source.dart';
import 'package:aspdm_project/domain/values/task_values.dart';
import 'package:aspdm_project/domain/values/unique_id.dart';

class TaskRepositoryImpl extends TaskRepository {
  final RemoteDataSource _dataSource;

  TaskRepositoryImpl(this._dataSource);

  @override
  Future<Either<Failure, Task>> getTask(UniqueId id) async {
    if (id == null) return Either.left(TaskFailure.invalidId());
    return MonadTask(
        () => _dataSource.getTask(id.value.getOrCrash()).then((taskModel) {
              return taskModel?.toTask();
            })).attempt<Failure>((e) => ServerFailure.unexpectedError(e)).run();
  }

  @override
  Future<Either<Failure, Task>> deleteComment(
    UniqueId taskId,
    UniqueId commentId,
    UniqueId userId,
  ) =>
      MonadTask(() => _dataSource
              .deleteComment(
            taskId.value.getOrCrash(),
            commentId.value.getOrCrash(),
            userId.value.getOrCrash(),
          )
              .then((taskModel) {
            if (taskModel == null)
              throw TaskFailure.deleteCommentFailure(commentId);
            return taskModel.toTask();
          })).attempt<Failure>((e) => ServerFailure.unexpectedError(e)).run();

  @override
  Future<Either<Failure, Task>> editComment(
    UniqueId taskId,
    UniqueId commentId,
    CommentContent content,
    UniqueId userId,
  ) =>
      MonadTask(() => _dataSource
              .patchComment(
            taskId.value.getOrCrash(),
            commentId.value.getOrCrash(),
            userId.value.getOrCrash(),
            content.value.getOrCrash(),
          )
              .then((taskModel) {
            if (taskModel == null)
              throw TaskFailure.editCommentFailure(commentId);
            return taskModel.toTask();
          })).attempt<Failure>((e) => ServerFailure.unexpectedError(e)).run();

  @override
  Future<Either<Failure, Task>> addComment(
          UniqueId taskId, CommentContent content, UniqueId userId) =>
      MonadTask(() => _dataSource
              .postComment(
            taskId.value.getOrCrash(),
            userId.value.getOrCrash(),
            content.value.getOrCrash(),
          )
              .then((taskModel) {
            if (taskModel == null) throw TaskFailure.newCommentFailure();
            return taskModel.toTask();
          })).attempt<Failure>((e) => ServerFailure.unexpectedError(e)).run();

  @override
  Future<Either<Failure, Task>> likeComment(
    UniqueId taskId,
    UniqueId commentId,
    UniqueId userId,
  ) =>
      MonadTask(() => _dataSource
              .likeComment(
            taskId.value.getOrCrash(),
            commentId.value.getOrCrash(),
            userId.value.getOrCrash(),
          )
              .then((taskModel) {
            if (taskModel == null) throw TaskFailure.likeFailure(commentId);
            return taskModel.toTask();
          })).attempt<Failure>((e) => ServerFailure.unexpectedError(e)).run();

  @override
  Future<Either<Failure, Task>> dislikeComment(
    UniqueId taskId,
    UniqueId commentId,
    UniqueId userId,
  ) =>
      MonadTask(() => _dataSource
              .dislikeComment(
            taskId.value.getOrCrash(),
            commentId.value.getOrCrash(),
            userId.value.getOrCrash(),
          )
              .then((taskModel) {
            if (taskModel == null) throw TaskFailure.dislikeFailure(commentId);
            return taskModel.toTask();
          })).attempt<Failure>((e) => ServerFailure.unexpectedError(e)).run();

  @override
  Future<Either<Failure, Task>> archiveTask(UniqueId taskId, UniqueId userId) =>
      MonadTask(() => _dataSource
              .archive(
            taskId.value.getOrCrash(),
            userId.value.getOrCrash(),
            true,
          )
              .then((taskModel) {
            if (taskModel == null) throw TaskFailure.archiveFailure(taskId);
            return taskModel.toTask();
          })).attempt<Failure>((e) => ServerFailure.unexpectedError(e)).run();

  @override
  Future<Either<Failure, Task>> unarchiveTask(
    UniqueId taskId,
    UniqueId userId,
  ) =>
      MonadTask(() => _dataSource
              .archive(
            taskId.value.getOrCrash(),
            userId.value.getOrCrash(),
            false,
          )
              .then((taskModel) {
            if (taskModel == null) throw TaskFailure.unarchiveFailure(taskId);
            return taskModel.toTask();
          })).attempt<Failure>((e) => ServerFailure.unexpectedError(e)).run();

  @override
  Future<Either<Failure, Task>> completeChecklist(
    UniqueId taskId,
    UniqueId userId,
    UniqueId checklistId,
    UniqueId itemId,
    Toggle complete,
  ) =>
      MonadTask(() => _dataSource
              .check(
            taskId.value.getOrCrash(),
            userId.value.getOrCrash(),
            checklistId.value.getOrCrash(),
            itemId.value.getOrCrash(),
            complete.value.getOrCrash(),
          )
              .then((taskModel) {
            if (taskModel == null)
              throw TaskFailure.itemCompleteFailure(itemId);
            return taskModel.toTask();
          })).attempt<Failure>((e) => ServerFailure.unexpectedError(e)).run();
}
