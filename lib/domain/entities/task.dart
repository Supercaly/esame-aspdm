import 'package:flutter/foundation.dart';
import 'package:tasky/core/ilist.dart';
import 'package:tasky/core/maybe.dart';
import 'package:tasky/domain/values/task_values.dart';
import 'package:tasky/domain/values/unique_id.dart';
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
  final CreationDate creationDate;

  /// Description of the task.
  final Maybe<TaskDescription> description;

  /// [Label]s associated with the task.
  final IList<Label> labels;

  /// The [User] that created the task.
  final User author;

  /// [User]s assigned to the task.
  final IList<User> members;

  /// Date when the task will expire.
  /// Note: after the expiration nothing will
  /// happen other that the application marking it.
  final Maybe<ExpireDate> expireDate;

  /// [Checklist]s associated with the task.
  final IList<Checklist> checklists;

  /// [Comment]s associated with the task.
  final IList<Comment> comments;

  /// If `true` this task was archived,
  /// otherwise it's still accessible.
  final Toggle archived;

  /// Create a new [Task] with all of his values.
  const Task({
    required this.id,
    required this.title,
    required this.description,
    required this.labels,
    required this.author,
    required this.members,
    required this.expireDate,
    required this.checklists,
    required this.comments,
    required this.archived,
    required this.creationDate,
  });

  /// Create a new [Task] with some of his values.
  /// If a value is not specified a safe default
  /// will be used instead.
  @visibleForTesting
  factory Task.test({
    UniqueId? id,
    TaskTitle? title,
    Maybe<TaskDescription>? description,
    IList<Label>? labels,
    User? author,
    IList<User>? members,
    Maybe<ExpireDate>? expireDate,
    IList<Checklist>? checklists,
    IList<Comment>? comments,
    Toggle? archived,
    CreationDate? creationDate,
  }) =>
      Task(
        id: id ?? UniqueId.empty(),
        title: title ?? TaskTitle.empty(),
        description: description ?? Maybe.nothing(),
        labels: labels ?? IList.empty(),
        author: author ?? User.empty(),
        members: members ?? IList.empty(),
        expireDate: expireDate ?? Maybe.nothing(),
        checklists: checklists ?? IList.empty(),
        comments: comments ?? IList.empty(),
        archived: archived ?? Toggle(false),
        creationDate: creationDate ?? CreationDate(null),
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
