import 'package:aspdm_project/core/either.dart';
import 'package:aspdm_project/core/failures.dart';
import '../entities/task.dart';

abstract class TaskRepository {
  Future<Either<Failure, Task>> getTask(String id);

  Future<Either<Failure, Task>> deleteComment(
    String taskId,
    String commentId,
    String userId,
  );

  Future<Either<Failure, Task>> editComment(
    String taskId,
    String commentId,
    String content,
    String userId,
  );

  Future<Either<Failure, Task>> addComment(
      String taskId, String content, String userId);

  Future<Either<Failure, Task>> likeComment(
      String taskId, String commentId, String userId);

  Future<Either<Failure, Task>> dislikeComment(
      String taskId, String commentId, String userId);

  Future<Either<Failure, Task>> archiveTask(String taskId, String userId);

  Future<Either<Failure, Task>> unarchiveTask(String taskId, String userId);

  Future<Either<Failure, Task>> completeChecklist(
    String taskId,
    String userId,
    String checklistId,
    String itemId,
    bool complete,
  );
}
