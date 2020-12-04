import 'package:aspdm_project/model/user.dart';
import 'package:equatable/equatable.dart';

/// Class representing a single comment of a task.
class Comment extends Equatable {
  /// The text content of the comment.
  final String content;

  /// The [User] that created the comment.
  final User user;

  /// Number of likes.
  final int likes;

  /// Number of dislikes.
  final int dislikes;

  /// Date when the comment was created.
  final DateTime creationDate;

  /// Flag telling that the current user has liked this comment.
  final bool liked;

  /// Flag telling that the current user has disliked this comment.
  final bool disliked;

  Comment({
    this.content,
    this.user,
    this.likes,
    this.dislikes,
    this.creationDate,
    this.liked,
    this.disliked,
  });

  /// Copy constructor that returns a new instance of [Comment]
  /// with equals to this in all but some fields.
  Comment copyWith({
    String content,
    User user,
    int likes,
    int dislikes,
    DateTime creationDate,
    bool liked,
    bool disliked,
  }) {
    return Comment(
      user: user ?? this.user,
      likes: likes ?? this.likes,
      dislikes: dislikes ?? this.dislikes,
      creationDate: creationDate ?? this.creationDate,
      content: content ?? this.content,
      liked: liked ?? this.liked,
      disliked: disliked ?? this.disliked,
    );
  }

  @override
  List<Object> get props => [
        content,
        user,
        likes,
        dislikes,
        liked,
        disliked,
        creationDate,
      ];
}
