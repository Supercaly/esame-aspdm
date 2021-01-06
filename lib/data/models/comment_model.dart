import 'package:aspdm_project/data/models/user_model.dart';
import 'package:aspdm_project/domain/entities/comment.dart';
import 'package:aspdm_project/domain/values/task_values.dart';
import 'package:aspdm_project/domain/values/unique_id.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'comment_model.g.dart';

@JsonSerializable()
class CommentModel extends Equatable {
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
        comment.id.value.getOrNull(),
        comment.content.value.getOrNull(),
        (comment.author == null) ? null : UserModel.fromUser(comment.author),
        comment.likes?.map((e) => UserModel.fromUser(e))?.toList(),
        comment.dislikes?.map((e) => UserModel.fromUser(e))?.toList(),
        comment.creationDate,
      );

  Comment toComment() => Comment(
        UniqueId(id),
        CommentContent(content),
        author?.toUser(),
        likes?.map((e) => e.toUser())?.toList(),
        dislikes?.map((e) => e.toUser())?.toList(),
        creationDate,
      );

  @override
  List<Object> get props => [
        id,
        content,
        author,
        likes,
        dislikes,
        creationDate,
      ];
}
