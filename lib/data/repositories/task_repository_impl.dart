import 'package:aspdm_project/core/either.dart';
import 'package:aspdm_project/core/failures.dart';
import 'package:aspdm_project/domain/entities/task.dart';
import 'package:aspdm_project/domain/repositories/task_repository.dart';
import 'package:aspdm_project/data/datasources/remote_data_source.dart';

class TaskRepositoryImpl extends TaskRepository {
  final RemoteDataSource _dataSource;

  TaskRepositoryImpl(this._dataSource);

  @override
  Future<Either<Failure, Task>> getTask(String id) async {
    if (id == null) return Either.left(ServerFailure());

    try {
      return Either.right((await _dataSource.getTask(id))?.toTask());
    } catch (e) {
      return Either.left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Task>> deleteComment(
    String taskId,
    String commentId,
    String userId,
  ) async {
    try {
      final updated =
          await _dataSource.deleteComment(taskId, commentId, userId);
      if (updated == null) return Either.left(ServerFailure());
      return Either.right(updated.toTask());
    } catch (e) {
      return Either.left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Task>> editComment(
    String taskId,
    String commentId,
    String content,
    String userId,
  ) async {
    try {
      final updated =
          await _dataSource.patchComment(taskId, commentId, userId, content);
      if (updated == null) return Either.left(ServerFailure());
      return Either.right(updated.toTask());
    } catch (e) {
      return Either.left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Task>> addComment(
      String taskId, String content, String userId) async {
    try {
      final updated = await _dataSource.postComment(taskId, userId, content);
      if (updated == null) return Either.left(ServerFailure());
      return Either.right(updated.toTask());
    } catch (e) {
      return Either.left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Task>> likeComment(
      String taskId, String commentId, String userId) async {
    try {
      final updated = await _dataSource.likeComment(taskId, commentId, userId);
      if (updated == null) return Either.left(ServerFailure());
      return Either.right(updated.toTask());
    } catch (e) {
      return Either.left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Task>> dislikeComment(
      String taskId, String commentId, String userId) async {
    try {
      final updated =
          await _dataSource.dislikeComment(taskId, commentId, userId);
      if (updated == null) return Either.left(ServerFailure());
      return Either.right(updated.toTask());
    } catch (e) {
      return Either.left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Task>> archiveTask(
      String taskId, String userId) async {
    try {
      final updated = await _dataSource.archive(taskId, userId, true);
      if (updated == null) return Either.left(ServerFailure());
      return Either.right(updated.toTask());
    } catch (e) {
      return Either.left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Task>> unarchiveTask(
      String taskId, String userId) async {
    try {
      final updated = await _dataSource.archive(taskId, userId, false);
      if (updated == null) return Either.left(ServerFailure());
      return Either.right(updated.toTask());
    } catch (e) {
      return Either.left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Task>> completeChecklist(
    String taskId,
    String userId,
    String checklistId,
    String itemId,
    bool complete,
  ) async {
    try {
      final updated = await _dataSource.check(
          taskId, userId, checklistId, itemId, complete);
      if (updated == null) return Either.left(ServerFailure());
      return Either.right(updated.toTask());
    } catch (e) {
      return Either.left(ServerFailure());
    }
  }
}
