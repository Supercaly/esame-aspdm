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
  /// This method throw [DioError] is some connection error happens.
  Future<User> authenticate(String email, String password) async {
    try {
      final res = await _dio.post(
        "/authenticate",
        data: {
          "email": email,
          "password": password,
        },
      );
      if (res.data != null) return User.fromJson(res.data);
      return null;
    } on DioError catch (e) {
      if (e.response != null && e.response.statusCode == 400)
        _logService.error(
            "DataSource.getUnarchivedTasks: Bad request: ${e.response.data}");
      else if (e.error is SocketException)
        _logService
            .error("DataSource.getUnarchivedTasks: No internet connection!");
      rethrow;
    }
  }

  Future<List<Task>> getUnarchivedTasks() async {
    try {
      final res = await _dio.get("/list");
      if (res.data != null) {
        final a = (res.data as List<dynamic>)
            .map((e) => Task.fromJson(e as Map<String, dynamic>))
            .toList();
        print(a);
        return a;
      } else
        return null;
    } on DioError catch (e) {
      if (e.response != null && e.response.statusCode == 400)
        _logService.error(
            "DataSource.getUnarchivedTasks: Bad request: ${e.response.data}");
      else if (e.error is SocketException)
        _logService
            .error("DataSource.getUnarchivedTasks: No internet connection!");
      rethrow;
    }
  }

  Future getArchivedTasks() {}
}
