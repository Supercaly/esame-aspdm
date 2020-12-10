import 'package:aspdm_project/model/task.dart';

class TaskRepository {
  final _dummyTaskMap = {
    "id": "mock_id",
    "title": "Mock Title",
    "description": "Mock Description",
    "labels": [
      {
        "color": "red",
        "label": "Label",
      },
      {
        "color": "green",
        "label": "Label",
      },
      {
        "color": "blue",
        "label": "Label",
      },
    ],
    "members": [],
    "expireDate": "0",
    "checklists": [],
    "comments": [
      {
        "id": "comment1",
        "user": {
          "id": "1",
          "name": "Test A",
          "email": "TestA@email.com",
        },
        "content": "ciao",
        "liked": false,
        "likes": 0,
        "creation_date": DateTime.now().toIso8601String(),
        "disliked": false,
        "dislikes": 0,
      },
      {
        "id": "comment2",
        "user": {
          "id": "1",
          "name": "Test A",
          "email": "TestA@email.com",
        },
        "content": "ciao ciao",
        "liked": true,
        "likes": 10,
        "creation_date": DateTime.now().toIso8601String(),
        "disliked": false,
        "dislikes": 0,
      },
      {
        "id": "comment3",
        "user": {
          "id": "1",
          "name": "Test A",
          "email": "TestA@email.com",
        },
        "content": "ciao ciao ciao",
        "creation_date": DateTime.now().toIso8601String(),
        "liked": false,
        "likes": 10,
        "disliked": true,
        "dislikes": 1,
      },
    ],
  };

  Future<Task> getTask(String id) async {
    assert(id != null);

    await Future.delayed(Duration(seconds: 5));
    return Task.fromJson(_dummyTaskMap);
  }

  Future<Task> deleteComment(String commentId, String userId) async {
    final Map<String, dynamic> comment =
        (_dummyTaskMap['comments'] as List).firstWhere(
      (element) => element['id'] == commentId,
      orElse: () => null,
    );
    if (comment == null) throw Exception("No comment with id $commentId");

    final idx = (_dummyTaskMap['comments'] as List).indexOf(comment);
    (_dummyTaskMap['comments'] as List).removeAt(idx);

    return Task.fromJson(_dummyTaskMap);
  }

  Future<Task> editComment(
    String commentId,
    String content,
    String userId,
  ) async {
    final Map<String, dynamic> comment =
        (_dummyTaskMap['comments'] as List).firstWhere(
      (element) => element['id'] == commentId,
      orElse: () => null,
    );

    if (comment == null) throw Exception("No comment with id $commentId");

    final idx = (_dummyTaskMap['comments'] as List).indexOf(comment);
    (_dummyTaskMap['comments'] as List)[idx] = {
      "id": comment['id'],
      "content": content,
      "user": comment['user'],
      "creation_date": comment['creation_date'],
      "dislikes": comment['dislikes'],
      "disliked": comment['disliked'],
      "likes": comment['likes'],
      "liked": comment['liked'],
    };
    return Task.fromJson(_dummyTaskMap);
  }

  Future<Task> likeComment(String commentId, String userId) async {
    final Map<String, dynamic> comment =
        (_dummyTaskMap['comments'] as List).firstWhere(
      (element) => element['id'] == commentId,
      orElse: () => null,
    );

    if (comment == null) throw Exception("No comment with id $commentId");

    final idx = (_dummyTaskMap['comments'] as List).indexOf(comment);
    int dislikes = comment['dislikes'];
    bool disliked = comment['disliked'];

    if (disliked) {
      dislikes--;
      disliked = false;
    }
    (_dummyTaskMap['comments'] as List)[idx] = {
      "id": comment['id'],
      "user": comment['user'],
      "creation_date": comment['creation_date'],
      "content": comment['content'],
      "dislikes": dislikes,
      "disliked": disliked,
      "likes": comment['likes'] + 1,
      "liked": true,
    };

    return Task.fromJson(_dummyTaskMap);
  }

  Future<Task> dislikeComment(String commentId, String userId) async {
    final Map<String, dynamic> comment =
        (_dummyTaskMap['comments'] as List).firstWhere(
      (element) => element['id'] == commentId,
      orElse: () => null,
    );

    if (comment == null) throw Exception("No comment with id $commentId");

    final idx = (_dummyTaskMap['comments'] as List).indexOf(comment);
    int likes = comment['likes'];
    bool liked = comment['liked'];

    if (liked) {
      likes--;
      liked = false;
    }
    (_dummyTaskMap['comments'] as List)[idx] = {
      "id": comment['id'],
      "user": comment['user'],
      "creation_date": comment['creation_date'],
      "content": comment['content'],
      "dislikes": comment['dislikes'] + 1,
      "disliked": true,
      "likes": likes,
      "liked": liked,
    };
    return Task.fromJson(_dummyTaskMap);
  }
}
