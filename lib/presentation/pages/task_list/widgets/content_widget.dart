import 'package:flutter/material.dart';
import 'package:tasky/core/ilist.dart';
import 'package:tasky/domain/entities/task.dart';
import 'package:tasky/presentation/pages/task_list/widgets/task_card.dart';
import 'package:tasky/presentation/widgets/responsive.dart';

import '../../../theme.dart';

class ContentWidget extends StatelessWidget {
  final IList<Task> tasks;

  const ContentWidget({
    Key key,
    @required this.tasks,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Theme(
        data: Responsive.isLarge(context)
            ? Theme.of(context).brightness == Brightness.light
                ? lightThemeDesktop
                : darkThemeDesktop
            : Theme.of(context),
        child: ListView.builder(
          padding: Responsive.isLarge(context)
              ? const EdgeInsets.only(top: 24.0)
              : null,
          itemCount: tasks.length,
          itemBuilder: (_, index) => Align(
            alignment: Alignment.center,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: Responsive.isLarge(context) ? 500 : double.infinity,
              ),
              child: TaskCard(task: tasks[index]),
            ),
          ),
        ),
      ),
    );
  }
}
