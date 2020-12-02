import 'package:aspdm_project/locator.dart';
import 'package:aspdm_project/services/log_service.dart';
import 'package:flutter/material.dart';

class TasksPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    locator<LogService>().logBuild("TasksPage");
    return Container(
      child: Center(
        child: Text("Tasks"),
      ),
    );
  }
}
