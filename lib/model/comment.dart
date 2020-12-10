import 'package:aspdm_project/model/user.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'comment.g.dart';

/// Class representing a single comment of a task.
@JsonSerializable()
class Comment extends Equatable {
  /// Id of the comment.
  @JsonKey(required: true, disallowNullValue: true)
  final String id;

  /// The text content of the comment.
  @JsonKey(required: true, disallowNullValue: true)
  final String content;

  /// The [User] that created the comment.
  @JsonKey(required: true, disallowNullValue: true)
  final User user;

  /// Number of likes.
  @JsonKey(defaultValue: 0)
  final int likes;

  /// Number of dislikes.
  @JsonKey(defaultValue: 0)
  final int dislikes;

  /// Date when the comment was created.
  @JsonKey(name: "creation_date", required: true, disallowNullValue: true)
  final DateTime creationDate;

  /// Flag telling that the current user has liked this comment.
  @JsonKey(defaultValue: false)
  final bool liked;

  /// Flag telling that the current user has disliked this comment.
  @JsonKey(defaultValue: false)
  final bool disliked;

  const Comment(
    this.id,
    this.content,
    this.user,
    this.likes,
    this.dislikes,
    this.creationDate,
    this.liked,
    this.disliked,
  );

  /// Creates a new [Comment] from json data.
  factory Comment.fromJson(Map<String, dynamic> json) =>
      _$CommentFromJson(json);

  /// Converts this [Comment] to json data.
  Map<String, dynamic> fromJson() => _$CommentToJson(this);

  @override
  List<Object> get props => [
        id,
        content,
        likes,
        dislikes,
        liked,
        disliked,
      ];

  @override
  String toString() =>
      "Comment{id: $id, likes: $likes, dislikes: $dislikes, liked: $liked, disliked: $disliked}";
}
