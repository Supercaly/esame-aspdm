import 'package:tasky/core/maybe.dart';
import 'package:tasky/domain/entities/comment.dart';
import 'package:tasky/domain/entities/user.dart';
import 'package:tasky/domain/values/task_values.dart';
import 'package:tasky/services/log_service.dart';
import 'package:tasky/application/states/auth_state.dart';
import 'package:tasky/presentation/pages/task_info/widgets/ago.dart';
import 'package:tasky/presentation/widgets/user_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../locator.dart';

/// Enum with the current type of the comment widget.
/// When type is [normal] the widget will display the comment;
/// when the type is [edit] the widget is in edit mode and will
/// let the user edit the comment.
enum CommentWidgetType {
  normal,
  edit,
}

/// Enum with the actions that a user can do on a comment.
/// The actions are:
/// - [edit] puts the widget in edit mode and let's the
///   user edit it
/// - [delete] tells the parent that the user want's to
///   delete this comment
enum CommentWidgetAction {
  edit,
  delete,
}

/// Widget that displays a [Comment].
class CommentWidget extends StatefulWidget {
  /// Instance of [Comment] to display.
  final Comment comment;

  /// Callback called when the user edited the comment.
  final void Function(CommentContent) onEdit;

  /// Callback called when the user wants to delete this comment.
  final VoidCallback onDelete;

  final VoidCallback onLike;
  final VoidCallback onDislike;

  CommentWidget({
    Key key,
    @required this.comment,
    this.onEdit,
    this.onDelete,
    this.onLike,
    this.onDislike,
  }) : super(key: key);

  @override
  _CommentWidgetState createState() => _CommentWidgetState();
}

class _CommentWidgetState extends State<CommentWidget> {
  CommentWidgetType _type;
  TextEditingController _editingController;

  @override
  void initState() {
    super.initState();

    _type = CommentWidgetType.normal;
    _editingController = TextEditingController(
        text: widget.comment?.content?.value?.getOrNull());
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          UserAvatar(
            size: 48.0,
            user: widget.comment?.author,
          ),
          SizedBox(width: 10.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.comment?.author?.name?.value?.getOrNull() ?? "",
                  style: Theme.of(context).textTheme.subtitle2,
                ),
                SizedBox(height: 10.0),
                (_type == CommentWidgetType.edit)
                    ? TextField(
                        controller: _editingController,
                        autofocus: true,
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                            icon: Icon(FeatherIcons.send,
                                color: Theme.of(context).accentColor),
                            onPressed: () {
                              final content =
                                  CommentContent(_editingController.text);
                              if (content.value.isRight()) {
                                widget.onEdit?.call(content);
                                setState(() {
                                  _type = CommentWidgetType.normal;
                                });
                              }
                            },
                          ),
                        ),
                        maxLength: CommentContent.maxLength,
                        maxLines: 10,
                        minLines: 1,
                        textInputAction: TextInputAction.done,
                      )
                    : Text(widget.comment?.content?.value?.getOrNull() ?? ""),
                SizedBox(height: 10.0),
                Selector<AuthState, Maybe<User>>(
                  selector: (_, state) => state.currentUser,
                  builder: (context, currentUser, _) => Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    runSpacing: 6.0,
                    children: [
                      if (_type == CommentWidgetType.normal)
                        LikeButton(
                          icon: FeatherIcons.thumbsUp,
                          value: widget.comment?.likes?.length ?? 0,
                          selected: widget.comment?.likes
                              ?.contains(currentUser?.getOrNull()),
                          onPressed: () => widget.onLike?.call(),
                        ),
                      if (_type == CommentWidgetType.normal)
                        SizedBox(width: 6.0),
                      if (_type == CommentWidgetType.normal)
                        LikeButton(
                          icon: FeatherIcons.thumbsDown,
                          value: widget.comment?.dislikes?.length ?? 0,
                          selected: widget.comment?.dislikes
                              ?.contains(currentUser?.getOrNull()),
                          onPressed: () => widget.onDislike?.call(),
                        ),
                      if (_type == CommentWidgetType.normal)
                        SizedBox(width: 6.0),
                      Ago(time: widget.comment?.creationDate),
                    ],
                  ),
                )
              ],
            ),
          ),
          if (_type == CommentWidgetType.normal)
            Selector<AuthState, Maybe<User>>(
              selector: (_, state) => state.currentUser,
              builder: (context, currentUser, _) =>
                  (currentUser?.getOrNull() == widget.comment?.author)
                      ? Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: PopupMenuButton<CommentWidgetAction>(
                            onSelected: (value) {
                              switch (value) {
                                case CommentWidgetAction.edit:
                                  setState(() {
                                    _type = CommentWidgetType.edit;
                                  });
                                  break;
                                case CommentWidgetAction.delete:
                                  widget.onDelete?.call();
                                  break;
                                default:
                                  locator<LogService>()
                                      .wtf("Unknown comment action $value");
                              }
                            },
                            itemBuilder: (context) => [
                              PopupMenuItem(
                                  value: CommentWidgetAction.edit,
                                  child: Text('edit_btn').tr()),
                              PopupMenuItem(
                                  value: CommentWidgetAction.delete,
                                  child: Text('delete_btn').tr()),
                            ],
                          ),
                        )
                      : SizedBox.shrink(),
            ),
        ],
      ),
    );
  }
}

/// Widget displaying a like/dislike button.
class LikeButton extends StatelessWidget {
  /// Icon of the button.
  final IconData icon;

  /// Number of likes.
  final int value;

  /// Callback called when the button is pressed.
  final VoidCallback onPressed;

  /// Flag representing a liked/disliked comment.
  final bool selected;

  const LikeButton({
    Key key,
    this.icon,
    this.value,
    this.onPressed,
    bool selected,
  })  : selected = selected ?? false,
        assert(icon != null),
        assert(value != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(24.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        decoration: BoxDecoration(
          color: (selected) ? Color(0xFFE3F2FD) : null,
          borderRadius: BorderRadius.circular(42.0),
          border: Border.all(
            color: (selected) ? Color(0xFF73C4FF) : Color(0xFFE3E3E3),
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon),
            SizedBox(width: 4.0),
            Text(value.toString()),
          ],
        ),
      ),
    );
  }
}

/// Widget that lets the user add a new comment.
class AddCommentWidget extends StatefulWidget {
  /// Callback called when the user finishes creating a new comment.
  final void Function(CommentContent) onNewComment;

  AddCommentWidget({
    Key key,
    this.onNewComment,
  }) : super(key: key);

  @override
  _AddCommentWidgetState createState() => _AddCommentWidgetState();
}

class _AddCommentWidgetState extends State<AddCommentWidget> {
  bool _sendEnabled;
  TextEditingController _controller;

  @override
  void initState() {
    super.initState();

    _sendEnabled = false;
    _controller = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      onChanged: (value) {
        setState(() {
          _sendEnabled = value?.isNotEmpty ?? false;
        });
      },
      decoration: InputDecoration(
        labelText: 'add_comment_label'.tr(),
        suffixIcon: IconButton(
          icon: Icon(FeatherIcons.send),
          onPressed: (_sendEnabled)
              ? () {
                  final content = CommentContent(_controller.text);
                  if (content.value.isRight()) {
                    widget.onNewComment?.call(content);
                    _controller.clear();
                    setState(() {
                      _sendEnabled = false;
                    });
                    FocusManager.instance.primaryFocus.unfocus();
                  }
                }
              : null,
        ),
      ),
      maxLength: CommentContent.maxLength,
      minLines: 1,
      maxLines: 6,
      textInputAction: TextInputAction.done,
    );
  }
}
