import 'package:aspdm_project/model/task.dart';
import 'package:aspdm_project/model/user.dart';

class TaskRepository {
  final _dummyTaskMap = {
    "id": "mock_id",
    "title": "Mock Title",
    "description": "Mock Description",
    "labels": [
      {
        "color": "FFFF0000",
        "text": "Label",
      },
      {
        "color": "FF00FF00",
        "text": "Label",
      },
      {
        "color": "FF0000FF",
        "text": "Label",
      },
    ],
    "members": [
      {
        "id": "1",
        "name": "ff s",
        "email": "TestA@email.com",
      },
      {
        "id": "1",
        "name": "deb d",
        "email": "TestA@email.com",
      },
      {
        "id": "3",
        "name": "Abc",
        "email": "TestA@email.com",
      },
    ],
    "expire_date": DateTime.now().toIso8601String(),
    "checklists": [
      {
        "title": "checklist 1",
        "items": [
          {"text": "item", "checked": true},
          {"text": "item", "checked": false},
          {"text": "item", "checked": false},
          {"text": "item", "checked": false},
          {"text": "item", "checked": true},
        ]
      }
    ],
    "comments": [
      //   {
      //     "id": "comment1",
      //     "user": {
      //       "id": "1",
      //       "name": "Test A",
      //       "email": "TestA@email.com",
      //     },
      //     "content": "ciao",
      //     "liked": false,
      //     "likes": 0,
      //     "creation_date": DateTime.now().toIso8601String(),
      //     "disliked": false,
      //     "dislikes": 0,
      //   },
      //   {
      //     "id": "comment2",
      //     "user": {
      //       "id": "1",
      //       "name": "Test A",
      //       "email": "TestA@email.com",
      //     },
      //     "content": "ciao ciao",
      //     "liked": true,
      //     "likes": 10,
      //     "creation_date": DateTime.now().toIso8601String(),
      //     "disliked": false,
      //     "dislikes": 0,
      //   },
      //   {
      //     "id": "comment3",
      //     "user": {
      //       "id": "1",
      //       "name": "Test A",
      //       "email": "TestA@email.com",
      //     },
      //     "content": "ciao ciao ciao",
      //     "creation_date": DateTime.now().toIso8601String(),
      //     "liked": false,
      //     "likes": 10,
      //     "disliked": true,
      //     "dislikes": 1,
      //   },
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
    int likes = comment['likes'] + 1;
    bool liked = !comment['liked'];

    if (disliked) {
      dislikes--;
      disliked = false;
    }
    if (!liked) {
      likes -= 2;
      liked = false;
    }
    (_dummyTaskMap['comments'] as List)[idx] = {
      "id": comment['id'],
      "user": comment['user'],
      "creation_date": comment['creation_date'],
      "content": comment['content'],
      "dislikes": dislikes,
      "disliked": disliked,
      "likes": likes,
      "liked": liked,
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
    int dislikes = comment['dislikes'] + 1;
    bool disliked = !comment['disliked'];

    if (liked) {
      likes--;
      liked = false;
    }
    if (!disliked) {
      dislikes -= 2;
      disliked = false;
    }

    (_dummyTaskMap['comments'] as List)[idx] = {
      "id": comment['id'],
      "user": comment['user'],
      "creation_date": comment['creation_date'],
      "content": comment['content'],
      "dislikes": dislikes,
      "disliked": disliked,
      "likes": likes,
      "liked": liked,
    };
    return Task.fromJson(_dummyTaskMap);
  }

  Future<Task> addComment(String content, String userId) async {
    (_dummyTaskMap['comments'] as List).add({
      "id": "0",
      "user": User(userId, "name", "email").toJson(),
      "creation_date": DateTime.now().toIso8601String(),
      "content": content,
      "dislikes": 0,
      "disliked": false,
      "likes": 0,
      "liked": false,
    });
    print(_dummyTaskMap);
    return Task.fromJson(_dummyTaskMap);
  }
}
