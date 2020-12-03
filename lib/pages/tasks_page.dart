import 'package:aspdm_project/locator.dart';
import 'package:aspdm_project/model/checklist.dart';
import 'package:aspdm_project/model/comment.dart';
import 'package:aspdm_project/model/label.dart';
import 'package:aspdm_project/model/task.dart';
import 'package:aspdm_project/model/user.dart';
import 'package:aspdm_project/services/log_service.dart';
import 'package:aspdm_project/widgets/task_card.dart';
import 'package:flutter/material.dart';

class TasksPage extends StatelessWidget {
  final List<Task> _dummyTasks = [
    Task(
      "0",
      "title",
      "description",
      [Label(Colors.green, null)],
      null,
      null,
      null,
      null,
    ),
    Task(
      "1",
      "title",
      null,
      [Label(Colors.red, null)],
      [User()],
      DateTime.now(),
      [Checklist()],
      null,
    ),
    Task(
      "2",
      "title",
      "description",
      [
        Label(Colors.green, null),
        Label(Colors.red, null),
        Label(Colors.blue, null),
      ],
      [User()],
      DateTime.now(),
      [Checklist()],
      [Comment()],
    ),
    Task(
      "3",
      "title",
      null,
      null,
      null,
      null,
      null,
      null,
    ),
    Task(
      "4",
      "title",
      "description",
      [
        Label(Colors.green, null),
        Label(Colors.red, null),
      ],
      [User()],
      null,
      null,
      [Comment(),Comment(),],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    locator<LogService>().logBuild("TasksPage");
    return ListView.builder(
      itemBuilder: (_, index) => TaskCard(_dummyTasks[index]),
      itemCount: _dummyTasks.length,
    );
  }
}
