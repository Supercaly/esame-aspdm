import 'package:aspdm_project/dummy_data.dart';
import 'package:aspdm_project/model/task.dart';

class ArchiveRepository {
  Future<List<Task>> getArchivedTasks() async {
    await Future.delayed(Duration(seconds: 5));
    return DummyData.archivedTasks;
  }
}
