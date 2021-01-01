import 'package:aspdm_project/data/models/user_model.dart';
import 'package:aspdm_project/domain/entities/comment.dart';
import 'package:json_annotation/json_annotation.dart';

part 'comment_model.g.dart';

@JsonSerializable()
class CommentModel {
  @JsonKey(
    name: "_id",
    required: true,
    disallowNullValue: true,
  )
  final String id;

  @JsonKey(required: true, defaultValue: "")
  final String content;

  @JsonKey(
    required: true,
    disallowNullValue: true,
  )
  final UserModel author;

  @JsonKey(name: "like_users")
  final List<UserModel> likes;

  @JsonKey(name: "dislike_users")
  final List<UserModel> dislikes;

  @JsonKey(
    name: "creation_date",
    required: true,
    disallowNullValue: true,
  )
  final DateTime creationDate;

  CommentModel(
    this.id,
    this.content,
    this.author,
    this.likes,
    this.dislikes,
    this.creationDate,
  );

  factory CommentModel.fromJson(Map<String, dynamic> json) =>
      _$CommentModelFromJson(json);

  Map<String, dynamic> toJson() => _$CommentModelToJson(this);

  factory CommentModel.fromComment(Comment comment) => CommentModel(
        comment.id,
        comment.content,
        (comment.author == null) ? null : UserModel.fromUser(comment.author),
        comment.likes?.map((e) => UserModel.fromUser(e))?.toList(),
        comment.dislikes?.map((e) => UserModel.fromUser(e))?.toList(),
        comment.creationDate,
      );

  Comment toComment() => Comment(
        id,
        content,
        author?.toUser(),
        likes?.map((e) => e.toUser())?.toList(),
        dislikes?.map((e) => e.toUser())?.toList(),
        creationDate,
      );
}
