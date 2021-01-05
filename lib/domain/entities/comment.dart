import 'package:aspdm_project/domain/values/comment_content.dart';
import 'package:aspdm_project/domain/values/unique_id.dart';

import 'user.dart';
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
  final List<User> likes;

  /// [User]s that disliked this comment.
  final List<User> dislikes;

  /// Date when the comment was created.
  final DateTime creationDate;

  const Comment(
    this.id,
    this.content,
    this.author,
    this.likes,
    this.dislikes,
    this.creationDate,
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
