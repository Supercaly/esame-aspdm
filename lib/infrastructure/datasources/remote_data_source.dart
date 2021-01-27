import 'dart:io';
import 'package:aspdm_project/core/either.dart';
import 'package:aspdm_project/domain/failures/failures.dart';
import 'package:aspdm_project/domain/failures/task_failure.dart';
import 'package:aspdm_project/domain/values/task_values.dart';
import 'package:aspdm_project/domain/values/unique_id.dart';
import 'package:aspdm_project/domain/values/user_values.dart';
import 'package:aspdm_project/infrastructure/models/label_model.dart';
import 'package:aspdm_project/infrastructure/models/task_model.dart';
import 'package:aspdm_project/infrastructure/models/user_model.dart';
import 'package:aspdm_project/domain/failures/server_failure.dart';
import 'package:aspdm_project/locator.dart';
import 'package:aspdm_project/services/log_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

/// Class representing the data source of the entire application.
/// This class has the purpose to receive data from the remote server
/// and send to him the one that the app generates.
class RemoteDataSource {
  /// Base url of the API endpoint.
  static const String _baseUrl = "aspdm-project-server.glitch.me";

  Dio _dio;
  LogService _logService;

  RemoteDataSource()
      : _dio = Dio(BaseOptions(baseUrl: Uri.https(_baseUrl, "api").toString())),
        _logService = locator<LogService>();

  @visibleForTesting
  RemoteDataSource.test(this._dio, this._logService);

  /// Close the connection to the data source.
  void close() {
    _dio.close(force: true);
  }

  /*
   * ----------------------------------------
   *            User API
   * ----------------------------------------
   */

  /// Returns a [Either] with a [Failure] or a list of all [UserModel]s.
  Future<Either<Failure, List<UserModel>>> getUsers() async {
    final res = await get("/users");
    return res.flatMap((right) {
      if (right.data == null) return Either.right(List<UserModel>.empty());
      return Either.right((right.data as List<dynamic>)
          .map((e) => UserModel.fromJson(e as Map<String, dynamic>))
          .toList());
    });
  }

  // TODO: This method may be unused.
  /// Returns a [Either] with a [Failure] or a [UserModel] with given [userId].
  Future<Either<Failure, UserModel>> getUser(UniqueId userId) async {
    assert(userId != null);

    if (userId.value.isLeft())
      return Either.left(
          ServerFailure.invalidArgument("userId", received: userId));

    final res = await get("/user/${userId.value.getOrCrash()}");
    return res.flatMap((right) {
      // TODO: put real failure here
      if (right.data == null)
        return Either.left(
            ServerFailure.unexpectedError("Failure not implemented"));
      return Either.right(
          UserModel.fromJson(right.data as Map<String, dynamic>));
    });
  }

  /// Authenticate a user with given [email] and [password].
  /// Returns a [Either] with a [InvalidUserFailure] or the corresponding [UserModel]
  /// if the credentials are correct.
  Future<Either<Failure, UserModel>> authenticate(
    EmailAddress email,
    Password password,
  ) async {
    assert(email != null);
    assert(password != null);

    final res = await post("/authenticate", {
      "email": email.value.getOrCrash(),
      "password": password.value.getOrCrash(),
    });
    return res.flatMap((right) {
      if (right.data == null)
        return Either.left(
            InvalidUserFailure(email: email, password: password));
      return Either.right(
          UserModel.fromJson(right.data as Map<String, dynamic>));
    });
  }

  /*
   * ----------------------------------------
   *            Label API
   * ----------------------------------------
   */

  /// Returns a [Either] with a [Failure] or a list of all [LabelModel]s.
  Future<Either<Failure, List<LabelModel>>> getLabels() async {
    final res = await get("/labels");
    return res.flatMap((right) {
      if (right.data == null) return Either.right(List<LabelModel>.empty());
      return Either.right((right.data as List<dynamic>)
          .map((e) => LabelModel.fromJson(e as Map<String, dynamic>))
          .toList());
    });
  }

  /*
   * ----------------------------------------
   *            TaskModel API
   * ----------------------------------------
   */

  /// Returns a [Either] with a [Failure] or a list of all [TaskModel]s
  /// that are not archived.
  Future<Either<Failure, List<TaskModel>>> getUnarchivedTasks() async {
    final res = await get("/list");
    return res.flatMap((right) {
      if (right.data == null) return Either.right(List<TaskModel>.empty());
      return Either.right((right.data as List<dynamic>)
          .map((e) => TaskModel.fromJson(e as Map<String, dynamic>))
          .toList());
    });
  }

  /// Returns a [Either] with a [Failure] or a list of all [TaskModel]s
  /// that are archived.
  Future<Either<Failure, List<TaskModel>>> getArchivedTasks() async {
    final res = await get("/list/archived");
    return res.flatMap((right) {
      if (right.data == null) return Either.right(List<TaskModel>.empty());
      return Either.right((right.data as List<dynamic>)
          .map((e) => TaskModel.fromJson(e as Map<String, dynamic>))
          .toList());
    });
  }

  /// Returns a [Either] with a [Failure] or a [TaskModel] with given [taskId].
  Future<Either<Failure, TaskModel>> getTask(UniqueId taskId) async {
    assert(taskId != null);

    if (taskId.value.isLeft())
      return Either.left(
          ServerFailure.invalidArgument("taskId", received: taskId));

    final res = await get("/task/${taskId.value.getOrCrash()}");
    return res.flatMap((right) {
      if (right.data == null) return Either.right(null);
      return Either.right(
          TaskModel.fromJson(right.data as Map<String, dynamic>));
    });
  }

  /// Archive/Unarchive a [TaskModel] with given [taskId].
  /// Returns a [Either] with a [Failure] or the updated [TaskModel].
  Future<Either<Failure, TaskModel>> archive(
    UniqueId taskId,
    UniqueId userId,
    Toggle archive,
  ) async {
    assert(taskId != null);
    assert(userId != null);
    assert(archive != null);

    if (taskId.value.isLeft())
      return Either.left(
          ServerFailure.invalidArgument("taskId", received: taskId));
    if (userId.value.isLeft())
      return Either.left(
          ServerFailure.invalidArgument("userId", received: userId));
    if (archive.value.isLeft())
      return Either.left(
          ServerFailure.invalidArgument("archive", received: archive));

    final res = await post("/task/archive", {
      "task": taskId.value.getOrCrash(),
      "user": userId.value.getOrCrash(),
      "archive": archive.value.getOrCrash(),
    });
    return res.flatMap((right) {
      if (right.data == null)
        return Either.left(archive.value.getOrCrash()
            ? TaskFailure.archiveFailure(taskId)
            : TaskFailure.unarchiveFailure(taskId));
      return Either.right(
          TaskModel.fromJson(right.data as Map<String, dynamic>));
    });
  }

  /// Creates a new task from a given [TaskModel].
  /// Returns a [Either] with a [Failure] or the new [TaskModel].
  Future<Either<Failure, TaskModel>> postTask(
    TaskModel newTask,
    UniqueId userId,
  ) async {
    assert(userId != null);

    if (newTask == null)
      return Either.left(
          ServerFailure.invalidArgument("newTask", received: newTask));
    if (userId.value.isLeft())
      return Either.left(
          ServerFailure.invalidArgument("userId", received: userId));

    final jsonTask = newTask.toJson();
    final m = {
      "title": jsonTask['title'],
      "description": jsonTask['description'],
      "author": userId.value.getOrNull(),
      "members": jsonTask['members'],
      "labels": jsonTask['labels'],
      "expire_date": jsonTask['expire_date'],
      "checklists": newTask.checklists
          ?.map((e) => {
                "title": e.title,
                "items": e.items?.map((i) => i.item)?.toList(),
              })
          ?.toList(),
    };
    print(m);
    final res = await post("/task", m);
    return res.flatMap((right) {
      // TODO: put real failure here
      if (right.data == null)
        return Either.left(
            ServerFailure.unexpectedError("Failure not implemented"));
      return Either.right(
          TaskModel.fromJson(right.data as Map<String, dynamic>));
    });
  }

  /// Updates an existing task from a given [TaskModel].
  /// Returns a [Either] with a [Failure] or the new [TaskModel].
  Future<Either<Failure, TaskModel>> patchTask(TaskModel newTask) async {
    if (newTask == null)
      return Either.left(
          ServerFailure.invalidArgument("newTask", received: newTask));

    // TODO(#37): Fix wrong PATCH task parameters
    final res = await patch("/task", newTask.toJson());
    return res.flatMap((right) {
      // TODO: put real failure here
      if (right.data == null)
        return Either.left(
            ServerFailure.unexpectedError("Failure not implemented"));
      return Either.right(
          TaskModel.fromJson(right.data as Map<String, dynamic>));
    });
  }

  /*
   * ----------------------------------------
   *            Comment API
   * ----------------------------------------
   */

  /// Adds a new comment under a [TaskModel] with given [taskId].
  /// Returns a [Either] with a [Failure] or the updated [TaskModel].
  Future<Either<Failure, TaskModel>> postComment(
    UniqueId taskId,
    UniqueId userId,
    CommentContent content,
  ) async {
    assert(taskId != null);
    assert(userId != null);
    assert(content != null);

    if (taskId.value.isLeft())
      return Either.left(
          ServerFailure.invalidArgument("taskId", received: taskId));
    if (userId.value.isLeft())
      return Either.left(
          ServerFailure.invalidArgument("userId", received: userId));
    if (content.value.isLeft())
      return Either.left(
          ServerFailure.invalidArgument("content", received: content));

    final res = await post("/comment", {
      "task": taskId.value.getOrCrash(),
      "comment": {
        "author": userId.value.getOrCrash(),
        "content": content.value.getOrCrash(),
      },
    });
    return res.flatMap((right) {
      if (right.data == null)
        return Either.left(TaskFailure.newCommentFailure());
      return Either.right(
          TaskModel.fromJson(right.data as Map<String, dynamic>));
    });
  }

  /// Deletes a comment under a [TaskModel] with given [taskId].
  /// Returns a [Either] with a [Failure] or the updated [TaskModel].
  Future<Either<Failure, TaskModel>> deleteComment(
    UniqueId taskId,
    UniqueId commentId,
    UniqueId userId,
  ) async {
    assert(taskId != null);
    assert(commentId != null);
    assert(userId != null);

    if (taskId.value.isLeft())
      return Either.left(
          ServerFailure.invalidArgument("taskId", received: taskId));
    if (commentId.value.isLeft())
      return Either.left(
          ServerFailure.invalidArgument("commentId", received: commentId));
    if (userId.value.isLeft())
      return Either.left(
          ServerFailure.invalidArgument("userId", received: userId));

    final res = await delete("/comment", {
      "task": taskId.value.getOrCrash(),
      "user": userId.value.getOrCrash(),
      "comment": commentId.value.getOrCrash(),
    });
    return res.flatMap((right) {
      if (right.data == null)
        return Either.left(TaskFailure.deleteCommentFailure(commentId));
      return Either.right(
          TaskModel.fromJson(right.data as Map<String, dynamic>));
    });
  }

  /// Updates a comment under a [TaskModel] with given [taskId].
  /// Returns a [Either] with a [Failure] or the updated [TaskModel].
  Future<Either<Failure, TaskModel>> patchComment(
    UniqueId taskId,
    UniqueId commentId,
    UniqueId userId,
    CommentContent newContent,
  ) async {
    assert(taskId != null);
    assert(commentId != null);
    assert(userId != null);
    assert(newContent != null);

    if (taskId.value.isLeft())
      return Either.left(
          ServerFailure.invalidArgument("taskId", received: taskId));
    if (commentId.value.isLeft())
      return Either.left(
          ServerFailure.invalidArgument("commentId", received: commentId));
    if (userId.value.isLeft())
      return Either.left(
          ServerFailure.invalidArgument("userId", received: userId));
    if (newContent.value.isLeft())
      return Either.left(
          ServerFailure.invalidArgument("newContent", received: newContent));

    final res = await patch("/comment", {
      "task": taskId.value.getOrCrash(),
      "user": userId.value.getOrCrash(),
      "comment": commentId.value.getOrCrash(),
      "content": newContent.value.getOrCrash(),
    });
    return res.flatMap((right) {
      if (right.data == null)
        return Either.left(TaskFailure.editCommentFailure(commentId));
      return Either.right(
          TaskModel.fromJson(right.data as Map<String, dynamic>));
    });
  }

  /// Likes a comment under a [TaskModel] with given [taskId].
  /// Returns a [Either] with a [Failure] or the updated [TaskModel].
  Future<Either<Failure, TaskModel>> likeComment(
    UniqueId taskId,
    UniqueId commentId,
    UniqueId userId,
  ) async {
    assert(taskId != null);
    assert(commentId != null);
    assert(userId != null);

    if (taskId.value.isLeft())
      return Either.left(
          ServerFailure.invalidArgument("taskId", received: taskId));
    if (commentId.value.isLeft())
      return Either.left(
          ServerFailure.invalidArgument("commentId", received: commentId));
    if (userId.value.isLeft())
      return Either.left(
          ServerFailure.invalidArgument("userId", received: userId));

    final res = await post("/comment/like", {
      "task": taskId.value.getOrCrash(),
      "user": userId.value.getOrCrash(),
      "comment": commentId.value.getOrCrash(),
    });
    return res.flatMap((right) {
      if (right.data == null)
        return Either.left(TaskFailure.likeFailure(commentId));
      return Either.right(
          TaskModel.fromJson(right.data as Map<String, dynamic>));
    });
  }

  /// Dislikes a comment under a [TaskModel] with given [taskId].
  /// Returns a [Either] with a [Failure] or the updated [TaskModel].
  Future<Either<Failure, TaskModel>> dislikeComment(
    UniqueId taskId,
    UniqueId commentId,
    UniqueId userId,
  ) async {
    assert(taskId != null);
    assert(commentId != null);
    assert(userId != null);

    if (taskId.value.isLeft())
      return Either.left(
          ServerFailure.invalidArgument("taskId", received: taskId));
    if (commentId.value.isLeft())
      return Either.left(
          ServerFailure.invalidArgument("commentId", received: commentId));
    if (userId.value.isLeft())
      return Either.left(
          ServerFailure.invalidArgument("userId", received: userId));

    final res = await post("/comment/dislike", {
      "task": taskId.value.getOrCrash(),
      "user": userId.value.getOrCrash(),
      "comment": commentId.value.getOrCrash(),
    });
    return res.flatMap((right) {
      if (right.data == null)
        return Either.left(TaskFailure.dislikeFailure(commentId));
      return Either.right(
          TaskModel.fromJson(right.data as Map<String, dynamic>));
    });
  }

  /// Mark a checklist's item of a [TaskModel] with given [taskId] as complete.
  /// Returns a [Either] with a [Failure] or the updated [TaskModel].
  Future<Either<Failure, TaskModel>> check(
    UniqueId taskId,
    UniqueId userId,
    UniqueId checklistId,
    UniqueId itemId,
    Toggle checked,
  ) async {
    assert(taskId != null);
    assert(userId != null);
    assert(checklistId != null);
    assert(itemId != null);
    assert(checked != null);

    if (taskId.value.isLeft())
      return Either.left(
          ServerFailure.invalidArgument("taskId", received: taskId));
    if (userId.value.isLeft())
      return Either.left(
          ServerFailure.invalidArgument("userId", received: userId));
    if (checklistId.value.isLeft())
      return Either.left(
          ServerFailure.invalidArgument("checklistId", received: checklistId));
    if (itemId.value.isLeft())
      return Either.left(
          ServerFailure.invalidArgument("itemId", received: itemId));
    if (checked.value.isLeft())
      return Either.left(
          ServerFailure.invalidArgument("checked", received: checked));

    final res = await post("/task/check", {
      "task": taskId.value.getOrCrash(),
      "user": userId.value.getOrCrash(),
      "checklist": checklistId.value.getOrCrash(),
      "item": itemId.value.getOrCrash(),
      "checked": checked.value.getOrCrash(),
    });
    return res.flatMap((right) {
      if (right.data == null)
        return Either.left(TaskFailure.itemCompleteFailure(itemId));
      return Either.right(
          TaskModel.fromJson(right.data as Map<String, dynamic>));
    });
  }

  /*
   * ----------------------------------------
   *            Internal HTTP methods
   * ----------------------------------------
   */

  /// Returns the correct [ServerFailure] from the
  /// given [DioError].
  ///
  /// The error is managed in this way:
  /// - no internet if [SocketException]
  /// - format error if [FormatException]
  /// - bad request if statusCode 400
  /// - internal error if statusCode 500
  /// - unexpected error other errors
  @visibleForTesting
  ServerFailure getFailure(DioError e) {
    switch (e.type) {
      case DioErrorType.RESPONSE:
        switch (e.response?.statusCode) {
          case 400:
            return ServerFailure.badRequest(e.response?.data);
          case 500:
            return ServerFailure.internalError(e.response?.data);
          default:
            return ServerFailure.unexpectedError(
                "Received status code: ${e.response?.statusCode}");
        }
        break;
      case DioErrorType.DEFAULT:
        if (e.error != null && e.error is SocketException)
          return ServerFailure.noInternet();
        else if (e.error != null && e.error is FormatException)
          return ServerFailure.formatError(
              (e.error as FormatException).message);
        return ServerFailure.unexpectedError(e.message);
        break;
      default:
        return ServerFailure.unexpectedError(e.message);
        break;
    }
  }

  /// Run a HTTP request with method GET to the given [url].
  /// Returns the JSON response or throws a [ServerFailure].
  @visibleForTesting
  Future<Either<Failure, Response<dynamic>>> get(String url) async {
    try {
      return Either.right(await _dio.get(url));
    } on DioError catch (e) {
      final failure = getFailure(e);
      _logService.error("DataSource get: $failure");
      return Either.left(failure);
    }
  }

  /// Run a HTTP request with method POST to the given [url] with
  /// given [body] parameters.
  /// Returns the JSON response or throws a [Failure].
  @visibleForTesting
  Future<Either<Failure, Response<dynamic>>> post(
      String url, Map<String, dynamic> body) async {
    try {
      return Either.right(await _dio.post(url, data: body));
    } on DioError catch (e) {
      final failure = getFailure(e);
      _logService.error("DataSource post: $failure");
      return Either.left(failure);
    }
  }

  /// Run a HTTP request with method PATCH to the given [url] with
  /// given [body] parameters.
  /// Returns the JSON response or throws a [Failure].
  @visibleForTesting
  Future<Either<Failure, Response<dynamic>>> patch(
      String url, Map<String, dynamic> body) async {
    try {
      return Either.right(await _dio.patch(url, data: body));
    } on DioError catch (e) {
      final failure = getFailure(e);
      _logService.error("DataSource patch: $failure");
      return Either.left(failure);
    }
  }

  /// Run a HTTP request with method DELETE to the given [url] with
  /// given [body] parameters.
  /// Returns the JSON response or throws a [Failure].
  @visibleForTesting
  Future<Either<Failure, Response<dynamic>>> delete(
    String url,
    Map<String, dynamic> body,
  ) async {
    try {
      return Either.right(await _dio.delete(url, data: body));
    } on DioError catch (e) {
      final failure = getFailure(e);
      _logService.error("DataSource delete: $failure");
      return Either.left(failure);
    }
  }
}
