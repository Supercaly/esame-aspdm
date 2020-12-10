import 'package:aspdm_project/model/task.dart';

class HomeRepository {
  Future<List<Task>> getTasks() async {
    await Future.delayed(Duration(seconds: 5));
    //throw Error();
    return List.from([
      {
        "id": "0",
        "title": "title",
        "description": "description",
        "labels": [
          {"color": "FFFF0000"}
        ],
      },
      {
        "id": "1",
        "title": "title",
        "labels": [
          {"color": "FFFF0000"}
        ],
        "members": [
          {
            "id": "id",
            "name": "name",
            "email": "email",
          }
        ],
        "expire_date": DateTime.now().toIso8601String(),
        "checklists": [
          {"title": "ciao"}
        ],
      },
      {
        "id": "2",
        "title": "title",
        "description": "description",
        "labels": [
          {"color": "FFFF0000"},
          {"color": "FF00FF00"},
          {"color": "FF0000FF"},
        ],
        "members": [
          {
            "id": "id",
            "name": "name",
            "email": "email",
          }
        ],
        "expire_date": DateTime.now().toIso8601String(),
        "checklists": [
          {"title": "ciao"}
        ],
        "comments": [
          {
            "id": "comment1",
            "content": "message body",
            "user": {
              "id": "id",
              "name": "name",
              "email": "email",
            },
            "creation_date": DateTime.now().toIso8601String(),
          }
        ]
      },
      {
        "id": "3",
        "title": "title",
        "expire_date": DateTime.now().toIso8601String(),
      },
      {
        "id": "4",
        "title": "title",
        "description": "description",
        "labels": [
          {"color": "FFFF0000"},
          {"color": "FF00FF00"},
          {"color": "FF0000FF"},
        ],
        "members": [
          {
            "id": "id",
            "name": "name",
            "email": "email",
          }
        ],
        "comments": [
          {
            "id": "comment1",
            "content": "message body",
            "user": {
              "id": "id",
              "name": "name",
              "email": "email",
            },
            "creation_date": DateTime.now().toIso8601String(),
          }
        ]
      },
    ].map((e) => Task.fromJson(e)));
  }
}
