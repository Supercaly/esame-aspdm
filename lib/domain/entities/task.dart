import 'package:aspdm_project/domain/values/task_values.dart';
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

  factory Task.empty() => Task(
        UniqueId("INVALID_ID"),
        TaskTitle(null),
        TaskDescription(null),
        null,
        null,
        null,
        null,
        List.empty(),
        null,
        null,
        null,
      );

  /// Returns a new [Task] from this one, but
  /// with some different fields.
  // TODO: Fix bug with null parameters
  // This will be fixed when TaskPrimitive is in place
  Task copyWith({
    TaskTitle title,
    TaskDescription description,
    List<Label> labels,
    User author,
    List<User> members,
    DateTime expireDate,
    List<Checklist> checklists,
    List<Comment> comments,
    Toggle archived,
    DateTime creationDate,
  }) =>
      Task(
        this.id,
        title ?? this.title,
        description ?? this.description,
        labels ?? this.labels,
        author ?? this.author,
        members ?? this.members,
        expireDate ?? this.expireDate,
        checklists ?? this.checklists,
        comments ?? this.comments,
        archived ?? this.archived,
        creationDate ?? this.creationDate,
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
