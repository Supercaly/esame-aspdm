import 'package:aspdm_project/model/task.dart';

class TaskState {
  bool _loading;
  List<Task> _tasks;

  TaskState() {
    _loading = false;
    _tasks = [];
  }

  Future<Task> getTask(String id) async {}

  Future<List<Task>> getTasks(){}
}
