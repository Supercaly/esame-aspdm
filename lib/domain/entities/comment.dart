import 'package:flutter/foundation.dart';
import 'package:tasky/core/ilist.dart';
import 'package:tasky/domain/entities/user.dart';
import 'package:tasky/domain/values/task_values.dart';
import 'package:tasky/domain/values/unique_id.dart';
import 'package:equatable/equatable.dart';

/// Class representing a single comment of a task.
class Comment extends Equatable {
  /// Id of the comment.
  final UniqueId id;

  /// The text content of the comment.
  final CommentContent content;

  /// The [User] that created the comment.
  final User author;

  /// [User]s that liked this comment.
  final IList<User> likes;

  /// [User]s that disliked this comment.
  final IList<User> dislikes;

  /// Date when the comment was created.
  final CreationDate creationDate;

  /// Create a new [Comment] with all his values.
  const Comment({
    @required this.id,
    @required this.content,
    @required this.author,
    @required this.likes,
    @required this.dislikes,
    @required this.creationDate,
  });

  /// Create a new [Label] with some of his values.
  /// If a value is not specified a safe default
  /// will be used instead.
  @visibleForTesting
  factory Comment.test({
    UniqueId id,
    CommentContent content,
    User author,
    IList<User> likes,
    IList<User> dislikes,
    CreationDate creationDate,
  }) =>
      Comment(
        id: id ?? UniqueId.empty(),
        content: content ?? CommentContent(null),
        author: author,
        likes: likes ?? IList.empty(),
        dislikes: dislikes ?? IList.empty(),
        creationDate: creationDate ?? CreationDate(null),
      );

  @override
  List<Object> get props => [
        id,
        content,
        author,
        creationDate,
        likes,
        dislikes,
      ];

  @override
  String toString() => 'Comment{id: $id, content: $content, author: $author, '
      'likes: ${likes?.length}, dislikes: ${dislikes?.length}, '
      'creationDate: $creationDate}';
}
