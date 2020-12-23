import 'dart:io';
import 'package:aspdm_project/locator.dart';
import 'package:aspdm_project/model/user.dart';
import 'package:aspdm_project/model/task.dart';
import 'package:aspdm_project/services/log_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

/// Class representing the data source of the entire application.
/// This class has the purpose to receive data from the remote server
/// and send to him the one that the app generates.
class DataSource {
  /// Base url of the API endpoint.
  static const String baseUrl = "aspdm-project-server.glitch.me";

  Dio _dio;
  LogService _logService;

  DataSource()
      : _dio = Dio(BaseOptions(baseUrl: Uri.https(baseUrl, "api").toString())),
        _logService = locator<LogService>();

  @visibleForTesting
  DataSource.test(this._dio, this._logService);

  /// Close the connection to the data source.
  void close() {
    _dio.close(force: true);
  }

  /// Authenticate a user with given [email] and [password].
  /// If the credentials are valid the corresponding [User] is returned,
  /// otherwise null is returned.
  /// This method throw [DioError] if some connection error happens.
  Future<User> authenticate(String email, String password) async {
    final res = await _post("/authenticate", {
      "email": email,
      "password": password,
    });
    if (res.data != null) return User.fromJson(res.data);
    return null;
  }

  /// Returns a list of all [Task]s that are not archived.
  /// This method throw [DioError] if some connection error happens.
  Future<List<Task>> getUnarchivedTasks() async {
    final res = await _get("/list");
    if (res.data != null)
      return (res.data as List<dynamic>)
          .map((e) => Task.fromJson(e as Map<String, dynamic>))
          .toList();
    else
      return null;
  }

  /// Returns a list of all [Task]s that are archived.
  /// This method throw [DioError] if some connection error happens.
  Future<List<Task>> getArchivedTasks() async {
    final res = await _get("/list/archived");
    if (res.data != null)
      return (res.data as List<dynamic>)
          .map((e) => Task.fromJson(e as Map<String, dynamic>))
          .toList();
    else
      return null;
  }

  /// Returns a [Task] with given [taskId].
  /// This method throw [DioError] if some connection error happens.
  Future<Task> getTask(String taskId) async {
    assert(taskId != null);

    final res = await _get("/task/$taskId");
    if (res.data != null)
      return Task.fromJson(res.data as Map<String, dynamic>);
    else
      return null;
  }

  /// Adds a new comment under a [Task] with given [taskId].
  /// This method will return the updated [Task].
  /// This method throw [DioError] if some connection error happens.
  Future<Task> postComment(String taskId, String userId, String content) async {
    assert(taskId != null);
    assert(userId != null);
    assert(content != null);

    final res = await _post("/comment", {
      "task": taskId,
      "comment": {
        "author": userId,
        "content": content,
      },
    });
    if (res.data != null)
      return Task.fromJson(res.data as Map<String, dynamic>);
    else
      return null;
  }

  /// Deletes a comment under a [Task] with given [taskId].
  /// This method will return the updated [Task].
  /// This method throw [DioError] if some connection error happens.
  Future<Task> deleteComment(
    String taskId,
    String commentId,
    String userId,
  ) async {
    assert(taskId != null);
    assert(commentId != null);
    assert(userId != null);

    final res = await _delete("/comment", {
      "task": taskId,
      "user": userId,
      "comment": commentId,
    });
    if (res.data != null)
      return Task.fromJson(res.data as Map<String, dynamic>);
    else
      return null;
  }

  /// Updates a comment under a [Task] with given [taskId].
  /// This method will return the updated [Task].
  /// This method throw [DioError] if some connection error happens.
  Future<Task> patchComment(
    String taskId,
    String commentId,
    String userId,
    String newContent,
  ) async {
    assert(taskId != null);
    assert(commentId != null);
    assert(userId != null);
    assert(newContent != null);

    final res = await _patch("/comment", {
      "task": taskId,
      "user": userId,
      "comment": commentId,
      "content": newContent,
    });
    if (res.data != null)
      return Task.fromJson(res.data as Map<String, dynamic>);
    else
      return null;
  }

  /// Likes a comment under a [Task] with given [taskId].
  /// This method will return the updated [Task].
  /// This method throw [DioError] if some connection error happens.
  Future<Task> likeComment(
    String taskId,
    String commentId,
    String userId,
  ) async {
    assert(taskId != null);
    assert(commentId != null);
    assert(userId != null);

    final res = await _post("/comment/like", {
      "task": taskId,
      "user": userId,
      "comment": commentId,
    });
    if (res.data != null)
      return Task.fromJson(res.data as Map<String, dynamic>);
    else
      return null;
  }

  /// Dislikes a comment under a [Task] with given [taskId].
  /// This method will return the updated [Task].
  /// This method throw [DioError] if some connection error happens.
  Future<Task> dislikeComment(
    String taskId,
    String commentId,
    String userId,
  ) async {
    assert(taskId != null);
    assert(commentId != null);
    assert(userId != null);

    final res = await _post("/comment/dislike", {
      "task": taskId,
      "user": userId,
      "comment": commentId,
    });
    if (res.data != null)
      return Task.fromJson(res.data as Map<String, dynamic>);
    else
      return null;
  }

  /// Archive/Unarchive a [Task] with given [taskId].
  /// This method will return the updated [Task].
  /// This method throw [DioError] if some connection error happens.
  Future<Task> archive(String taskId, String userId, bool archive) async {
    assert(taskId != null);
    assert(userId != null);

    final res = await _post("/task/archive", {
      "task": taskId,
      "user": userId,
      "archive": archive,
    });
    if (res.data != null)
      return Task.fromJson(res.data as Map<String, dynamic>);
    else
      return null;
  }

  /// Run a HTTP request with method GET to the given [url].
  /// Returns the JSON response or throws a [DioError].
  Future<dynamic> _get(String url) async {
    try {
      return await _dio.get(url);
    } on DioError catch (e) {
      if (e.response != null && e.response.statusCode == 400)
        _logService.error("DataSource get: Bad request: ${e.response.data}");
      else if (e.error is SocketException)
        _logService.error("DataSource get: No internet connection!");
      rethrow;
    }
  }

  /// Run a HTTP request with method POST to the given [url] with
  /// given [body] parameters.
  /// Returns the JSON response or throws a [DioError].
  Future<dynamic> _post(String url, Map<String, dynamic> body) async {
    try {
      return await _dio.post(url, data: body);
    } on DioError catch (e) {
      if (e.response != null && e.response.statusCode == 400)
        _logService.error("DataSource post: Bad request: ${e.response.data}");
      else if (e.error is SocketException)
        _logService.error("DataSource post: No internet connection!");
      rethrow;
    }
  }

  /// Run a HTTP request with method PATCH to the given [url] with
  /// given [body] parameters.
  /// Returns the JSON response or throws a [DioError].
  Future<dynamic> _patch(String url, Map<String, dynamic> body) async {
    try {
      return await _dio.patch(url, data: body);
    } on DioError catch (e) {
      if (e.response != null && e.response.statusCode == 400)
        _logService.error("DataSource patch: Bad request: ${e.response.data}");
      else if (e.error is SocketException)
        _logService.error("DataSource patch: No internet connection!");
      rethrow;
    }
  }

  /// Run a HTTP request with method DELETE to the given [url] with
  /// given [body] parameters.
  /// Returns the JSON response or throws a [DioError].
  Future<dynamic> _delete(String url, Map<String, dynamic> body) async {
    try {
      return await _dio.delete(url, data: body);
    } on DioError catch (e) {
      if (e.response != null && e.response.statusCode == 400)
        _logService.error("DataSource delete: Bad request: ${e.response.data}");
      else if (e.error is SocketException)
        _logService.error("DataSource delete: No internet connection!");
      rethrow;
    }
  }
}
