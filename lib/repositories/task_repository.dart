import 'package:aspdm_project/model/task.dart';
import 'package:aspdm_project/services/data_source.dart';

import '../locator.dart';

class TaskRepository {
  final DataSource _dataSource = locator<DataSource>();

  Future<Task> getTask(String id) {
    assert(id != null);

    return _dataSource.getTask(id);
  }

  Future<Task> deleteComment(
    String taskId,
    String commentId,
    String userId,
  ) async {
    final updated = await _dataSource.deleteComment(taskId, commentId, userId);
    if (updated == null) throw Exception("Error deleting comment $commentId");
    return updated;
  }

  Future<Task> editComment(
    String taskId,
    String commentId,
    String content,
    String userId,
  ) async {
    final updated =
        await _dataSource.patchComment(taskId, commentId, userId, content);
    if (updated == null) throw Exception("Error updating comment $commentId");
    return updated;
  }

  Future<Task> addComment(String taskId, String content, String userId) async {
    final updated = await _dataSource.postComment(taskId, userId, content);
    if (updated == null) throw Exception("Error adding a comment!");
    return updated;
  }

  Future<Task> likeComment(
      String taskId, String commentId, String userId) async {
    final updated = await _dataSource.likeComment(taskId, commentId, userId);
    if (updated == null) throw Exception("Error liking comment $commentId");
    return updated;
  }

  Future<Task> dislikeComment(
      String taskId, String commentId, String userId) async {
    final updated = await _dataSource.dislikeComment(taskId, commentId, userId);
    if (updated == null) throw Exception("Error disliking comment $commentId");
    return updated;
  }

  Future<Task> archiveTask(String taskId, String userId) async {
    final updated = await _dataSource.archive(taskId, userId, true);
    if (updated == null) throw Exception("Error un-archiving task $taskId");
    return updated;
  }

  Future<Task> unarchiveTask(String taskId, String userId) async {
    final updated = await _dataSource.archive(taskId, userId, false);
    if (updated == null) throw Exception("Error un-archiving task $taskId");
    return updated;
  }

  Future<Task> completeChecklist(
    String taskId,
    String userId,
    String checklistId,
    String itemId,
    bool complete,
  ) async {
    final updated = await _dataSource.check(taskId, userId, checklistId, itemId, complete);
    if (updated == null) throw Exception("Error completing checklist item $itemId");
    return updated;
  }
}
