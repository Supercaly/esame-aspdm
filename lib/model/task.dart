import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'checklist.dart';
import 'comment.dart';
import 'label.dart';
import 'user.dart';

part 'task.g.dart';

/// Class representing a task.
@JsonSerializable()
class Task extends Equatable {
  /// Unique identifier.
  @JsonKey(
    name: "_id",
    required: true,
    disallowNullValue: true,
  )
  final String id;

  /// Title of the task.
  @JsonKey(required: true, disallowNullValue: true)
  final String title;

  /// Date when the task was created.
  @JsonKey(
    name: "creation_date",
    required: true,
    disallowNullValue: true,
  )
  final DateTime creationDate;

  /// Description of the task.
  @JsonKey(nullable: true)
  final String description;

  /// [Label]s associated with the task.
  final List<Label> labels;

  /// The [User] that created the task.
  @JsonKey(required: true, disallowNullValue: true)
  final User author;

  /// [User]s assigned to the task.
  final List<User> members;

  /// Date when the task will expire.
  /// Note: after the expiration nothing will
  /// happen other that the application marking it.
  @JsonKey(name: "expire_date")
  final DateTime expireDate;

  /// [Checklist]s associated with the task.
  final List<Checklist> checklists;

  /// [Comment]s associated with the task.
  final List<Comment> comments;

  /// If `true` this task was archived,
  /// otherwise it's still accessible.
  @JsonKey(defaultValue: false)
  final bool archived;

  Task(
      {this.id,
      this.title,
      this.description,
      this.labels,
      this.author,
      this.members,
      this.expireDate,
      this.checklists,
      this.comments,
      this.archived,
      this.creationDate});

  /// Creates a new [User] from json data.
  factory Task.fromJson(Map<String, dynamic> json) => _$TaskFromJson(json);

  /// Converts this [User] to json data.
  Map<String, dynamic> toJson() => _$TaskToJson(this);

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
