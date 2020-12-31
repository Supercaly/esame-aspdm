import '../entities/task.dart';

abstract class HomeRepository {
  Future<List<Task>> getTasks();
}
