import 'package:aspdm_project/bloc/task_bloc.dart';
import 'package:aspdm_project/model/task.dart';
import 'package:aspdm_project/pages/desktop/task_info_page_content_desktop.dart';
import 'package:aspdm_project/pages/mobile/task_info_page_content_mobile.dart';
import 'package:aspdm_project/repositories/task_repository.dart';
import 'package:aspdm_project/services/log_service.dart';
import 'package:aspdm_project/services/navigation_service.dart';
import 'package:aspdm_project/states/auth_state.dart';
import 'package:aspdm_project/widgets/comment_widget.dart';
import 'package:aspdm_project/widgets/expiration_badge.dart';
import 'package:aspdm_project/widgets/label_widget.dart';
import 'package:aspdm_project/widgets/responsive.dart';
import 'package:aspdm_project/widgets/user_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_overlay/loading_overlay.dart';

import '../locator.dart';

class TaskInfoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final taskId = locator<NavigationService>().arguments(context);
    return BlocProvider<TaskBloc>(
      create: (context) => TaskBloc(taskId, TaskRepository())..fetch(),
      child: TaskInfoPageWidget(),
    );
  }
}

class TaskInfoPageWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final currentUser = context.watch<AuthState>().currentUser;

    return BlocConsumer<TaskBloc, TaskState>(
        listenWhen: (_, current) => current.hasError && current.data != null,
        listener: (context, state) =>
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Unknown error occurred!")),
            ),
        builder: (context, state) {
          final canModify = (currentUser == state.data?.author) ||
              (state.data?.members?.any((e) => currentUser == e) ?? false);

          return Scaffold(
            appBar: AppBar(
              title: Text(state.data?.title ?? ""),
              centerTitle: true,
              actions: canModify
                  ? [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () => print("Edit..."),
                      ),
                      if (!state.data.archived)
                        IconButton(
                          icon: Icon(Icons.archive),
                          onPressed: () =>
                              context.read<TaskBloc>().archive(currentUser.id),
                        ),
                      if (state.data.archived)
                        IconButton(
                          icon: Icon(Icons.unarchive),
                          onPressed: () => context
                              .read<TaskBloc>()
                              .unarchive(currentUser.id),
                        ),
                    ]
                  : null,
            ),
            body: RefreshIndicator(
              onRefresh: () =>
                  context.read<TaskBloc>().fetch(showLoading: false),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  locator<LogService>().logBuild("TaskInfoPageWidget - $state");

                  if (!state.isLoading && state.data == null)
                    return SingleChildScrollView(
                      physics: AlwaysScrollableScrollPhysics(),
                      child: ConstrainedBox(
                        constraints:
                            BoxConstraints(minHeight: constraints.maxHeight),
                        child: Center(
                          child: Text("Nothing to show here"),
                        ),
                      ),
                    );

                  return LoadingOverlay(
                      isLoading: state.isLoading,
                      color: Colors.black45,
                      child: Responsive(
                        small: TaskInfoPageContentMobile(
                          task: state.data,
                          canModify: canModify,
                        ),
                        large: TaskInfoPageContentDesktop(
                          task: state.data,
                          canModify: canModify,
                        ),
                      ));
                },
              ),
            ),
          );
        });
  }
}

/// Widget that displays a [Card] with header elements.
class HeaderCard extends StatelessWidget {
  final Task task;

  const HeaderCard({Key key, this.task}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (task?.labels != null && task.labels.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 8.0,
                  runSpacing: 4.0,
                  children: [Icon(Icons.label)]
                    ..addAll(task.labels.map((l) => LabelWidget(label: l))),
                ),
              ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                children: [
                  Icon(Icons.person),
                  SizedBox(width: 8.0),
                  UserAvatar(user: task?.author, size: 32.0),
                ],
              ),
            ),
            if (task?.members != null && task.members.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 8.0,
                  runSpacing: 4.0,
                  children: [Icon(Icons.group)]..addAll(
                      task.members.map(
                        (member) => UserAvatar(
                          user: member,
                          size: 32.0,
                        ),
                      ),
                    ),
                ),
              ),
            if (task?.expireDate != null) ExpirationText(date: task.expireDate),
          ],
        ),
      ),
    );
  }
}

/// Widget that displays a [Card] with the description.
class DescriptionCard extends StatelessWidget {
  final Task task;

  const DescriptionCard({Key key, this.task}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (task?.description != null)
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Icon(Icons.format_align_left),
                  SizedBox(width: 8.0),
                  Text(
                    "Description",
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ],
              ),
              SizedBox(height: 8.0),
              Text(
                task.description,
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ],
          ),
        ),
      );
    else
      return SizedBox.shrink();
  }
}

/// Widget that displays a [Card] with the comments.
class CommentsCard extends StatelessWidget {
  final Task task;

  const CommentsCard({Key key, this.task}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Icon(Icons.message),
                SizedBox(width: 8.0),
                Text(
                  "Comments",
                  style: Theme.of(context).textTheme.headline6,
                ),
              ],
            ),
            AddCommentWidget(
              onNewComment: (content) => context.read<TaskBloc>().addComment(
                    content,
                    context.read<AuthState>().currentUser.id,
                  ),
            ),
            if (task?.comments != null && task.comments.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: task.comments
                    .map(
                      (comment) => CommentWidget(
                        comment: comment,
                        onDelete: () => context.read<TaskBloc>().deleteComment(
                              comment.id,
                              context.read<AuthState>().currentUser.id,
                            ),
                        onEdit: (content) =>
                            context.read<TaskBloc>().editComment(
                                  comment.id,
                                  content,
                                  context.read<AuthState>().currentUser.id,
                                ),
                        onLike: () => context.read<TaskBloc>().likeComment(
                              comment.id,
                              context.read<AuthState>().currentUser.id,
                            ),
                        onDislike: () =>
                            context.read<TaskBloc>().dislikeComment(
                                  comment.id,
                                  context.read<AuthState>().currentUser.id,
                                ),
                      ),
                    )
                    .toList(),
              ),
          ],
        ),
      ),
    );
  }
}
