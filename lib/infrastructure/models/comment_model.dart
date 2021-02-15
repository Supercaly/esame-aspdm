import 'package:flutter/foundation.dart';
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

  CommentModel({
    @required this.id,
    @required this.content,
    @required this.author,
    @required this.likes,
    @required this.dislikes,
    @required this.creationDate,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) =>
      _$CommentModelFromJson(json);

  Map<String, dynamic> toJson() => _$CommentModelToJson(this);

  factory CommentModel.fromDomain(Comment comment) => CommentModel(
        id: comment.id.value.getOrNull(),
        content: comment.content.value.getOrNull(),
        author: (comment.author == null)
            ? null
            : UserModel.fromDomain(comment.author),
        likes: comment.likes?.map((e) => UserModel.fromDomain(e))?.asList(),
        dislikes:
            comment.dislikes?.map((e) => UserModel.fromDomain(e))?.asList(),
        creationDate: comment.creationDate,
      );

  Comment toDomain() => Comment(
        id: UniqueId(id),
        content: CommentContent(content),
        author: author?.toDomain(),
        likes: IList.from(likes?.map((e) => e.toDomain())),
        dislikes: IList.from(dislikes?.map((e) => e.toDomain())),
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
