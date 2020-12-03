import 'package:aspdm_project/dummy_data.dart';
import 'package:aspdm_project/locator.dart';
import 'package:aspdm_project/services/log_service.dart';
import 'package:aspdm_project/widgets/task_card.dart';
import 'package:flutter/material.dart';

class TasksPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    locator<LogService>().logBuild("TasksPage");
    return ListView.builder(
      itemBuilder: (_, index) => TaskCard(DummyData.tasks[index]),
      itemCount: DummyData.tasks.length,
    );
  }
}
