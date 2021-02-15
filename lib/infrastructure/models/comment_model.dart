import 'package:tasky/core/ilist.dart';
import 'package:tasky/infrastructure/models/user_model.dart';
import 'package:tasky/domain/entities/comment.dart';
import 'package:tasky/domain/values/task_values.dart';
import 'package:tasky/domain/values/unique_id.dart';
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
        comment.likes?.map((e) => UserModel.fromUser(e))?.asList(),
        comment.dislikes?.map((e) => UserModel.fromUser(e))?.asList(),
        comment.creationDate,
      );

  Comment toComment() => Comment(
        id: UniqueId(id),
        content: CommentContent(content),
        author: author?.toUser(),
        likes: IList.from(likes?.map((e) => e.toUser())),
        dislikes: IList.from(dislikes?.map((e) => e.toUser())),
        creationDate: creationDate,
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
