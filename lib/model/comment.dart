import 'package:aspdm_project/model/user.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'comment.g.dart';

/// Class representing a single comment of a task.
@JsonSerializable()
class Comment extends Equatable {
  /// Id of the comment.
  @JsonKey(
    name: "_id",
    required: true,
    disallowNullValue: true,
  )
  final String id;

  /// The text content of the comment.
  @JsonKey(required: true, defaultValue: "")
  final String content;

  /// The [User] that created the comment.
  @JsonKey(
    required: true,
    disallowNullValue: true,
  )
  final User author;

  /// [User]s that liked this comment.
  @JsonKey(name: "like_users")
  final List<User> likes;

  /// [User]s that disliked this comment.
  @JsonKey(name: "dislike_users")
  final List<User> dislikes;

  /// Date when the comment was created.
  @JsonKey(
    name: "creation_date",
    required: true,
    disallowNullValue: true,
  )
  final DateTime creationDate;

  const Comment(
    this.id,
    this.content,
    this.author,
    this.likes,
    this.dislikes,
    this.creationDate,
  );

  /// Creates a new [Comment] from json data.
  factory Comment.fromJson(Map<String, dynamic> json) =>
      _$CommentFromJson(json);

  /// Converts this [Comment] to json data.
  Map<String, dynamic> toJson() => _$CommentToJson(this);

  @override
  List<Object> get props => [
        id,
        content,
        author,
        creationDate,
      ];

  @override
  String toString() => 'Comment{id: $id, content: $content, author: $author, '
      'likes: ${likes?.length}, dislikes: ${dislikes?.length}, '
      'creationDate: $creationDate}';
}
