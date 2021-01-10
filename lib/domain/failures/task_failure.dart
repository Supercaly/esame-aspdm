import 'package:aspdm_project/domain/failures/failures.dart';
import 'package:aspdm_project/domain/values/unique_id.dart';

/// Represent that a [Failure] with the task has happened.
abstract class TaskFailure extends Failure {
  /// Creates a [TaskFailure] with invalid id error.
  factory TaskFailure.invalidId() => _TaskFailureInvalidId();

  /// Creates a [TaskFailure] with new comment error.
  factory TaskFailure.newCommentFailure() => _TaskFailureNewCommentFailure();

  /// Creates a [TaskFailure] with edit comment error.
  factory TaskFailure.editCommentFailure(UniqueId commentId) =>
      _TaskFailureEditCommentFailure(commentId);

  /// Creates a [TaskFailure] with delete comment error.
  factory TaskFailure.deleteCommentFailure(UniqueId commentId) =>
      _TaskFailureDeleteCommentFailure(commentId);

  /// Creates a [TaskFailure] with like comment error.
  factory TaskFailure.likeFailure(UniqueId commentId) =>
      _TaskFailureLikeFailure(commentId);

  /// Creates a [TaskFailure] with dislike comment error.
  factory TaskFailure.dislikeFailure(UniqueId commentId) =>
      _TaskFailureDislikeFailure(commentId);

  /// Creates a [TaskFailure] with archive error.
  factory TaskFailure.archiveFailure(UniqueId taskId) =>
      _TaskFailureArchiveFailure(taskId);

  /// Creates a [TaskFailure] with unarchive error.
  factory TaskFailure.unarchiveFailure(UniqueId taskId) =>
      _TaskFailureUnarchiveFailure(taskId);

  /// Creates a [TaskFailure] with complete item error.
  factory TaskFailure.itemCompleteFailure(UniqueId itemId) =>
      _TaskFailureItemCompleteFailure(itemId);

  /// Returns [R] after calling the callback from
  /// the correct type.
  R when<R>(
    R invalidId(),
    R newCommentFailure(),
    R editCommentFailure(UniqueId commentId),
    R deleteCommentFailure(UniqueId commentId),
    R likeFailure(UniqueId commentId),
    R dislikeFailure(UniqueId commentId),
    R archiveFailure(UniqueId taskId),
    R unarchiveFailure(UniqueId taskId),
    R itemCompleteFailure(UniqueId itemId),
  );
}

class _TaskFailureInvalidId implements TaskFailure {
  @override
  R when<R>(
    R Function() invalidId,
    R Function() newCommentFailure,
    R Function(UniqueId commentId) editCommentFailure,
    R Function(UniqueId commentId) deleteCommentFailure,
    R Function(UniqueId commentId) likeFailure,
    R Function(UniqueId commentId) dislikeFailure,
    R Function(UniqueId taskId) archiveFailure,
    R Function(UniqueId taskId) unarchiveFailure,
    R Function(UniqueId itemId) itemCompleteFailure,
  ) =>
      invalidId();

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is _TaskFailureInvalidId;

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() => "TaskFailure: invalid id";
}

class _TaskFailureNewCommentFailure implements TaskFailure {
  @override
  R when<R>(
    R Function() invalidId,
    R Function() newCommentFailure,
    R Function(UniqueId commentId) editCommentFailure,
    R Function(UniqueId commentId) deleteCommentFailure,
    R Function(UniqueId commentId) likeFailure,
    R Function(UniqueId commentId) dislikeFailure,
    R Function(UniqueId taskId) archiveFailure,
    R Function(UniqueId taskId) unarchiveFailure,
    R Function(UniqueId itemId) itemCompleteFailure,
  ) =>
      newCommentFailure();

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is _TaskFailureNewCommentFailure;

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() => "TaskFailure: new comment failure";
}

class _TaskFailureEditCommentFailure implements TaskFailure {
  final UniqueId id;

  const _TaskFailureEditCommentFailure(this.id);

  @override
  R when<R>(
    R Function() invalidId,
    R Function() newCommentFailure,
    R Function(UniqueId commentId) editCommentFailure,
    R Function(UniqueId commentId) deleteCommentFailure,
    R Function(UniqueId commentId) likeFailure,
    R Function(UniqueId commentId) dislikeFailure,
    R Function(UniqueId taskId) archiveFailure,
    R Function(UniqueId taskId) unarchiveFailure,
    R Function(UniqueId itemId) itemCompleteFailure,
  ) =>
      editCommentFailure(id);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is _TaskFailureEditCommentFailure && id == other.id);

  @override
  int get hashCode => runtimeType.hashCode ^ id.hashCode;

  @override
  String toString() => "TaskFailure: edit comment $id failure";
}

class _TaskFailureDeleteCommentFailure implements TaskFailure {
  final UniqueId id;

  const _TaskFailureDeleteCommentFailure(this.id);

  @override
  R when<R>(
    R Function() invalidId,
    R Function() newCommentFailure,
    R Function(UniqueId commentId) editCommentFailure,
    R Function(UniqueId commentId) deleteCommentFailure,
    R Function(UniqueId commentId) likeFailure,
    R Function(UniqueId commentId) dislikeFailure,
    R Function(UniqueId taskId) archiveFailure,
    R Function(UniqueId taskId) unarchiveFailure,
    R Function(UniqueId itemId) itemCompleteFailure,
  ) =>
      deleteCommentFailure(id);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is _TaskFailureDeleteCommentFailure && id == other.id);

  @override
  int get hashCode => runtimeType.hashCode ^ id.hashCode;

  @override
  String toString() => "TaskFailure: delete comment $id failure";
}

class _TaskFailureLikeFailure implements TaskFailure {
  final UniqueId id;

  const _TaskFailureLikeFailure(this.id);

  @override
  R when<R>(
    R Function() invalidId,
    R Function() newCommentFailure,
    R Function(UniqueId commentId) editCommentFailure,
    R Function(UniqueId commentId) deleteCommentFailure,
    R Function(UniqueId commentId) likeFailure,
    R Function(UniqueId commentId) dislikeFailure,
    R Function(UniqueId taskId) archiveFailure,
    R Function(UniqueId taskId) unarchiveFailure,
    R Function(UniqueId itemId) itemCompleteFailure,
  ) =>
      likeFailure(id);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is _TaskFailureLikeFailure && id == other.id);

  @override
  int get hashCode => runtimeType.hashCode ^ id.hashCode;

  @override
  String toString() => "TaskFailure: like comment $id failure";
}

class _TaskFailureDislikeFailure implements TaskFailure {
  final UniqueId id;

  const _TaskFailureDislikeFailure(this.id);

  @override
  R when<R>(
    R Function() invalidId,
    R Function() newCommentFailure,
    R Function(UniqueId commentId) editCommentFailure,
    R Function(UniqueId commentId) deleteCommentFailure,
    R Function(UniqueId commentId) likeFailure,
    R Function(UniqueId commentId) dislikeFailure,
    R Function(UniqueId taskId) archiveFailure,
    R Function(UniqueId taskId) unarchiveFailure,
    R Function(UniqueId itemId) itemCompleteFailure,
  ) =>
      dislikeFailure(id);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is _TaskFailureDislikeFailure && id == other.id);

  @override
  int get hashCode => runtimeType.hashCode ^ id.hashCode;

  @override
  String toString() => "TaskFailure: dislike comment $id failure";
}

class _TaskFailureArchiveFailure implements TaskFailure {
  final UniqueId id;

  const _TaskFailureArchiveFailure(this.id);

  @override
  R when<R>(
    R Function() invalidId,
    R Function() newCommentFailure,
    R Function(UniqueId commentId) editCommentFailure,
    R Function(UniqueId commentId) deleteCommentFailure,
    R Function(UniqueId commentId) likeFailure,
    R Function(UniqueId commentId) dislikeFailure,
    R Function(UniqueId taskId) archiveFailure,
    R Function(UniqueId taskId) unarchiveFailure,
    R Function(UniqueId itemId) itemCompleteFailure,
  ) =>
      archiveFailure(id);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is _TaskFailureArchiveFailure && id == other.id);

  @override
  int get hashCode => runtimeType.hashCode ^ id.hashCode;

  @override
  String toString() => "TaskFailure: archive task $id failure";
}

class _TaskFailureUnarchiveFailure implements TaskFailure {
  final UniqueId id;

  const _TaskFailureUnarchiveFailure(this.id);

  @override
  R when<R>(
    R Function() invalidId,
    R Function() newCommentFailure,
    R Function(UniqueId commentId) editCommentFailure,
    R Function(UniqueId commentId) deleteCommentFailure,
    R Function(UniqueId commentId) likeFailure,
    R Function(UniqueId commentId) dislikeFailure,
    R Function(UniqueId taskId) archiveFailure,
    R Function(UniqueId taskId) unarchiveFailure,
    R Function(UniqueId itemId) itemCompleteFailure,
  ) =>
      unarchiveFailure(id);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is _TaskFailureUnarchiveFailure && id == other.id);

  @override
  int get hashCode => runtimeType.hashCode ^ id.hashCode;

  @override
  String toString() => "TaskFailure: unarchive task $id failure";
}

class _TaskFailureItemCompleteFailure implements TaskFailure {
  final UniqueId id;

  const _TaskFailureItemCompleteFailure(this.id);

  @override
  R when<R>(
    R Function() invalidId,
    R Function() newCommentFailure,
    R Function(UniqueId commentId) editCommentFailure,
    R Function(UniqueId commentId) deleteCommentFailure,
    R Function(UniqueId commentId) likeFailure,
    R Function(UniqueId commentId) dislikeFailure,
    R Function(UniqueId taskId) archiveFailure,
    R Function(UniqueId taskId) unarchiveFailure,
    R Function(UniqueId itemId) itemCompleteFailure,
  ) =>
      itemCompleteFailure(id);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is _TaskFailureItemCompleteFailure && id == other.id);

  @override
  int get hashCode => runtimeType.hashCode ^ id.hashCode;

  @override
  String toString() => "TaskFailure: complete item $id failure";
}
