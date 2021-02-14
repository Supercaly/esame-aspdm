import 'package:tasky/core/maybe.dart';
import 'package:tasky/domain/values/unique_id.dart';
import 'package:tasky/application/bloc/task_bloc.dart';
import 'package:tasky/domain/entities/task.dart';
import 'package:tasky/presentation/pages/task_info/widgets/task_info_page_content_desktop.dart';
import 'package:tasky/presentation/pages/task_info/widgets/task_info_page_content_mobile.dart';
import 'package:tasky/domain/repositories/task_repository.dart';
import 'package:tasky/presentation/routes.dart';
import 'package:tasky/services/link_service.dart';
import 'package:tasky/services/log_service.dart';
import 'package:tasky/services/navigation_service.dart';
import 'package:tasky/application/states/auth_state.dart';
import 'package:tasky/presentation/pages/task_info/widgets/comment_widget.dart';
import 'package:tasky/presentation/widgets/expiration_badge.dart';
import 'package:tasky/presentation/widgets/label_widget.dart';
import 'package:tasky/presentation/widgets/responsive.dart';
import 'package:tasky/presentation/widgets/user_avatar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:share/share.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../locator.dart';

class TaskInfoPage extends StatelessWidget {
  final Maybe<UniqueId> taskId;

  const TaskInfoPage({
    Key key,
    @required this.taskId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TaskBloc>(
      create: (context) => TaskBloc(
        taskId: taskId,
        repository: locator<TaskRepository>(),
        logService: locator<LogService>(),
        linkService: locator<LinkService>(),
      )..fetch(),
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
              SnackBar(content: Text('unknown_error_msg').tr()),
            ),
        builder: (context, state) {
          final canModify = (currentUser.getOrNull() == state.data?.author) ||
              (state.data?.members?.contains(currentUser.getOrNull()) ?? false);

          return Scaffold(
            appBar: AppBar(
              title: Text(state.data?.title?.value?.getOrNull() ?? ""),
              centerTitle: true,
              actions: [
                if (!kIsWeb)
                  BlocListener<TaskBloc, TaskState>(
                    listenWhen: (p, c) =>
                        (!p.shareError && c.shareError) ||
                        (c.shareLink != p.shareLink),
                    listener: (context, state) {
                      if (state.shareError)
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('error_sharing_task_msg').tr()));
                      else if (state.shareLink != null)
                        Share.share(state.shareLink);
                    },
                    child: IconButton(
                      icon: Icon(FeatherIcons.share2),
                      onPressed: () async =>
                          await context.read<TaskBloc>().share(),
                    ),
                  ),
                if (canModify)
                  IconButton(
                    icon: Icon(FeatherIcons.edit),
                    onPressed: () async {
                      final updated =
                          await locator<NavigationService>().navigateTo(
                        Routes.taskForm,
                        arguments: state.data,
                      );

                      if (updated != null && updated)
                        context.read<TaskBloc>().fetch(showLoading: false);
                    },
                    tooltip: 'edit_tooltip'.tr(),
                  ),
                if (canModify && !state.data.archived.value.getOrCrash())
                  IconButton(
                    icon: Icon(FeatherIcons.sunset),
                    onPressed: () => context
                        .read<TaskBloc>()
                        .archive(currentUser.map((u) => u.id)),
                    tooltip: 'archive_tooltip'.tr(),
                  ),
                if (canModify && state.data.archived.value.getOrCrash())
                  IconButton(
                    icon: Icon(FeatherIcons.sunrise),
                    tooltip: 'unarchive_tooltip'.tr(),
                    onPressed: () => context
                        .read<TaskBloc>()
                        .unarchive(currentUser.map((u) => u.id)),
                  ),
              ],
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
                          child: Text('nothing_to_show_msg').tr(),
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
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (task?.labels != null && task.labels.isNotEmpty)
              ListTile(
                leading: Icon(FeatherIcons.tag),
                title: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 8.0,
                  runSpacing: 4.0,
                  children:
                      task.labels.map((l) => LabelWidget(label: l)).asList(),
                ),
              ),
            ListTile(
              leading: Icon(FeatherIcons.user),
              title: Row(
                children: [
                  UserAvatar(user: task?.author, size: 32.0),
                ],
              ),
            ),
            if (task?.members != null && task.members.isNotEmpty)
              ListTile(
                leading: Icon(FeatherIcons.users),
                title: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 8.0,
                  runSpacing: 4.0,
                  children: task.members
                      .map((member) => UserAvatar(user: member, size: 32.0))
                      .asList(),
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
    if (task?.description?.value?.getOrNull() != null &&
        task.description.value.getOrNull().isNotEmpty)
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Icon(FeatherIcons.alignLeft),
                  SizedBox(width: 8.0),
                  Text(
                    'description_title',
                    style: Theme.of(context).textTheme.headline6,
                  ).tr(),
                ],
              ),
              SizedBox(height: 8.0),
              Text(
                task.description.value.getOrCrash(),
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
                Icon(FeatherIcons.messageSquare),
                SizedBox(width: 8.0),
                Text(
                  'comments_title',
                  style: Theme.of(context).textTheme.headline6,
                ).tr(),
              ],
            ),
            AddCommentWidget(
              onNewComment: (content) => context.read<TaskBloc>().addComment(
                    content,
                    context.read<AuthState>().currentUser.map((u) => u.id),
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
                              context
                                  .read<AuthState>()
                                  .currentUser
                                  .map((u) => u.id),
                            ),
                        onEdit: (content) =>
                            context.read<TaskBloc>().editComment(
                                  comment.id,
                                  content,
                                  context
                                      .read<AuthState>()
                                      .currentUser
                                      .map((u) => u.id),
                                ),
                        onLike: () => context.read<TaskBloc>().likeComment(
                              comment.id,
                              context
                                  .read<AuthState>()
                                  .currentUser
                                  .map((u) => u.id),
                            ),
                        onDislike: () =>
                            context.read<TaskBloc>().dislikeComment(
                                  comment.id,
                                  context
                                      .read<AuthState>()
                                      .currentUser
                                      .map((u) => u.id),
                                ),
                      ),
                    )
                    .asList(),
              ),
          ],
        ),
      ),
    );
  }
}
