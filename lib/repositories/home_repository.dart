import 'package:aspdm_project/dummy_data.dart';
import 'package:aspdm_project/model/task.dart';

class HomeRepository {
  Future<List<Task>> getTasks() async {
    print("gett");
    await Future.delayed(Duration(seconds: 5));
    //throw Error();
    return DummyData.tasks;
  }
}
