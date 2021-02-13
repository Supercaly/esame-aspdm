import 'package:tasky/core/either.dart';
import 'package:tasky/core/maybe.dart';
import 'package:tasky/domain/failures/failures.dart';
import 'package:tasky/domain/values/task_values.dart';
import 'package:tasky/domain/values/unique_id.dart';
import '../entities/task.dart';

abstract class TaskRepository {
  Future<Either<Failure, Task>> getTask(Maybe<UniqueId> id);

  Future<Either<Failure, Task>> deleteComment(
    Maybe<UniqueId> taskId,
    UniqueId commentId,
    Maybe<UniqueId> userId,
  );

  Future<Either<Failure, Task>> editComment(
    Maybe<UniqueId> taskId,
    UniqueId commentId,
    CommentContent content,
    Maybe<UniqueId> userId,
  );

  Future<Either<Failure, Task>> addComment(
    Maybe<UniqueId> taskId,
    CommentContent content,
    Maybe<UniqueId> userId,
  );

  Future<Either<Failure, Task>> likeComment(
    Maybe<UniqueId> taskId,
    UniqueId commentId,
    Maybe<UniqueId> userId,
  );

  Future<Either<Failure, Task>> dislikeComment(
    Maybe<UniqueId> taskId,
    UniqueId commentId,
    Maybe<UniqueId> userId,
  );

  Future<Either<Failure, Task>> archiveTask(
      Maybe<UniqueId> taskId, Maybe<UniqueId> userId);

  Future<Either<Failure, Task>> unarchiveTask(
      Maybe<UniqueId> taskId, Maybe<UniqueId> userId);

  Future<Either<Failure, Task>> completeChecklist(
    Maybe<UniqueId> taskId,
    Maybe<UniqueId> userId,
    UniqueId checklistId,
    UniqueId itemId,
    Toggle complete,
  );
}
