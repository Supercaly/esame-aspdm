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
  @JsonKey(required: true, disallowNullValue: true)
  final String id;

  /// Title of the task.
  @JsonKey(nullable: true)
  final String title;

  /// Description of the task.
  @JsonKey(nullable: true)
  final String description;

  /// [Label]s associated with the task.
  final List<Label> labels;

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
        members,
        expireDate,
        checklists,
        comments,
      ];

  @override
  String toString() =>
      'Task{id: $id, title: $title, comments: $comments} $hashCode';
}
