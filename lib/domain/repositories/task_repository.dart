import '../entities/task.dart';

abstract class TaskRepository {
  Future<Task> getTask(String id);

  Future<Task> deleteComment(
    String taskId,
    String commentId,
    String userId,
  );

  Future<Task> editComment(
    String taskId,
    String commentId,
    String content,
    String userId,
  );

  Future<Task> addComment(String taskId, String content, String userId);

  Future<Task> likeComment(String taskId, String commentId, String userId);

  Future<Task> dislikeComment(String taskId, String commentId, String userId);

  Future<Task> archiveTask(String taskId, String userId);

  Future<Task> unarchiveTask(String taskId, String userId);

  Future<Task> completeChecklist(
    String taskId,
    String userId,
    String checklistId,
    String itemId,
    bool complete,
  );
}
