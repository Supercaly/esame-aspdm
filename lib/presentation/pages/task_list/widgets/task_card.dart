import 'package:tasky/locator.dart';
import 'package:tasky/domain/entities/task.dart';
import 'package:tasky/presentation/routes.dart';
import 'package:tasky/services/navigation_service.dart';
import 'package:tasky/presentation/widgets/label_widget.dart';
import 'package:tasky/presentation/widgets/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

import 'expiration_badge.dart';

/// Widget displaying a card with a short recap
/// of all the task's info.
/// This widget can't be created with a task that has
/// null [title].
class TaskCard extends StatelessWidget {
  /// The task to display.
  final Task task;

  TaskCard({
    Key? key,
    required this.task,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final hasDescription = task.description.fold(
      () => false,
      (value) => value.value.fold(
        (_) => false,
        (_) => true,
      ),
    );
    final hasChecklists = task.checklists.isNotEmpty;
    final hasMembers = task.members.isNotEmpty;
    final hasComments = task.comments.isNotEmpty;
    final hasExpiration = task.expireDate.fold(
      () => false,
      (value) => value.value.fold(
        (_) => false,
        (_) => true,
      ),
    );

    final isLarge = Responsive.isLarge(context);

    return Card(
      child: InkWell(
        onTap: () {
          locator<NavigationService>()
              .navigateTo(Routes.task, arguments: task.id);
        },
        child: Padding(
          padding: isLarge
              ? const EdgeInsets.all(24.0)
              : const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              (task.labels.isNotEmpty)
                  ? Wrap(
                      spacing: 10.0,
                      runSpacing: 5.0,
                      children: task.labels
                          .map((label) => LabelWidget(
                                label: label,
                                compact: !isLarge,
                              ))
                          .asList(),
                    )
                  : SizedBox.shrink(),
              SizedBox(height: 10.0),
              Text(
                task.title.value.getOrElse((_) => ""),
                style: Theme.of(context).textTheme.headline5,
              ),
              SizedBox(height: 10.0),
              Row(
                children: [
                  if (hasDescription)
                    TaskIcon(
                      icon: FeatherIcons.alignLeft,
                    ),
                  if (hasDescription) SizedBox(width: 10.0),
                  if (hasChecklists)
                    TaskIcon(
                      icon: FeatherIcons.checkCircle,
                      text: _getChecklistCount(),
                    ),
                  if (hasChecklists) SizedBox(width: 10.0),
                  if (hasComments)
                    TaskIcon(
                      icon: FeatherIcons.messageSquare,
                      text: task.comments.length.toString(),
                    ),
                  if (hasComments) SizedBox(width: 10.0),
                  if (hasMembers)
                    TaskIcon(
                      icon: FeatherIcons.users,
                      text: task.members.length.toString(),
                    ),
                ],
              ),
              if (hasExpiration) SizedBox(height: 10.0),
              if (hasExpiration)
                ExpirationBadge(
                  date: task.expireDate.getOrCrash().value.getOrCrash(),
                ),
            ],
          ),
        ),
      ),
    );
  }

  /// Returns a string with the number
  /// of completed items of all the checklists.
  /// The string is formatted as checked/total.
  String _getChecklistCount() {
    int totalItems = 0;
    int checkedItems = 0;
    task.checklists.forEach((c) {
      c.items.forEach((i) {
        totalItems++;
        if (i.complete.value.getOrElse((_) => false)) checkedItems++;
      });
    });
    return "$checkedItems/$totalItems";
  }
}

/// Widget with an icon ad a text used in [TaskCard].
class TaskIcon extends StatelessWidget {
  final IconData icon;
  final String? text;

  TaskIcon({
    Key? key,
    required this.icon,
    this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Icon(icon),
      SizedBox(width: 4.0),
      (text != null) ? Text(text!) : SizedBox.shrink(),
    ]);
  }
}
