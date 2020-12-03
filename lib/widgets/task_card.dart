import 'package:aspdm_project/model/task.dart';
import 'package:aspdm_project/widgets/expiration_badge.dart';
import 'package:aspdm_project/widgets/label_widget.dart';
import 'package:flutter/material.dart';

class TaskCard extends StatelessWidget {
  final Task task;

  TaskCard(this.task);

  @override
  Widget build(BuildContext context) {
    final hasDescription = task.description != null;
    final hasChecklists = task.checklists != null && task.checklists.isNotEmpty;
    final hasMembers = task.members != null && task.members.isNotEmpty;
    final hasComments = task.comments != null && task.comments.isNotEmpty;
    final hasExpiration = task.expireDate != null;

    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            (task.labels != null && task.labels.isNotEmpty)
                ? Wrap(
                    spacing: 10.0,
                    runSpacing: 5.0,
                    children:
                        task.labels.map((label) => LabelWidget(label)).toList(),
                  )
                : SizedBox.shrink(),
            SizedBox(height: 10.0),
            Text(
              "Title",
              style: Theme.of(context).textTheme.headline5,
            ),
            SizedBox(height: 10.0),
            Row(
              children: [
                if (hasDescription) TaskIcon(
                  icon: Icons.format_align_left,
                ),
                if (hasDescription) SizedBox(width: 10.0),
                if (hasChecklists) TaskIcon(
                  icon: Icons.check_circle,
                  text: "7/10",
                ),
                if (hasChecklists) SizedBox(width: 10.0),
                if (hasComments) TaskIcon(
                  icon: Icons.message,
                  text: task.comments.length.toString(),
                ),
                if (hasComments) SizedBox(width: 10.0),
                if (hasMembers) TaskIcon(
                  icon: Icons.person,
                  text: task.members.length.toString(),
                ),
              ],
            ),
            if (hasExpiration) SizedBox(height: 10.0),
            if (hasExpiration) ExpirationBadge(task.expireDate),
          ],
        ),
      ),
    );
  }
}

class TaskIcon extends StatelessWidget {
  final IconData icon;
  final String text;

  TaskIcon({this.icon, this.text});

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Icon(
        icon,
        color: Color(0xFF666666),
      ),
      SizedBox(width: 4.0),
      (text != null) ? Text(text) : SizedBox.shrink(),
    ]);
  }
}
