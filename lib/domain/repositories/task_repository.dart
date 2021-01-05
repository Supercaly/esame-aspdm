import 'package:aspdm_project/core/either.dart';
import 'package:aspdm_project/core/failures.dart';
import 'package:aspdm_project/domain/values/comment_content.dart';
import 'package:aspdm_project/domain/values/toggle.dart';
import 'package:aspdm_project/domain/values/unique_id.dart';
import '../entities/task.dart';

abstract class TaskRepository {
  Future<Either<Failure, Task>> getTask(UniqueId id);

  Future<Either<Failure, Task>> deleteComment(
    UniqueId taskId,
    UniqueId commentId,
    UniqueId userId,
  );

  Future<Either<Failure, Task>> editComment(
    UniqueId taskId,
    UniqueId commentId,
    CommentContent content,
    UniqueId userId,
  );

  Future<Either<Failure, Task>> addComment(
    UniqueId taskId,
    CommentContent content,
    UniqueId userId,
  );

  Future<Either<Failure, Task>> likeComment(
    UniqueId taskId,
    UniqueId commentId,
    UniqueId userId,
  );

  Future<Either<Failure, Task>> dislikeComment(
    UniqueId taskId,
    UniqueId commentId,
    UniqueId userId,
  );

  Future<Either<Failure, Task>> archiveTask(UniqueId taskId, UniqueId userId);

  Future<Either<Failure, Task>> unarchiveTask(UniqueId taskId, UniqueId userId);

  Future<Either<Failure, Task>> completeChecklist(
    UniqueId taskId,
    UniqueId userId,
    UniqueId checklistId,
    UniqueId itemId,
    Toggle complete,
  );
}
