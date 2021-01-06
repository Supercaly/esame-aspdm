import 'package:aspdm_project/core/either.dart';
import 'package:aspdm_project/core/failures.dart';
import 'package:aspdm_project/domain/entities/task.dart';
import 'package:aspdm_project/domain/repositories/task_repository.dart';
import 'package:aspdm_project/data/datasources/remote_data_source.dart';
import 'package:aspdm_project/domain/values/task_values.dart';
import 'package:aspdm_project/domain/values/unique_id.dart';

class TaskRepositoryImpl extends TaskRepository {
  final RemoteDataSource _dataSource;

  TaskRepositoryImpl(this._dataSource);

  @override
  Future<Either<Failure, Task>> getTask(UniqueId id) async {
    if (id == null) return Either.left(ServerFailure());

    try {
      return Either.right(
          (await _dataSource.getTask(id.value.getOrCrash()))?.toTask());
    } catch (e) {
      return Either.left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Task>> deleteComment(
    UniqueId taskId,
    UniqueId commentId,
    UniqueId userId,
  ) async {
    try {
      final updated = await _dataSource.deleteComment(
        taskId.value.getOrCrash(),
        commentId.value.getOrCrash(),
        userId.value.getOrCrash(),
      );
      if (updated == null) return Either.left(ServerFailure());
      return Either.right(updated.toTask());
    } catch (e) {
      return Either.left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Task>> editComment(
    UniqueId taskId,
    UniqueId commentId,
    CommentContent content,
    UniqueId userId,
  ) async {
    try {
      final updated = await _dataSource.patchComment(
        taskId.value.getOrCrash(),
        commentId.value.getOrCrash(),
        userId.value.getOrCrash(),
        content.value.getOrCrash(),
      );
      if (updated == null) return Either.left(ServerFailure());
      return Either.right(updated.toTask());
    } catch (e) {
      return Either.left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Task>> addComment(
      UniqueId taskId, CommentContent content, UniqueId userId) async {
    try {
      final updated = await _dataSource.postComment(
        taskId.value.getOrCrash(),
        userId.value.getOrCrash(),
        content.value.getOrCrash(),
      );
      if (updated == null) return Either.left(ServerFailure());
      return Either.right(updated.toTask());
    } catch (e) {
      return Either.left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Task>> likeComment(
      UniqueId taskId, UniqueId commentId, UniqueId userId) async {
    try {
      final updated = await _dataSource.likeComment(
        taskId.value.getOrCrash(),
        commentId.value.getOrCrash(),
        userId.value.getOrCrash(),
      );
      if (updated == null) return Either.left(ServerFailure());
      return Either.right(updated.toTask());
    } catch (e) {
      return Either.left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Task>> dislikeComment(
      UniqueId taskId, UniqueId commentId, UniqueId userId) async {
    try {
      final updated = await _dataSource.dislikeComment(
        taskId.value.getOrCrash(),
        commentId.value.getOrCrash(),
        userId.value.getOrCrash(),
      );
      if (updated == null) return Either.left(ServerFailure());
      return Either.right(updated.toTask());
    } catch (e) {
      return Either.left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Task>> archiveTask(
      UniqueId taskId, UniqueId userId) async {
    try {
      final updated = await _dataSource.archive(
        taskId.value.getOrCrash(),
        userId.value.getOrCrash(),
        true,
      );
      if (updated == null) return Either.left(ServerFailure());
      return Either.right(updated.toTask());
    } catch (e) {
      return Either.left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Task>> unarchiveTask(
      UniqueId taskId, UniqueId userId) async {
    try {
      final updated = await _dataSource.archive(
        taskId.value.getOrCrash(),
        userId.value.getOrCrash(),
        false,
      );
      if (updated == null) return Either.left(ServerFailure());
      return Either.right(updated.toTask());
    } catch (e) {
      return Either.left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Task>> completeChecklist(
    UniqueId taskId,
    UniqueId userId,
    UniqueId checklistId,
    UniqueId itemId,
    Toggle complete,
  ) async {
    try {
      final updated = await _dataSource.check(
        taskId.value.getOrCrash(),
        userId.value.getOrCrash(),
        checklistId.value.getOrCrash(),
        itemId.value.getOrCrash(),
        complete.value.getOrCrash(),
      );
      if (updated == null) return Either.left(ServerFailure());
      return Either.right(updated.toTask());
    } catch (e) {
      return Either.left(ServerFailure());
    }
  }
}
