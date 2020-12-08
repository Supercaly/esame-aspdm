import 'package:equatable/equatable.dart';
import 'checklist.dart';
import 'comment.dart';
import 'label.dart';
import 'user.dart';

/// Class representing a task.
class Task extends Equatable {
  /// Unique identifier.
  final String id;

  /// Title of the task.
  final String title;

  /// Description of the task.
  final String description;

  /// [Label]s associated with the task.
  final List<Label> labels;

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

  Task({
    this.id,
    this.title,
    this.description,
    this.labels,
    this.members,
    this.expireDate,
    this.checklists,
    this.comments,
  });

  @override
  List<Object> get props => [id];
}
