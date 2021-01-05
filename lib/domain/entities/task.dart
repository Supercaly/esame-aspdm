import 'package:aspdm_project/domain/values/task_description.dart';
import 'package:aspdm_project/domain/values/task_title.dart';
import 'package:aspdm_project/domain/values/toggle.dart';
import 'package:aspdm_project/domain/values/unique_id.dart';
import 'package:equatable/equatable.dart';
import 'checklist.dart';
import 'comment.dart';
import 'label.dart';
import 'user.dart';

/// Class representing a task.
class Task extends Equatable {
  /// Unique identifier.
  final UniqueId id;

  /// Title of the task.
  final TaskTitle title;

  /// Date when the task was created.
  final DateTime creationDate;

  /// Description of the task.
  final TaskDescription description;

  /// [Label]s associated with the task.
  final List<Label> labels;

  /// The [User] that created the task.
  final User author;

  /// [User]s assigned to the task.
  final List<User> members;

  /// Date when the task will expire.
  /// Note: after the expiration nothing will
  /// happen other that the application marking it.
  final DateTime expireDate;

  /// [Checklist]s associated with the task.
  final List<Checklist> checklists;

  /// [Comment]s associated with the task.
  final List<Comment> comments;

  /// If `true` this task was archived,
  /// otherwise it's still accessible.
  final Toggle archived;

  Task(
    this.id,
    this.title,
    this.description,
    this.labels,
    this.author,
    this.members,
    this.expireDate,
    this.checklists,
    this.comments,
    this.archived,
    this.creationDate,
  );

  @override
  List<Object> get props => [
        id,
        title,
        description,
        labels,
        author,
        members,
        expireDate,
        checklists,
        comments,
        archived,
        creationDate,
      ];

  @override
  String toString() =>
      'Task{id: $id, title: $title, description: $description, '
      'labels: $labels, author: $author, members: $members, '
      'expireDate: $expireDate, checklists: $checklists, '
      'comments: $comments, creationDate: $creationDate, '
      'archived: $archived}';
}
